package org.example.dao;

import org.example.model.marketing.Feedback;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql = "SELECT f.*, a.fullName FROM Feedbacks f " +
                "JOIN Accounts a ON f.accountId = a.accountId " +
                "ORDER BY f.createdAt DESC";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback f = new Feedback();
                f.setFeedbackId(rs.getLong("feedbackId"));
                f.setCustomerName(rs.getString("fullName"));
                f.setContent(rs.getString("content"));
                f.setRating(rs.getInt("rating"));
                f.setResponse(rs.getString("response"));
                f.setStatus(rs.getByte("status"));
                f.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                if (rs.getTimestamp("respondedAt") != null) {
                    f.setRespondedAt(rs.getTimestamp("respondedAt").toLocalDateTime());
                }
                list.add(f);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updateResponse(long feedbackId, String responseText, long staffId) {
        // Staff trả lời trực tiếp, status chuyển sang 1 (Đã phản hồi) ngay lập tức
        String sql = "UPDATE Feedbacks SET response = ?, respondedByAccountId = ?, " +
                "status = 1, respondedAt = GETDATE() WHERE feedbackId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, responseText);
            ps.setLong(2, staffId);
            ps.setLong(3, feedbackId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}