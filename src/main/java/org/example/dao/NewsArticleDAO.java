package org.example.dao;

import org.example.model.content.NewsArticle;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NewsArticleDAO {

    private NewsArticle extractNewsFromResultSet(ResultSet rs) throws SQLException {
        NewsArticle n = new NewsArticle();
        n.setNewsId(rs.getLong("newsId"));
        n.setTitle(rs.getString("title"));
        n.setSummary(rs.getString("summary"));
        n.setContent(rs.getString("content"));
        n.setImageUrl(rs.getString("imageUrl"));
        n.setStatus(rs.getByte("status"));
        n.setCreatedByAccountId(rs.getLong("createdByAccountId"));
        
        Timestamp createdAt = rs.getTimestamp("createdAt");
        if (createdAt != null) n.setCreatedAt(createdAt.toLocalDateTime());
        
        Timestamp updatedAt = rs.getTimestamp("updatedAt");
        if (updatedAt != null) n.setUpdatedAt(updatedAt.toLocalDateTime());
        
        Timestamp publishedAt = rs.getTimestamp("publishedAt");
        if (publishedAt != null) n.setPublishedAt(publishedAt.toLocalDateTime());
        
        return n;
    }

    public List<NewsArticle> getAllNews() {
        List<NewsArticle> list = new ArrayList<>();
        String sql = "SELECT * FROM NewsArticles ORDER BY createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractNewsFromResultSet(rs));
            }
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in getAllNews: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public NewsArticle getNewsById(long id) {
        String sql = "SELECT * FROM NewsArticles WHERE newsId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractNewsFromResultSet(rs);
                }
            }
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in getNewsById for ID " + id + ": " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    public boolean createNews(NewsArticle news) {
        String sql = "INSERT INTO NewsArticles (title, summary, content, imageUrl, status, createdByAccountId, createdAt, publishedAt) VALUES (?, ?, ?, ?, ?, ?, GETDATE(), ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, news.getStatus());
            ps.setLong(6, news.getCreatedByAccountId());
            ps.setTimestamp(7, news.getStatus() == 2 ? new Timestamp(System.currentTimeMillis()) : null);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in createNews: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateNews(NewsArticle news) {
        String sql = "UPDATE NewsArticles SET title=?, summary=?, content=?, imageUrl=?, status=?, updatedAt=GETDATE(), publishedAt=(CASE WHEN ?=2 AND publishedAt IS NULL THEN GETDATE() ELSE publishedAt END) WHERE newsId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, news.getTitle());
            ps.setString(2, news.getSummary());
            ps.setString(3, news.getContent());
            ps.setString(4, news.getImageUrl());
            ps.setByte(5, news.getStatus());
            ps.setByte(6, news.getStatus());
            ps.setLong(7, news.getNewsId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in updateNews: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteNews(long newsId) {
        String sql = "DELETE FROM NewsArticles WHERE newsId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, newsId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in deleteNews: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(long newsId, byte status) {
        String sql = "UPDATE NewsArticles SET status = ?, publishedAt = (CASE WHEN ? = 2 THEN GETDATE() ELSE publishedAt END) WHERE newsId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setByte(2, status);
            ps.setLong(3, newsId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.err.println("[NewsArticleDAO] Error in updateStatus: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public List<NewsArticle> getLatestPublishedNews(int limit) {
        List<NewsArticle> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM NewsArticles WHERE status = 2 ORDER BY publishedAt DESC";
        // Note: For MySQL use LIMIT ?, for SQL Server use TOP (?) or OFFSET FETCH
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractNewsFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<NewsArticle> getPublishedNewsPaged(int page, int pageSize) {
        List<NewsArticle> list = new ArrayList<>();
        int offset = (page - 1) * pageSize;
        String sql = "SELECT * FROM NewsArticles WHERE status = 2 " +
                     "ORDER BY publishedAt DESC " +
                     "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, pageSize);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractNewsFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int getTotalPublishedCount() {
        String sql = "SELECT COUNT(*) FROM NewsArticles WHERE status = 2";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }
}