package org.example.dao;

import org.example.model.catalog.Category;
import org.example.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    public List<Category> getAllActiveCategories() {
        List<Category> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Categories WHERE status = 1 ORDER BY categoryId ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Category c = new Category();
                c.setCategoryId(rs.getInt("categoryId"));
                c.setCategoryName(rs.getString("categoryName"));
                c.setStatus(rs.getBoolean("status"));
                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}