package org.example.dao;

import org.example.model.catalog.Category;
import org.example.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Categories ORDER BY categoryId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Category> getAllActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Categories WHERE status = 1 ORDER BY categoryName ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToCategory(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Category getCategoryById(int id) {
        String sql = "SELECT * FROM dbo.Categories WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToCategory(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertCategory(Category c) {
        String sql = "INSERT INTO dbo.Categories (categoryName, status) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, c.getCategoryName());
            ps.setBoolean(2, c.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateCategory(Category c) {
        String sql = "UPDATE dbo.Categories SET categoryName = ?, status = ? WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, c.getCategoryName());
            ps.setBoolean(2, c.isStatus());
            ps.setInt(3, c.getCategoryId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(int id, boolean status) {
        String sql = "UPDATE dbo.Categories SET status = ? WHERE categoryId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Category mapRowToCategory(ResultSet rs) throws Exception {
        Category c = new Category();
        c.setCategoryId(rs.getInt("categoryId"));
        c.setCategoryName(rs.getString("categoryName"));
        c.setStatus(rs.getBoolean("status"));
        if (rs.getTimestamp("createdAt") != null) {
            c.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        }
        return c;
    }
}