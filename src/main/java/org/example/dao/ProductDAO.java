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

    // 3. Lấy tất cả sản phẩm cho Admin
    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT p.*, c.categoryName, s.supplierName, ep.policyName FROM dbo.Products p " +
                     "LEFT JOIN dbo.Categories c ON p.categoryId = c.categoryId " +
                     "LEFT JOIN dbo.Suppliers s ON p.supplierId = s.supplierId " +
                     "LEFT JOIN dbo.ExpiryPricingPolicies ep ON p.expiryPricingPolicyId = ep.policyId " +
                     "ORDER BY p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToProduct(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // 4. Lấy sản phẩm theo ID
    public Product getProductById(long id) {
        String sql = "SELECT * FROM dbo.Products WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToProduct(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // 5. Thêm mới sản phẩm
    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO dbo.Products (categoryId, productName, description, imageUrl, basePriceAmount, priceBaseWeightGram, expiryPricingPolicyId, supplierId, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getProductName());
            ps.setNString(3, p.getDescription());
            ps.setNString(4, p.getImageUrl());
            ps.setBigDecimal(5, p.getBasePriceAmount());
            ps.setInt(6, p.getPriceBaseWeightGram());
            if (p.getExpiryPricingPolicyId() != null) ps.setInt(7, p.getExpiryPricingPolicyId());
            else ps.setNull(7, java.sql.Types.INTEGER);
            if (p.getSupplierId() != null) ps.setLong(8, p.getSupplierId());
            else ps.setNull(8, java.sql.Types.BIGINT);
            ps.setBoolean(9, p.isStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 6. Cập nhật sản phẩm
    public boolean updateProduct(Product p) {
        String sql = "UPDATE dbo.Products SET categoryId = ?, productName = ?, description = ?, imageUrl = ?, basePriceAmount = ?, priceBaseWeightGram = ?, expiryPricingPolicyId = ?, supplierId = ?, status = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getProductName());
            ps.setNString(3, p.getDescription());
            ps.setNString(4, p.getImageUrl());
            ps.setBigDecimal(5, p.getBasePriceAmount());
            ps.setInt(6, p.getPriceBaseWeightGram());
            if (p.getExpiryPricingPolicyId() != null) ps.setInt(7, p.getExpiryPricingPolicyId());
            else ps.setNull(7, java.sql.Types.INTEGER);
            if (p.getSupplierId() != null) ps.setLong(8, p.getSupplierId());
            else ps.setNull(8, java.sql.Types.BIGINT);
            ps.setBoolean(9, p.isStatus());
            ps.setLong(10, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // 7. Thay đổi trạng thái (Xóa mềm)
    public boolean updateStatus(long id, boolean status) {
        String sql = "UPDATE dbo.Products SET status = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Hàm tiện ích: Chuyển dữ liệu 1 dòng trong Database thành Object Product trong
    // Java
    private Product mapRowToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getLong("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        try { p.setCategoryName(rs.getString("categoryName")); } catch (Exception e) {}
        try { p.setSupplierName(rs.getString("supplierName")); } catch (Exception e) {}
        try { p.setPolicyName(rs.getString("policyName")); } catch (Exception e) {}
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("imageUrl"));
        p.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
        p.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));

        // Xử lý Integer/Long có thể NULL
        try {
            int policyId = rs.getInt("expiryPricingPolicyId");
            p.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);
        } catch (Exception e) {}

        try {
            long supId = rs.getLong("supplierId");
            p.setSupplierId(rs.wasNull() ? null : supId);
        } catch (Exception e) {}

        p.setStatus(rs.getBoolean("status"));

        // Java 8 Date Time
        if (rs.getTimestamp("createdAt") != null) {
            p.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        }
        return p;
    }
}