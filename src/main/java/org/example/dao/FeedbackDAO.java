package org.example.dao;

import org.example.model.marketing.Feedback;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public List<Feedback> getAllFeedbacks() {
        return searchFeedbacks(null);
    }

    public List<Feedback> searchFeedbacks(String keyword) {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT * FROM (" +
                "  SELECT f.feedbackId, f.accountId, f.orderId, f.reviewId, f.content, " +
                "  ISNULL(pr_link.rating, 0) as rating, " +
                "  f.response, f.status, f.createdAt, f.respondedAt, f.updatedAt, a.fullName, o.orderCode, p_link.productName " +
                "  FROM dbo.Feedbacks f " +
                "  JOIN dbo.Accounts a ON f.accountId = a.accountId " +
                "  LEFT JOIN dbo.Orders o ON f.orderId = o.orderId " +
                "  LEFT JOIN dbo.ProductReviews pr_link ON f.reviewId = pr_link.reviewId " +
                "  LEFT JOIN dbo.Products p_link ON pr_link.productId = p_link.productId " +
                "  UNION ALL " +
                "  SELECT CAST(NULL AS BIGINT) as feedbackId, pr.accountId, o.orderId, pr.reviewId, pr.comment as content, pr.rating, " +
                "  NULL as response, 0 as status, pr.createdAt, NULL as respondedAt, NULL as updatedAt, a.fullName, o.orderCode, p.productName " +
                "  FROM dbo.ProductReviews pr " +
                "  JOIN dbo.Accounts a ON pr.accountId = a.accountId " +
                "  LEFT JOIN dbo.OrderItems oi ON pr.sourceOrderItemId = oi.orderItemId " +
                "  LEFT JOIN dbo.Orders o ON oi.orderId = o.orderId " +
                "  LEFT JOIN dbo.Products p ON pr.productId = p.productId " +
                "  WHERE NOT EXISTS (SELECT 1 FROM dbo.Feedbacks f2 WHERE f2.reviewId = pr.reviewId) " +
                ") AS CombinedFeedbacks ";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "WHERE fullName LIKE ? OR content LIKE ? OR productName LIKE ? ";
        }
        sql += "ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getLong("feedbackId"));
                f.setAccountId(rs.getLong("accountId"));
                
                long rid = rs.getLong("reviewId");
                f.setReviewId(rs.wasNull() ? null : rid);
                
                f.setCustomerName(rs.getString("fullName"));
                f.setContent(rs.getString("content"));
                f.setRating(rs.getInt("rating"));
                f.setResponse(rs.getString("response"));
                f.setStatus(rs.getByte("status"));
                f.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                if (rs.getTimestamp("respondedAt") != null) {
                    f.setRespondedAt(rs.getTimestamp("respondedAt").toLocalDateTime());
                }
                if (rs.getTimestamp("updatedAt") != null) {
                    f.setUpdatedAt(rs.getTimestamp("updatedAt").toLocalDateTime());
                }
                
                long oId = rs.getLong("orderId");
                if (!rs.wasNull()) {
                    f.setOrderId(oId);
                    f.setOrderCode(rs.getString("orderCode"));
                }

                f.setProductName(rs.getString("productName"));
                list.add(f);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean saveResponse(long feedbackId, Long reviewId, String responseText, long staffId, long accountId) {
        if (feedbackId > 0) {
            // Update existing feedback (Handle initial reply vs Edit)
            String sql = "UPDATE Feedbacks SET response = ?, respondedByAccountId = ?, " +
                    "status = 1, " +
                    "updatedAt = CASE WHEN status = 1 THEN SYSUTCDATETIME() ELSE updatedAt END, " +
                    "respondedAt = CASE WHEN status = 0 THEN SYSUTCDATETIME() ELSE respondedAt END " +
                    "WHERE feedbackId = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, responseText);
                ps.setLong(2, staffId);
                ps.setLong(3, feedbackId);
                return ps.executeUpdate() > 0;
            } catch (Exception e) { e.printStackTrace(); }
        } else if (reviewId != null) {
            // Create new feedback record for a review
            String sql = "INSERT INTO Feedbacks (accountId, reviewId, content, response, status, respondedByAccountId, respondedAt, createdAt) " +
                    "SELECT accountId, reviewId, comment, ?, 1, ?, SYSUTCDATETIME(), SYSUTCDATETIME() " +
                    "FROM ProductReviews WHERE reviewId = ?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, responseText);
                ps.setLong(2, staffId);
                ps.setLong(3, reviewId);
                return ps.executeUpdate() > 0;
            } catch (Exception e) { e.printStackTrace(); }
        }
        return false;
    }

    public boolean updateResponse(long feedbackId, String responseText, long staffId) {
        String sql = "UPDATE Feedbacks SET response = ?, respondedByAccountId = ?, " +
                "status = 1, respondedAt = SYSUTCDATETIME() WHERE feedbackId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, responseText);
            ps.setLong(2, staffId);
            ps.setLong(3, feedbackId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}