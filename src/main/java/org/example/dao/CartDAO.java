package org.example.dao;

import org.example.dto.CartItemDTO;
import org.example.utils.DBConnection;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.*;

public class CartDAO {

    /** Get existing cart for account, or create a new one. Returns cartId. */
    public long getOrCreateCart(long accountId) {
        String selectSql = "SELECT cartId FROM dbo.Carts WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection()) {
            // Try to get existing
            try (PreparedStatement ps = conn.prepareStatement(selectSql)) {
                ps.setLong(1, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getLong("cartId");
                }
            }
            // Create new cart
            String insertSql = "INSERT INTO dbo.Carts (accountId) VALUES (?)";
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setLong(1, accountId);
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) return rs.getLong(1);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    /** Get all items in a cart, joined with product and pack data. */
    public List<CartItemDTO> getCartItems(long cartId) {
        List<CartItemDTO> list = new ArrayList<>();
        String sql = "SELECT ci.cartItemId, ci.cartId, ci.productPackId, ci.quantity, " +
                     "pp.packWeightGram, pp.productId, " +
                     "p.productName, p.imageUrl, p.basePriceAmount, p.priceBaseWeightGram, p.expiryPricingPolicyId " +
                     "FROM dbo.CartItems ci " +
                     "JOIN dbo.ProductPacks pp ON ci.productPackId = pp.productPackId " +
                     "JOIN dbo.Products p ON pp.productId = p.productId " +
                     "WHERE ci.cartId = ? ORDER BY ci.addedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItemDTO dto = new CartItemDTO();
                    dto.setCartItemId(rs.getLong("cartItemId"));
                    dto.setCartId(rs.getLong("cartId"));
                    dto.setProductPackId(rs.getLong("productPackId"));
                    dto.setProductId(rs.getLong("productId"));
                    dto.setProductName(rs.getString("productName"));
                    dto.setImageUrl(rs.getString("imageUrl"));
                    dto.setPackWeightGram(rs.getInt("packWeightGram"));
                    dto.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
                    dto.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
                    int pId = rs.getInt("expiryPricingPolicyId");
                    dto.setExpiryPricingPolicyId(rs.wasNull() ? null : pId);
                    dto.setQuantity(rs.getInt("quantity"));
                    // Compute pack price: basePriceAmount * packWeightGram / priceBaseWeightGram
                    BigDecimal packPrice = dto.getBasePriceAmount()
                            .multiply(BigDecimal.valueOf(dto.getPackWeightGram()))
                            .divide(BigDecimal.valueOf(dto.getPriceBaseWeightGram()), 2, RoundingMode.HALF_UP);
                    dto.setComputedPackBasePrice(packPrice);
                    dto.setLineTotal(packPrice.multiply(BigDecimal.valueOf(dto.getQuantity())));
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Add item to cart. If the pack is already in the cart, increment quantity.
     * Uses MSSQL IF EXISTS ... UPDATE ... ELSE ... INSERT pattern.
     */
    public boolean addItem(long cartId, long productPackId, int quantity) {
        String sql = "IF EXISTS (SELECT 1 FROM dbo.CartItems WHERE cartId = ? AND productPackId = ?) " +
                     "    UPDATE dbo.CartItems SET quantity = quantity + ?, updatedAt = SYSUTCDATETIME() " +
                     "    WHERE cartId = ? AND productPackId = ? " +
                     "ELSE " +
                     "    INSERT INTO dbo.CartItems (cartId, productPackId, quantity) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ps.setLong(2, productPackId);
            ps.setInt(3, quantity);
            ps.setLong(4, cartId);
            ps.setLong(5, productPackId);
            ps.setLong(6, cartId);
            ps.setLong(7, productPackId);
            ps.setInt(8, quantity);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Update quantity of a specific cart item. Removes it if quantity <= 0. */
    public boolean updateQuantity(long cartItemId, int quantity) {
        if (quantity <= 0) return removeItem(cartItemId);
        String sql = "UPDATE dbo.CartItems SET quantity = ?, updatedAt = SYSUTCDATETIME() WHERE cartItemId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setLong(2, cartItemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeItem(long cartItemId) {
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

    public boolean clearCart(long cartId) {
        String sql = "DELETE FROM dbo.CartItems WHERE cartId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, cartId);
            ps.executeUpdate();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /** Count total items in the cart for the badge in the header. */
    public int countItems(long accountId) {
        String sql = "SELECT ISNULL(SUM(ci.quantity), 0) " +
                     "FROM dbo.CartItems ci JOIN dbo.Carts c ON ci.cartId = c.cartId " +
                     "WHERE c.accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
