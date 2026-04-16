package org.example.dao;

import org.example.model.marketing.WishlistItemView;
import org.example.utils.DBConnection;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class WishlistDAO {

    public Set<Long> getWishlistedProductIds(long accountId) {
        Set<Long> ids = new HashSet<>();
        String sql = "SELECT productId FROM dbo.Wishlists WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ids.add(rs.getLong("productId"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ids;
    }

    public List<WishlistItemView> getWishlistItemsByAccountIdOrderByName(long accountId) {
        List<WishlistItemView> list = new ArrayList<>();
        String sql = "SELECT w.wishlistId, w.productId, w.createdAt, p.productName, p.imageUrl, p.basePriceAmount, p.priceBaseWeightGram " +
                "FROM dbo.Wishlists w " +
                "INNER JOIN dbo.Products p ON p.productId = w.productId " +
                "WHERE w.accountId = ? " +
                "ORDER BY p.productName ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WishlistItemView item = new WishlistItemView();
                    item.setWishlistId(rs.getLong("wishlistId"));
                    item.setProductId(rs.getLong("productId"));
                    item.setProductName(rs.getString("productName"));
                    item.setImageUrl(rs.getString("imageUrl"));
                    item.setCurrentPrice(rs.getBigDecimal("basePriceAmount"));
                    item.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
                    if (rs.getTimestamp("createdAt") != null) {
                        item.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    }
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean exists(long accountId, long productId) {
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

    public boolean add(long accountId, long productId) {
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

    public boolean removeByProductId(long accountId, long productId) {
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
}
