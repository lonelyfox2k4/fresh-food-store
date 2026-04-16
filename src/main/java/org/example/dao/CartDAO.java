package org.example.dao;

import org.example.model.order.CartItemView;
import org.example.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    public long findOrCreateCartIdByAccountId(long accountId) {
        String findSql = "SELECT cartId FROM dbo.Carts WHERE accountId = ?";
        String createSql = "INSERT INTO dbo.Carts (accountId) VALUES (?)";

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setLong(1, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        return rs.getLong("cartId");
                    }
                }
            }

            try (PreparedStatement ps = conn.prepareStatement(createSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, accountId);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getLong(1);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1L;
    }

    public Long getDefaultPackIdByProductId(long productId) {
        String sql = "SELECT TOP 1 productPackId FROM dbo.ProductPacks WHERE productId = ? AND status = 1 ORDER BY packWeightGram ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong("productPackId");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addOrIncreaseItem(long accountId, long productPackId, int quantity) {
        String findItemSql = "SELECT ci.cartItemId, ci.quantity FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "WHERE c.accountId = ? AND ci.productPackId = ?";
        String updateSql = "UPDATE dbo.CartItems SET quantity = ?, updatedAt = SYSUTCDATETIME() WHERE cartItemId = ?";
        String insertSql = "INSERT INTO dbo.CartItems (cartId, productPackId, quantity) VALUES (?, ?, ?)";
        String updateCartSql = "UPDATE dbo.Carts SET updatedAt = SYSUTCDATETIME() WHERE cartId = ?";

        long cartId = findOrCreateCartIdByAccountId(accountId);
        if (cartId <= 0) {
            return false;
        }

        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(findItemSql)) {
                ps.setLong(1, accountId);
                ps.setLong(2, productPackId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        long cartItemId = rs.getLong("cartItemId");
                        int currentQty = rs.getInt("quantity");
                        try (PreparedStatement ups = conn.prepareStatement(updateSql)) {
                            ups.setInt(1, currentQty + quantity);
                            ups.setLong(2, cartItemId);
                            ups.executeUpdate();
                        }
                    } else {
                        try (PreparedStatement ips = conn.prepareStatement(insertSql)) {
                            ips.setLong(1, cartId);
                            ips.setLong(2, productPackId);
                            ips.setInt(3, quantity);
                            ips.executeUpdate();
                        }
                    }
                }
            }

            try (PreparedStatement cps = conn.prepareStatement(updateCartSql)) {
                cps.setLong(1, cartId);
                cps.executeUpdate();
            }
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CartItemView> getCartItemsByAccountId(long accountId) {
        List<CartItemView> list = new ArrayList<>();
        String sql = "SELECT ci.cartItemId, pp.productPackId, p.productId, p.productName, p.imageUrl, pp.packWeightGram, " +
                "CAST((p.basePriceAmount * 1.0 * pp.packWeightGram / NULLIF(p.priceBaseWeightGram, 0)) AS DECIMAL(18,2)) AS unitPrice, " +
                "ci.quantity " +
                "FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "INNER JOIN dbo.ProductPacks pp ON pp.productPackId = ci.productPackId " +
                "INNER JOIN dbo.Products p ON p.productId = pp.productId " +
                "WHERE c.accountId = ? " +
                "ORDER BY ci.addedAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItemView item = new CartItemView();
                    item.setCartItemId(rs.getLong("cartItemId"));
                    item.setProductPackId(rs.getLong("productPackId"));
                    item.setProductId(rs.getLong("productId"));
                    item.setProductName(rs.getString("productName"));
                    item.setImageUrl(rs.getString("imageUrl"));
                    item.setPackWeightGram(rs.getInt("packWeightGram"));
                    item.setUnitPrice(rs.getBigDecimal("unitPrice"));
                    item.setQuantity(rs.getInt("quantity"));
                    BigDecimal unitPrice = item.getUnitPrice() == null ? BigDecimal.ZERO : item.getUnitPrice();
                    item.setLineTotal(unitPrice.multiply(BigDecimal.valueOf(item.getQuantity())));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public BigDecimal getCartTotalAmount(long accountId) {
        String sql = "SELECT SUM(CAST((p.basePriceAmount * 1.0 * pp.packWeightGram / NULLIF(p.priceBaseWeightGram, 0)) AS DECIMAL(18,2)) * ci.quantity) AS totalAmount " +
                "FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "INNER JOIN dbo.ProductPacks pp ON pp.productPackId = ci.productPackId " +
                "INNER JOIN dbo.Products p ON p.productId = pp.productId " +
                "WHERE c.accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next() && rs.getBigDecimal("totalAmount") != null) {
                    return rs.getBigDecimal("totalAmount");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }

    public int countCartLines(long accountId) {
        String sql = "SELECT COUNT(*) AS lineCount FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "WHERE c.accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("lineCount");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean updateItemQuantity(long accountId, long cartItemId, int quantity) {
        if (!isCartItemOwnedByAccount(accountId, cartItemId)) {
            return false;
        }
        String sql = "UPDATE dbo.CartItems SET quantity = ?, updatedAt = SYSUTCDATETIME() WHERE cartItemId = ?";
        String cartUpdateSql = "UPDATE c SET c.updatedAt = SYSUTCDATETIME() FROM dbo.Carts c " +
                "INNER JOIN dbo.CartItems ci ON ci.cartId = c.cartId WHERE ci.cartItemId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             PreparedStatement cps = conn.prepareStatement(cartUpdateSql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, cartItemId);
            boolean ok = ps.executeUpdate() > 0;
            cps.setLong(1, cartItemId);
            cps.executeUpdate();
            return ok;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeItem(long accountId, long cartItemId) {
        if (!isCartItemOwnedByAccount(accountId, cartItemId)) {
            return false;
        }
        String sql = "DELETE FROM dbo.CartItems WHERE cartItemId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isCartItemOwnedByAccount(long accountId, long cartItemId) {
        String sql = "SELECT 1 FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "WHERE ci.cartItemId = ? AND c.accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartItemId);
            ps.setLong(2, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
