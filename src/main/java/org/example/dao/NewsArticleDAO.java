package org.example.dao;

import org.example.model.content.NewsArticle;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsArticleDAO {

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
                n.setSummary(rs.getString("summary"));
                n.setStatus(rs.getByte("status"));
                n.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
                list.add(n);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public NewsArticle getNewsById(long id) {
        String sql = "SELECT * FROM NewsArticles WHERE newsId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    NewsArticle n = new NewsArticle();
                    n.setNewsId(rs.getLong("newsId"));
                    n.setTitle(rs.getString("title"));
                    n.setSummary(rs.getString("summary"));
                    n.setContent(rs.getString("content"));
                    n.setImageUrl(rs.getString("imageUrl"));
                    n.setStatus(rs.getByte("status"));
                    
                    Timestamp created = rs.getTimestamp("createdAt");
                    if (created != null) n.setCreatedAt(created.toLocalDateTime());
                    
                    Timestamp updated = rs.getTimestamp("updatedAt");
                    if (updated != null) n.setUpdatedAt(updated.toLocalDateTime());
                    
                    Timestamp published = rs.getTimestamp("publishedAt");
                    if (published != null) n.setPublishedAt(published.toLocalDateTime());
                    
                    return n;
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean createNews(NewsArticle news) {
        String sql = "INSERT INTO NewsArticles (title, summary, content, imageUrl, status, createdByAccountId, createdAt, publishedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?)";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, news.getStatus());
            ps.setLong(6, news.getCreatedByAccountId());
            ps.setTimestamp(7, news.getStatus() == 2 ? new Timestamp(System.currentTimeMillis()) : null);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateNews(NewsArticle news) {
        String sql = "UPDATE NewsArticles SET title=?, summary=?, content=?, imageUrl=?, status=?, updatedAt=GETDATE(), publishedAt=(CASE WHEN ?=2 AND publishedAt IS NULL THEN GETDATE() ELSE publishedAt END) WHERE newsId=?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, news.getStatus());
            ps.setByte(6, news.getStatus());
            ps.setLong(7, news.getNewsId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean deleteNews(long newsId) {
        String sql = "DELETE FROM NewsArticles WHERE newsId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, newsId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }

    public boolean updateStatus(long newsId, byte status) {
        String sql = "UPDATE NewsArticles SET status = ?, publishedAt = (CASE WHEN ? = 2 THEN GETDATE() ELSE publishedAt END) WHERE newsId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setByte(2, status);
            ps.setLong(3, newsId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); return false; }
    }
}