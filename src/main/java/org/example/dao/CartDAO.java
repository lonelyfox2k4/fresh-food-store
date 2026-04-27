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
        String sql = "SELECT TOP 1 pp.productPackId " +
                "FROM dbo.ProductPacks pp " +
                "OUTER APPLY ( " +
                "    SELECT SUM(ib.quantityOnHand - ib.quantityReserved) as availableStock " +
                "    FROM dbo.InventoryBatches ib " +
                "    JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                "    WHERE gri.productPackId = pp.productPackId " +
                "      AND ib.status = 1 " +
                "      AND gri.expiryDate >= CAST(GETDATE() AS DATE) " +
                ") inv " +
                "WHERE pp.productId = ? AND pp.status = 1 AND ISNULL(inv.availableStock, 0) > 0 " +
                "ORDER BY pp.packWeightGram ASC";
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
                "ci.quantity, " +
                "ISNULL((SELECT SUM(ib.quantityOnHand - ib.quantityReserved) FROM dbo.InventoryBatches ib " +
                " JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                " WHERE gri.productPackId = pp.productPackId AND ib.status = 1 AND gri.expiryDate >= CAST(GETDATE() AS DATE)), 0) AS availableStock " +
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
                    item.setAvailableStock(rs.getInt("availableStock"));
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

    /** Retrieves detailed items for Checkout/Order placement. */
    public List<org.example.dto.CartItemDTO> getCartItemDTOsByAccountId(long accountId) {
        List<org.example.dto.CartItemDTO> list = new ArrayList<>();
        String sql = "SELECT ci.cartItemId, ci.cartId, ci.productPackId, p.productId, p.productName, p.imageUrl, " +
                "pp.packWeightGram, p.basePriceAmount, p.priceBaseWeightGram, p.expiryPricingPolicyId, ci.quantity " +
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
                    org.example.dto.CartItemDTO dto = new org.example.dto.CartItemDTO();
                    dto.setCartItemId(rs.getLong("cartItemId"));
                    dto.setCartId(rs.getLong("cartId"));
                    dto.setProductPackId(rs.getLong("productPackId"));
                    dto.setProductId(rs.getLong("productId"));
                    dto.setProductName(rs.getString("productName"));
                    dto.setImageUrl(rs.getString("imageUrl"));
                    dto.setPackWeightGram(rs.getInt("packWeightGram"));
                    dto.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
                    dto.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
                    int policyId = rs.getInt("expiryPricingPolicyId");
                    dto.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);
                    dto.setQuantity(rs.getInt("quantity"));

                    // Calculations
                    BigDecimal base = dto.getBasePriceAmount();
                    BigDecimal weight = BigDecimal.valueOf(dto.getPackWeightGram());
                    BigDecimal baseWeight = BigDecimal.valueOf(dto.getPriceBaseWeightGram());
                    
                    BigDecimal unitPrice = base.multiply(weight)
                            .divide(baseWeight, 2, java.math.RoundingMode.HALF_UP);
                    
                    dto.setComputedPackBasePrice(unitPrice);
                    dto.setLineTotal(unitPrice.multiply(BigDecimal.valueOf(dto.getQuantity())));
                    
                    list.add(dto);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean clearCart(long cartId) {
        String sql = "DELETE FROM dbo.CartItems WHERE cartId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            return ps.executeUpdate() >= 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    public int getCartItemQuantity(long accountId, long productPackId) {
        String sql = "SELECT ci.quantity FROM dbo.CartItems ci " +
                "INNER JOIN dbo.Carts c ON c.cartId = ci.cartId " +
                "WHERE c.accountId = ? AND ci.productPackId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, productPackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("quantity");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
