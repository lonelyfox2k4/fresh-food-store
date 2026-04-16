package org.example.dao;

import org.example.model.content.NewsArticle;
import org.example.model.content.NewsStatus;
import org.example.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NewsArticleDAO {

    // 1. Tạo bài viết mới (Mặc định status = DRAFT)
    public boolean createNews(NewsArticle news) {
        String sql = "INSERT INTO NewsArticles (title, summary, content, imageUrl, status, createdByAccountId, createdAt) " +
                "VALUES (?, ?, ?, ?, ?, ?, GETDATE())";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, NewsStatus.DRAFT.getValue());
            ps.setLong(6, news.getCreatedByAccountId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 2. Cập nhật nội dung bài viết (RESET status về DRAFT hoặc PENDING_APPROVAL)
    public boolean updateNews(NewsArticle news, boolean isSubmitForReview) {
        String sql = "UPDATE NewsArticles SET title = ?, summary = ?, content = ?, imageUrl = ?, " +
                "status = ?, updatedAt = GETDATE() WHERE newsId = ?";
        byte nextStatus = isSubmitForReview ? NewsStatus.PENDING_APPROVAL.getValue() : NewsStatus.DRAFT.getValue();

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, nextStatus);
            ps.setLong(6, news.getNewsId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 3. Đổi trạng thái (Dùng cho Submit, Approve, Archive)
    public boolean updateStatus(long newsId, NewsStatus newStatus) {
        String sql = "UPDATE NewsArticles SET status = ?, updatedAt = GETDATE() ";
        if (newStatus == NewsStatus.PUBLISHED) {
            sql += ", publishedAt = GETDATE() ";
        }
        sql += "WHERE newsId = ?";

        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, newStatus.getValue());
            ps.setLong(2, newsId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // 4. Lấy danh sách cho Admin/Staff quản lý
    public List<NewsArticle> getAllNews() {
        List<NewsArticle> list = new ArrayList<>();
        String sql = "SELECT * FROM NewsArticles ORDER BY createdAt DESC";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                NewsArticle n = new NewsArticle();
                n.setNewsId(rs.getLong("newsId"));
                n.setTitle(rs.getString("title"));
                n.setStatus(rs.getByte("status"));
                n.setCreatedByAccountId(rs.getLong("createdByAccountId"));
                list.add(n);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}