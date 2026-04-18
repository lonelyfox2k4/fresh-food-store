package org.example.dao;

import org.example.dto.ReviewDTO;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class ReviewDAO {

    public List<ReviewDTO> getReviewsByProduct(long productId) {
        List<ReviewDTO> list = new ArrayList<>();
        String sql = "SELECT pr.reviewId, pr.productId, pr.rating, pr.comment, pr.createdAt, a.fullName, " +
                     "f.response, f.respondedAt " +
                     "FROM dbo.ProductReviews pr " +
                     "JOIN dbo.Accounts a ON pr.accountId = a.accountId " +
                     "LEFT JOIN dbo.Feedbacks f ON pr.reviewId = f.reviewId " +
                     "WHERE pr.productId = ? ORDER BY pr.createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    ReviewDTO dto = new ReviewDTO();
                    dto.setReviewId(rs.getLong("reviewId"));
                    dto.setProductId(rs.getLong("productId"));
                    dto.setReviewerName(rs.getString("fullName"));
                    dto.setRating(rs.getByte("rating"));
                    dto.setComment(rs.getString("comment"));
                    if (rs.getTimestamp("createdAt") != null) {
                        dto.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                    }
                    dto.setShopReply(rs.getString("response"));
                    if (rs.getTimestamp("respondedAt") != null) {
                        dto.setRepliedAt(rs.getTimestamp("respondedAt").toLocalDateTime());
                    }
                    list.add(dto);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addReview(long productId, long accountId, byte rating, String comment) {
        String sql = "INSERT INTO dbo.ProductReviews (productId, accountId, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setLong(2, accountId);
            ps.setByte(3, rating);
            ps.setString(4, comment);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public double getAverageRating(long productId) {
        String sql = "SELECT AVG(CAST(rating AS FLOAT)) FROM dbo.ProductReviews WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getDouble(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public int countReviews(long productId) {
        String sql = "SELECT COUNT(*) FROM dbo.ProductReviews WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean canReview(long accountId, long productId) {
        String sql = "SELECT 1 FROM dbo.Orders o " +
                     "JOIN dbo.OrderItems oi ON o.orderId = oi.orderId " +
                     "JOIN dbo.ProductPacks pp ON oi.productPackId = pp.productPackId " +
                     "WHERE o.accountId = ? AND pp.productId = ? AND o.orderStatus = 5";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setLong(2, productId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next(); // Returns true if at least one delivered order exists
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
