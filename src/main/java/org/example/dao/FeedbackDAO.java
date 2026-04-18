package org.example.dao;

import org.example.model.marketing.Feedback;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        // Now selecting from ProductReviews so ALL reviews appear in the management list
        String sql = "SELECT pr.reviewId, pr.productId, pr.accountId, pr.rating, pr.comment as reviewComment, pr.createdAt as reviewDate, " +
                     "a.fullName as customerName, f.feedbackId, f.response, f.status, f.respondedAt " +
                     "FROM dbo.ProductReviews pr " +
                     "JOIN dbo.Accounts a ON pr.accountId = a.accountId " +
                     "LEFT JOIN dbo.Feedbacks f ON pr.reviewId = f.reviewId " +
                     "ORDER BY pr.createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setReviewId(rs.getLong("reviewId"));
                f.setAccountId(rs.getLong("accountId"));
                f.setContent(rs.getString("reviewComment")); // Original review text
                f.setRating(rs.getInt("rating"));
                f.setFeedbackId(rs.getLong("feedbackId"));
                f.setResponse(rs.getString("response"));
                f.setStatus(rs.getByte("status"));
                f.setSubject(rs.getString("customerName")); // Storing customer name in subject for now to use in JSP
                
                if (rs.getTimestamp("reviewDate") != null) {
                    f.setCreatedAt(rs.getTimestamp("reviewDate").toLocalDateTime());
                }
                if (rs.getTimestamp("respondedAt") != null) {
                    f.setRespondedAt(rs.getTimestamp("respondedAt").toLocalDateTime());
                }
                list.add(f);
            }
        } catch (Exception e) { 
            e.printStackTrace(); 
        }
        return list;
    }

    public boolean saveOrUpdateResponse(long reviewId, String responseText, long staffId) {
        // 1. Check if feedback record exists for this review
        String checkSql = "SELECT feedbackId FROM Feedbacks WHERE reviewId = ?";
        String insertSql = "INSERT INTO Feedbacks (accountId, reviewId, content, response, respondedByAccountId, status, respondedAt) " +
                           "VALUES ((SELECT accountId FROM ProductReviews WHERE reviewId = ?), ?, '', ?, ?, 1, GETDATE())";
        String updateSql = "UPDATE Feedbacks SET response = ?, respondedByAccountId = ?, status = 1, respondedAt = GETDATE() WHERE reviewId = ?";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                long feedbackId = -1;
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setLong(1, reviewId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) feedbackId = rs.getLong(1);
                    }
                }

                if (feedbackId == -1) {
                    // Insert
                    try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                        ps.setLong(1, reviewId);
                        ps.setLong(2, reviewId);
                        ps.setString(3, responseText);
                        ps.setLong(4, staffId);
                        ps.executeUpdate();
                    }
                } else {
                    // Update
                    try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
                        ps.setString(1, responseText);
                        ps.setLong(2, staffId);
                        ps.setLong(3, reviewId);
                        ps.executeUpdate();
                    }
                }
                conn.commit();
                return true;
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}