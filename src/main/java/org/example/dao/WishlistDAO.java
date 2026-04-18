package org.example.dao;

import org.example.model.catalog.Product;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class WishlistDAO {

    public List<Product> getWishlist(long accountId) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.* FROM dbo.Wishlists w " +
                     "JOIN dbo.Products p ON w.productId = p.productId " +
                     "WHERE w.accountId = ? AND p.status = 1 ORDER BY w.createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addToWishlist(long accountId, long productId) {
        if (isInWishlist(accountId, productId)) return true;
        String sql = "INSERT INTO dbo.Wishlists (accountId, productId) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean removeFromWishlist(long accountId, long productId) {
        String sql = "DELETE FROM dbo.Wishlists WHERE accountId = ? AND productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, productId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean isInWishlist(long accountId, long productId) {
        String sql = "SELECT 1 FROM dbo.Wishlists WHERE accountId = ? AND productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Product mapProduct(ResultSet rs) throws SQLException {
        Product p = new Product();
        p.setProductId(rs.getLong("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("imageUrl"));
        p.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
        p.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
        int pId = rs.getInt("expiryPricingPolicyId");
        p.setExpiryPricingPolicyId(rs.wasNull() ? null : pId);
        p.setStatus(rs.getBoolean("status"));
        return p;
    }
}
