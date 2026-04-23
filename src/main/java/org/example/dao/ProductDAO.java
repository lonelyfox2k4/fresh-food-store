package org.example.dao;

import org.example.dto.ProductDTO;
import org.example.model.catalog.Product;
import org.example.utils.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {

    // 1. Lấy danh sách hàng Flash Sale (Kèm theo tính toán giá giảm theo HSD)
    public List<ProductDTO> getFlashSaleProducts() {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 4 p.*, " +
                "       b.manufactureDate, b.expiryDate " +
                "FROM dbo.Products p " +
                "OUTER APPLY ( " +
                "    SELECT TOP 1 gri.manufactureDate, gri.expiryDate " +
                "    FROM dbo.ProductPacks pp " +
                "    JOIN dbo.GoodsReceiptItems gri ON pp.productPackId = gri.productPackId " +
                "    WHERE pp.productId = p.productId " +
                "    ORDER BY gri.expiryDate ASC " +
                ") AS b " +
                "WHERE p.expiryPricingPolicyId IS NOT NULL AND p.status = 1 " +
                "ORDER BY b.expiryDate ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToProductDTO(conn, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Lấy danh sách hàng Bán chạy (Dựa trên số lượng đã bán và kèm giá thực tế)
    public List<ProductDTO> getBestSellerProducts() {
        List<ProductDTO> list = new ArrayList<>();
        String sql = "SELECT TOP 4 p.*, " +
                "       b.manufactureDate, b.expiryDate " +
                "FROM dbo.Products p " +
                "LEFT JOIN dbo.OrderItems oi ON p.productId = oi.productId " +
                "OUTER APPLY ( " +
                "    SELECT TOP 1 gri.manufactureDate, gri.expiryDate " +
                "    FROM dbo.ProductPacks pp " +
                "    JOIN dbo.GoodsReceiptItems gri ON pp.productPackId = gri.productPackId " +
                "    WHERE pp.productId = p.productId " +
                "    ORDER BY gri.expiryDate ASC " +
                ") AS b " +
                "WHERE p.status = 1 " +
                "GROUP BY p.productId, p.categoryId, p.productName, p.description, p.imageUrl, " +
                "         p.basePriceAmount, p.priceBaseWeightGram, p.expiryPricingPolicyId, " +
                "         p.status, p.createdAt, p.updatedAt, b.manufactureDate, b.expiryDate " +
                "ORDER BY SUM(COALESCE(oi.orderedQuantity, 0)) DESC, p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToProductDTO(conn, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 3. Lấy tất cả sản phẩm cho Admin (Kèm theo thông tin Lô hàng & Đối tác &
    // Logic Giá)
    public List<ProductDTO> getAllProductsAdmin() {
        List<ProductDTO> list = new ArrayList<>();
        // Query JOIN lấy thông tin lô hàng gần nhất từ GoodsReceiptItems
        String sql = "SELECT p.*, " +
                "       b.manufactureDate, b.expiryDate, b.supplierName, b.supplierId " +
                "FROM dbo.Products p " +
                "OUTER APPLY ( " +
                "    SELECT TOP 1 gri.manufactureDate, gri.expiryDate, sup.supplierName, sup.supplierId " +
                "    FROM dbo.ProductPacks pp " +
                "    JOIN dbo.GoodsReceiptItems gri ON pp.productPackId = gri.productPackId " +
                "    JOIN dbo.GoodsReceipts gr ON gri.receiptId = gr.receiptId " +
                "    JOIN dbo.Suppliers sup ON gr.supplierId = sup.supplierId " +
                "    WHERE pp.productId = p.productId " +
                "    ORDER BY gri.expiryDate ASC " +
                ") AS b " +
                "ORDER BY p.productId DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductDTO dto = new ProductDTO();
                dto.setProductId(rs.getLong("productId"));
                dto.setProductName(rs.getString("productName"));
                dto.setCategoryId(rs.getInt("categoryId"));
                dto.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
                dto.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
                dto.setImageUrl(rs.getString("imageUrl"));
                dto.setStatus(rs.getBoolean("status"));
                dto.setSupplierName(rs.getString("supplierName"));
                long supId = rs.getLong("supplierId");
                dto.setSupplierId(rs.wasNull() ? null : supId);

                if (rs.getTimestamp("createdAt") != null) {
                    dto.setCreatedDate(rs.getTimestamp("createdAt").toLocalDateTime().toLocalDate().toString());
                }
                if (rs.getDate("manufactureDate") != null)
                    dto.setManufactureDate(rs.getDate("manufactureDate").toLocalDate());
                if (rs.getDate("expiryDate") != null)
                    dto.setExpiryDate(rs.getDate("expiryDate").toLocalDate());

                int policyId = rs.getInt("expiryPricingPolicyId");
                dto.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);

                // Logic tính toán Ngày còn lại & Giá thực tế (Current Price)
                if (dto.getExpiryDate() != null) {
                    long days = ChronoUnit.DAYS.between(LocalDate.now(), dto.getExpiryDate());
                    dto.setDaysRemaining((int) days);

                    if (dto.getExpiryPricingPolicyId() != null) {
                        BigDecimal percent = fetchDiscountPercent(conn, dto.getExpiryPricingPolicyId(), (int) days);
                        dto.setDiscountPercent(percent);
                        dto.setCurrentPrice(dto.getBasePriceAmount().multiply(percent).divide(new BigDecimal(100)));
                    } else {
                        dto.setDiscountPercent(new BigDecimal(100));
                        dto.setCurrentPrice(dto.getBasePriceAmount());
                    }
                } else {
                    dto.setDiscountPercent(new BigDecimal(100));
                    dto.setCurrentPrice(dto.getBasePriceAmount());
                }
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private BigDecimal fetchDiscountPercent(Connection conn, int policyId, int daysRemaining) {
        if (daysRemaining < 0)
            return BigDecimal.ZERO;
        // Logic: Lấy quy tắc có minDaysRemaining lớn nhất mà vẫn nhỏ hơn hoặc bằng số ngày còn lại
        String sql = "SELECT TOP 1 sellPricePercent FROM dbo.ExpiryPricingPolicyRules " +
                "WHERE policyId = ? AND minDaysRemaining <= ? " +
                "ORDER BY minDaysRemaining DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            ps.setInt(2, daysRemaining);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getBigDecimal("sellPricePercent");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return new BigDecimal(100);
    }

    private ProductDTO mapRowToProductDTO(Connection conn, ResultSet rs) throws Exception {
        ProductDTO dto = new ProductDTO();
        dto.setProductId(rs.getLong("productId"));
        dto.setProductName(rs.getString("productName"));
        dto.setCategoryId(rs.getInt("categoryId"));
        dto.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
        dto.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
        dto.setImageUrl(rs.getString("imageUrl"));
        dto.setDescription(rs.getString("description"));
        dto.setStatus(rs.getBoolean("status"));

        if (rs.getDate("manufactureDate") != null)
            dto.setManufactureDate(rs.getDate("manufactureDate").toLocalDate());
        if (rs.getDate("expiryDate") != null)
            dto.setExpiryDate(rs.getDate("expiryDate").toLocalDate());

        int policyId = rs.getInt("expiryPricingPolicyId");
        dto.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);

        // Tính toán giá thực tế dựa trên HSD
        if (dto.getExpiryDate() != null) {
            long days = ChronoUnit.DAYS.between(LocalDate.now(), dto.getExpiryDate());
            dto.setDaysRemaining((int) days);
            if (dto.getExpiryPricingPolicyId() != null) {
                BigDecimal percent = fetchDiscountPercent(conn, dto.getExpiryPricingPolicyId(), (int) days);
                dto.setDiscountPercent(percent);
                // Sử dụng RoundingMode để tránh lỗi ArithmeticException
                dto.setCurrentPrice(dto.getBasePriceAmount().multiply(percent)
                        .divide(new BigDecimal(100), 2, java.math.RoundingMode.HALF_UP));
            } else {
                dto.setDiscountPercent(new BigDecimal(100));
                dto.setCurrentPrice(dto.getBasePriceAmount());
            }
        } else {
            dto.setDiscountPercent(new BigDecimal(100));
            dto.setCurrentPrice(dto.getBasePriceAmount());
        }
        return dto;
    }

    public int countProducts(String keyword, Integer categoryId) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.Products WHERE status = 1 ");
        if (categoryId != null)
            sql.append("AND categoryId = ? ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND productName LIKE ? ");
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (categoryId != null)
                ps.setInt(idx++, categoryId);
            if (keyword != null && !keyword.trim().isEmpty())
                ps.setString(idx, "%" + keyword.trim() + "%");
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<ProductDTO> searchProducts(String keyword, Integer categoryId, int offset, int limit) {
        List<ProductDTO> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT p.*, b.manufactureDate, b.expiryDate FROM dbo.Products p ");
        sql.append("OUTER APPLY ( ");
        sql.append("    SELECT TOP 1 gri.manufactureDate, gri.expiryDate ");
        sql.append("    FROM dbo.ProductPacks pp ");
        sql.append("    JOIN dbo.GoodsReceiptItems gri ON pp.productPackId = gri.productPackId ");
        sql.append("    WHERE pp.productId = p.productId ");
        sql.append("    ORDER BY gri.expiryDate ASC ");
        sql.append(") AS b ");
        sql.append("WHERE p.status = 1 ");
        if (categoryId != null)
            sql.append("AND p.categoryId = ? ");
        if (keyword != null && !keyword.trim().isEmpty())
            sql.append("AND p.productName LIKE ? ");
        sql.append("ORDER BY p.productId DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int idx = 1;
            if (categoryId != null)
                ps.setInt(idx++, categoryId);
            if (keyword != null && !keyword.trim().isEmpty())
                ps.setString(idx++, "%" + keyword.trim() + "%");
            ps.setInt(idx++, offset);
            ps.setInt(idx, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapRowToProductDTO(conn, rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public ProductDTO getActiveProductById(long id) {
        String sql = "SELECT p.*, b.manufactureDate, b.expiryDate FROM dbo.Products p " +
                     "OUTER APPLY ( " +
                     "    SELECT TOP 1 gri.manufactureDate, gri.expiryDate " +
                     "    FROM dbo.ProductPacks pp " +
                     "    JOIN dbo.GoodsReceiptItems gri ON pp.productPackId = gri.productPackId " +
                     "    WHERE pp.productId = p.productId " +
                     "    ORDER BY gri.expiryDate ASC " +
                     ") AS b " +
                     "WHERE p.productId = ? AND p.status = 1";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRowToProductDTO(conn, rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Product> getAllProducts() {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Products ORDER BY productId DESC";
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

    public Product getProductById(long id) {
        String sql = "SELECT * FROM dbo.Products WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRowToProduct(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertProduct(Product p) {
        String sql = "INSERT INTO dbo.Products (categoryId, productName, description, imageUrl, basePriceAmount, priceBaseWeightGram, expiryPricingPolicyId, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getProductName());
            ps.setNString(3, p.getDescription());
            ps.setNString(4, p.getImageUrl());
            ps.setBigDecimal(5, p.getBasePriceAmount());
            ps.setInt(6, p.getPriceBaseWeightGram());
            if (p.getExpiryPricingPolicyId() != null)
                ps.setInt(7, p.getExpiryPricingPolicyId());
            else
                ps.setNull(7, java.sql.Types.INTEGER);
            ps.setBoolean(8, p.isStatus());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next())
                        p.setProductId(rs.getLong(1));
                }
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateProduct(Product p) {
        String sql = "UPDATE dbo.Products SET categoryId = ?, productName = ?, description = ?, imageUrl = ?, basePriceAmount = ?, priceBaseWeightGram = ?, expiryPricingPolicyId = ?, status = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, p.getCategoryId());
            ps.setNString(2, p.getProductName());
            ps.setNString(3, p.getDescription());
            ps.setNString(4, p.getImageUrl());
            ps.setBigDecimal(5, p.getBasePriceAmount());
            ps.setInt(6, p.getPriceBaseWeightGram());
            if (p.getExpiryPricingPolicyId() != null)
                ps.setInt(7, p.getExpiryPricingPolicyId());
            else
                ps.setNull(7, java.sql.Types.INTEGER);
            ps.setBoolean(8, p.isStatus());
            ps.setLong(9, p.getProductId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateStatus(long id, boolean status) {
        String sql = "UPDATE dbo.Products SET status = ? WHERE productId = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status ? 1 : 0);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    /**
     * Đồng bộ thông tin Hạn dùng và Đối tác vào bảng GoodsReceiptItems theo đúng
     * Schema.
     */
    public void syncBatchInfo(long productId, Long supplierId, LocalDate manufactureDate, LocalDate expiryDate,
            Long receivedByAccountId) {
        if (supplierId == null || expiryDate == null)
            return;

        if (receivedByAccountId == null)
            receivedByAccountId = 1L; // Fallback if session is lost

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // 1. Đảm bảo có ít nhất 1 ProductPack
                long packId = 0;
                String sqlPack = "SELECT productPackId FROM dbo.ProductPacks WHERE productId = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlPack)) {
                    ps.setLong(1, productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next())
                            packId = rs.getLong(1);
                    }
                }
                if (packId == 0) {
                    String insPack = "INSERT INTO dbo.ProductPacks (productId, packWeightGram, status) VALUES (?, ?, 1)";
                    try (PreparedStatement ps = conn.prepareStatement(insPack, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setLong(1, productId);
                        ps.setInt(2, 100); // Mặc định 100g nếu chưa có
                        ps.executeUpdate();
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next())
                                packId = rs.getLong(1);
                        }
                    }
                }

                // 2. Kiểm tra xem đã có hóa đơn nhập "AUTO" chưa
                long receiptId = 0;
                String sqlReceipt = "SELECT receiptId FROM dbo.GoodsReceipts WHERE receiptCode = ?";
                try (PreparedStatement ps = conn.prepareStatement(sqlReceipt)) {
                    ps.setString(1, "AUTO-" + productId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next())
                            receiptId = rs.getLong(1);
                    }
                }

                if (receiptId == 0) {
                    String insReceipt = "INSERT INTO dbo.GoodsReceipts (receiptCode, supplierId, receivedByAccountId, receivedAt, status) VALUES (?, ?, ?, ?, 1)";
                    try (PreparedStatement ps = conn.prepareStatement(insReceipt, Statement.RETURN_GENERATED_KEYS)) {
                        ps.setString(1, "AUTO-" + productId);
                        ps.setLong(2, supplierId);
                        ps.setLong(3, receivedByAccountId);
                        ps.setTimestamp(4, java.sql.Timestamp.valueOf(LocalDate.now().atStartOfDay()));
                        ps.executeUpdate();
                        try (ResultSet rs = ps.getGeneratedKeys()) {
                            if (rs.next())
                                receiptId = rs.getLong(1);
                        }
                    }
                } else {
                    String updReceipt = "UPDATE dbo.GoodsReceipts SET supplierId = ? WHERE receiptId = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updReceipt)) {
                        ps.setLong(1, supplierId);
                        ps.setLong(2, receiptId);
                        ps.executeUpdate();
                    }
                }

                // 3. Cập nhật hoặc tạo mới GoodsReceiptItem (Batch)
                String sqlItem = "SELECT receiptItemId FROM dbo.GoodsReceiptItems WHERE receiptId = ? AND productPackId = ?";
                long itemId = 0;
                try (PreparedStatement ps = conn.prepareStatement(sqlItem)) {
                    ps.setLong(1, receiptId);
                    ps.setLong(2, packId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next())
                            itemId = rs.getLong(1);
                    }
                }

                if (itemId == 0) {
                    String insItem = "INSERT INTO dbo.GoodsReceiptItems (receiptId, productPackId, batchCode, manufactureDate, expiryDate, quantityReceived, unitCost) VALUES (?, ?, ?, ?, ?, 100, 0)";
                    try (PreparedStatement ps = conn.prepareStatement(insItem)) {
                        ps.setLong(1, receiptId);
                        ps.setLong(2, packId);
                        ps.setString(3, "BATCH-" + productId);
                        ps.setDate(4, manufactureDate != null ? java.sql.Date.valueOf(manufactureDate) : null);
                        ps.setDate(5, java.sql.Date.valueOf(expiryDate));
                        ps.executeUpdate();
                    }
                } else {
                    String updItem = "UPDATE dbo.GoodsReceiptItems SET manufactureDate = ?, expiryDate = ? WHERE receiptItemId = ?";
                    try (PreparedStatement ps = conn.prepareStatement(updItem)) {
                        ps.setDate(1, manufactureDate != null ? java.sql.Date.valueOf(manufactureDate) : null);
                        ps.setDate(2, java.sql.Date.valueOf(expiryDate));
                        ps.setLong(3, itemId);
                        ps.executeUpdate();
                    }
                }

                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Product mapRowToProduct(ResultSet rs) throws Exception {
        Product p = new Product();
        p.setProductId(rs.getLong("productId"));
        p.setCategoryId(rs.getInt("categoryId"));
        p.setProductName(rs.getString("productName"));
        p.setDescription(rs.getString("description"));
        p.setImageUrl(rs.getString("imageUrl"));
        p.setBasePriceAmount(rs.getBigDecimal("basePriceAmount"));
        p.setPriceBaseWeightGram(rs.getInt("priceBaseWeightGram"));
        try {
            int policyId = rs.getInt("expiryPricingPolicyId");
            p.setExpiryPricingPolicyId(rs.wasNull() ? null : policyId);
        } catch (Exception e) {
        }
        p.setStatus(rs.getBoolean("status"));
        if (rs.getTimestamp("createdAt") != null) {
            p.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        }
        return p;
    }

    public List<Product> searchProductsByChatbot(String keyword) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP 5 p.* FROM dbo.Products p WHERE p.status = 1 AND p.productName LIKE ? ORDER BY p.productId DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, "%" + keyword + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next())
                    list.add(mapRowToProduct(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Product> getNewestProducts(int limit) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM dbo.Products WHERE status = 1 ORDER BY createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToProduct(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}