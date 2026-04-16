package org.example.dao;

import org.example.model.catalog.Product;
import org.example.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 1. Lấy danh sách hàng Flash Sale (Là những món CÓ gắn policy giảm giá)
    public List<Product> getFlashSaleProducts() {
        List<Product> list = new ArrayList<>();
        // Query những sản phẩm có expiryPricingPolicyId KHÔNG NULL
        String sql = "SELECT TOP 4 * FROM dbo.Products WHERE expiryPricingPolicyId IS NOT NULL AND status = 1 ORDER BY productId DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách hàng Bán chạy (Hàng tươi giá gốc, KHÔNG gắn policy)
    public List<Product> getBestSellerProducts() {
        List<Product> list = new ArrayList<>();
        // Query những sản phẩm có expiryPricingPolicyId LÀ NULL
        String sql = "SELECT TOP 4 * FROM dbo.Products WHERE expiryPricingPolicyId IS NULL AND status = 1 ORDER BY productId ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Hàm tiện ích: Chuyển dữ liệu 1 dòng trong Database thành Object Product trong Java
    private Product mapRowToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getLong("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("imageUrl"));
        p.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
        p.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));

        // Xử lý Integer có thể NULL
        int policyId = rs.getInt("expiryPricingPolicyId");
        p.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);

        p.setStatus(rs.getBoolean("status"));

        // Java 8 Date Time
        if (rs.getTimestamp("createdAt") != null) {
            p.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        }
        return p;
    }
}