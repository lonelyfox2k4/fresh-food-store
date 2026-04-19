package org.example.dao;

import org.example.model.marketing.Feedback;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {

    /**
     * Lấy toàn bộ đánh giá sản phẩm từ ProductReviews,
     * JOIN LEFT với Feedbacks (qua reviewId) để biết shop đã phản hồi chưa.
     */
    public List<Feedback> getAllFeedbacks() {
        List<Feedback> list = new ArrayList<>();
        String sql =
            "SELECT pr.reviewId, pr.productId, pr.accountId, pr.rating, " +
            "       pr.comment        AS reviewComment, " +
            "       pr.createdAt      AS reviewDate, " +
            "       a.fullName        AS customerName, " +
            "       p.productName     AS productName, " +
            "       f.feedbackId, f.response, f.status, " +
            "       f.respondedAt, f.respondedByAccountId " +
            "FROM  dbo.ProductReviews pr " +
            "JOIN  dbo.Accounts  a ON pr.accountId  = a.accountId " +
            "JOIN  dbo.Products  p ON pr.productId  = p.productId " +
            "LEFT JOIN dbo.Feedbacks f ON pr.reviewId = f.reviewId " +
            "ORDER BY pr.createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Feedback f = new Feedback();
                f.setReviewId(rs.getLong("reviewId"));
                f.setAccountId(rs.getLong("accountId"));
                f.setContent(rs.getString("reviewComment"));   // nội dung đánh giá gốc
                f.setRating(rs.getInt("rating"));
                f.setSubject(rs.getString("customerName"));    // tên khách hàng
                f.setProductName(rs.getString("productName")); // tên sản phẩm (field mới)

                // feedbackId: nếu chưa có phản hồi, LEFT JOIN trả về NULL → wasNull()
                long feedbackId = rs.getLong("feedbackId");
                f.setFeedbackId(rs.wasNull() ? 0L : feedbackId);
                f.setResponse(rs.getString("response"));

                // status: nếu chưa có bản ghi Feedback (LEFT JOIN null) → 0 = chờ xử lý
                byte status = rs.getByte("status");
                f.setStatus(rs.wasNull() ? (byte) 0 : status);

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

    /**
     * Lưu hoặc cập nhật phản hồi shop cho một review.
     *  - Nếu chưa có bản ghi Feedback cho reviewId → INSERT mới.
     *  - Nếu đã có → UPDATE response + respondedAt.
     *
     * Lưu ý: cột content trong Feedbacks là NOT NULL; dùng '' làm
     * placeholder vì nội dung đánh giá thực đã nằm trong ProductReviews.
     */
    public boolean saveOrUpdateResponse(long reviewId, String responseText, long staffId) {
        String checkSql =
            "SELECT feedbackId FROM dbo.Feedbacks WHERE reviewId = ?";

        String insertSql =
            "INSERT INTO dbo.Feedbacks " +
            "    (accountId, reviewId, content, response, respondedByAccountId, status, respondedAt) " +
            "VALUES (" +
            "    (SELECT accountId FROM dbo.ProductReviews WHERE reviewId = ?), " +
            "    ?, " +
            "    '', " +          // content NOT NULL — placeholder
            "    ?, " +
            "    ?, " +
            "    1, " +
            "    GETDATE()" +
            ")";

        String updateSql =
            "UPDATE dbo.Feedbacks " +
            "SET response = ?, respondedByAccountId = ?, status = 1, respondedAt = GETDATE() " +
            "WHERE reviewId = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                boolean exists = false;
                try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                    ps.setLong(1, reviewId);
                    try (ResultSet rs = ps.executeQuery()) {
                        exists = rs.next();
                    }
                }

                if (!exists) {
                    try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                        ps.setLong(1, reviewId);     // sub-select: lấy accountId của người review
                        ps.setLong(2, reviewId);     // reviewId (FK)
                        ps.setString(3, responseText);
                        ps.setLong(4, staffId);
                        ps.executeUpdate();
                    }
                } else {
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