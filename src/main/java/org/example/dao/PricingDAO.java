package org.example.dao;

import org.example.utils.DBConnection;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

public class PricingDAO {

    public BigDecimal calculateCurrentPrice(long productId, long productPackId, LocalDate expiryDate, BigDecimal basePrice) {
        long daysRemaining = ChronoUnit.DAYS.between(LocalDate.now(), expiryDate);
        if (daysRemaining < 0) return BigDecimal.ZERO; 

        String sql = "SELECT TOP 1 r.sellPricePercent " +
                     "FROM dbo.Products p " +
                     "JOIN dbo.ExpiryPricingPolicyRules r ON p.expiryPricingPolicyId = r.policyId " +
                     "WHERE p.productId = ? AND r.minDaysRemaining <= ? " +
                     "ORDER BY r.minDaysRemaining DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setInt(2, (int) daysRemaining);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    BigDecimal percent = rs.getBigDecimal("sellPricePercent");
                    return basePrice.multiply(percent).divide(new BigDecimal(100));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return basePrice;
    }

    public List<BatchPricingDTO> getInventoryWithPricing() {
        List<BatchPricingDTO> list = new ArrayList<>();
        String sql = "SELECT p.productId, p.productName, p.basePriceAmount, " +
                     "gi.expiryDate, g.receivedAt, b.quantityOnHand, p.expiryPricingPolicyId, s.supplierName, ep.policyName " +
                     "FROM dbo.InventoryBatches b " +
                     "JOIN dbo.GoodsReceiptItems gi ON b.receiptItemId = gi.receiptItemId " +
                     "JOIN dbo.GoodsReceipts g ON gi.receiptId = g.receiptId " +
                     "JOIN dbo.Suppliers s ON g.supplierId = s.supplierId " +
                     "JOIN dbo.ProductPacks pp ON gi.productPackId = pp.productPackId " +
                     "JOIN dbo.Products p ON pp.productId = p.productId " +
                     "LEFT JOIN dbo.ExpiryPricingPolicies ep ON p.expiryPricingPolicyId = ep.policyId " +
                     "WHERE b.quantityOnHand > 0 AND b.status = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                BatchPricingDTO item = new BatchPricingDTO();
                item.setProductId(rs.getLong("productId"));
                item.setProductName(rs.getString("productName"));
                item.setBasePrice(rs.getBigDecimal("basePriceAmount"));
                item.setExpiryDate(rs.getDate("expiryDate").toLocalDate());
                item.setReceivedAt(rs.getTimestamp("receivedAt").toLocalDateTime());
                item.setQuantity(rs.getInt("quantityOnHand"));
                item.setSupplierName(rs.getString("supplierName"));
                
                BigDecimal percent = calculateDiscountPercent(item.getProductId(), item.getExpiryDate());
                item.setDiscountPercent(percent);
                item.setCurrentPrice(item.getBasePrice().multiply(percent).divide(new BigDecimal(100)));
                
                // Get policy info
                item.setPolicyName(rs.getString("policyName"));
                long daysRemaining = ChronoUnit.DAYS.between(LocalDate.now(), item.getExpiryDate());
                item.setDaysRemaining((int) daysRemaining);
                
                list.add(item);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private BigDecimal calculateDiscountPercent(long productId, LocalDate expiryDate) {
        long daysRemaining = ChronoUnit.DAYS.between(LocalDate.now(), expiryDate);
        if (daysRemaining < 0) return BigDecimal.ZERO;

        String sql = "SELECT TOP 1 r.sellPricePercent " +
                     "FROM dbo.Products p " +
                     "JOIN dbo.ExpiryPricingPolicyRules r ON p.expiryPricingPolicyId = r.policyId " +
                     "WHERE p.productId = ? AND r.minDaysRemaining >= ? " +
                     "ORDER BY r.minDaysRemaining ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            ps.setInt(2, (int) daysRemaining);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("sellPricePercent");
            }
        } catch (Exception e) { e.printStackTrace(); }
        return new BigDecimal(100); // Default 100% price (0% discount)
    }

    public static class BatchPricingDTO {
        private long productId;
        private String productName;
        private BigDecimal basePrice;
        private BigDecimal currentPrice;
        private LocalDate expiryDate;
        private java.time.LocalDateTime receivedAt;
        private int quantity;
        private String supplierName;
        private BigDecimal discountPercent;
        private String policyName;
        private int daysRemaining;

        public long getProductId() { return productId; }
        public void setProductId(long productId) { this.productId = productId; }
        public String getProductName() { return productName; }
        public void setProductName(String productName) { this.productName = productName; }
        public BigDecimal getBasePrice() { return basePrice; }
        public void setBasePrice(BigDecimal basePrice) { this.basePrice = basePrice; }
        public BigDecimal getCurrentPrice() { return currentPrice; }
        public void setCurrentPrice(BigDecimal currentPrice) { this.currentPrice = currentPrice; }
        public LocalDate getExpiryDate() { return expiryDate; }
        public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
        public java.time.LocalDateTime getReceivedAt() { return receivedAt; }
        public void setReceivedAt(java.time.LocalDateTime receivedAt) { this.receivedAt = receivedAt; }
        public int getQuantity() { return quantity; }
        public void setQuantity(int quantity) { this.quantity = quantity; }
        public String getSupplierName() { return supplierName; }
        public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
        public BigDecimal getDiscountPercent() { return discountPercent; }
        public void setDiscountPercent(BigDecimal discountPercent) { this.discountPercent = discountPercent; }
        public String getPolicyName() { return policyName; }
        public void setPolicyName(String policyName) { this.policyName = policyName; }
        public int getDaysRemaining() { return daysRemaining; }
        public void setDaysRemaining(int daysRemaining) { this.daysRemaining = daysRemaining; }
    }
}
