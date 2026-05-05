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
        // Query SIÊU TỐI GIẢN để đảm bảo hiện ra dữ liệu
        String sql = "SELECT * FROM (" +
                "  /* Part 1: Đã có trong bảng Feedbacks */ " +
                "  SELECT f.feedbackId, f.accountId, f.orderId, f.reviewId, f.content, " +
                "  ISNULL(pr.rating, 0) as rating, f.response, f.status, f.createdAt, " +
                "  f.respondedAt, f.updatedAt, a.fullName as customerName, o.orderCode, p.productName " +
                "  FROM Feedbacks f " +
                "  LEFT JOIN Accounts a ON f.accountId = a.accountId " +
                "  LEFT JOIN Orders o ON f.orderId = o.orderId " +
                "  LEFT JOIN ProductReviews pr ON f.reviewId = pr.reviewId " +
                "  LEFT JOIN Products p ON pr.productId = p.productId " +
                "  UNION ALL " +
                "  /* Part 2: Chỉ có trong ProductReviews (Chưa phản hồi) */ " +
                "  SELECT 0 as feedbackId, pr2.accountId, NULL as orderId, pr2.reviewId, pr2.comment as content, pr2.rating, " +
                "  NULL as response, 0 as status, pr2.createdAt, NULL as respondedAt, NULL as updatedAt, " +
                "  a2.fullName as customerName, NULL as orderCode, p2.productName " +
                "  FROM ProductReviews pr2 " +
                "  LEFT JOIN Accounts a2 ON pr2.accountId = a2.accountId " +
                "  LEFT JOIN Products p2 ON pr2.productId = p2.productId " +
                "  WHERE NOT EXISTS (SELECT 1 FROM Feedbacks f2 WHERE f2.reviewId = pr2.reviewId) " +
                ") AS T ";
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += "WHERE customerName LIKE ? OR content LIKE ? OR productName LIKE ? ";
        }
        sql += "ORDER BY createdAt DESC";

        System.out.println("DEBUG: Executing Feedback Query: " + sql);

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            if (keyword != null && !keyword.trim().isEmpty()) {
                String pattern = "%" + keyword.trim() + "%";
                ps.setString(1, pattern);
                ps.setString(2, pattern);
                ps.setString(3, pattern);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback f = new Feedback();
                    f.setFeedbackId(rs.getLong("feedbackId"));
                    f.setAccountId(rs.getLong("accountId"));
                    f.setReviewId(rs.getObject("reviewId") != null ? rs.getLong("reviewId") : null);
                    f.setCustomerName(rs.getString("customerName"));
                    f.setContent(rs.getString("content"));
                    f.setRating(rs.getInt("rating"));
                    f.setResponse(rs.getString("response"));
                    f.setStatus(rs.getByte("status"));
                    
                    Timestamp ct = rs.getTimestamp("createdAt");
                    if (ct != null) f.setCreatedAt(ct.toLocalDateTime());
                    
                    Timestamp rt = rs.getTimestamp("respondedAt");
                    if (rt != null) f.setRespondedAt(rt.toLocalDateTime());
                    
                    f.setOrderCode(rs.getString("orderCode"));
                    f.setProductName(rs.getString("productName"));
                    list.add(f);
                }
            }
            System.out.println("DEBUG: Found " + list.size() + " feedback/review records.");
        } catch (Exception e) { 
            System.err.println("DEBUG ERROR in FeedbackDAO: " + e.getMessage());
            e.printStackTrace(); 
        }
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