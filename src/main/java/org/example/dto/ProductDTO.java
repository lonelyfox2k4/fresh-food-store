package org.example.dto;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * DTO dùng để hiển thị thông tin sản phẩm.
 * Sử dụng code thuần (không Lombok) để đảm bảo Tomcat nhận diện đúng Property.
 */
public class ProductDTO {
    // Thông tin cơ bản từ Product
    private long productId;
    private String productName;
    private int categoryId;
    private BigDecimal basePriceAmount;
    private int priceBaseWeightGram;
    private Integer expiryPricingPolicyId;
    private boolean status;
    private String imageUrl;
    private String description;

    // Thông tin bổ sung từ JOIN & Logic
    private Long supplierId;
    private String supplierName;
    private LocalDate manufactureDate;
    private LocalDate expiryDate;
    private String createdDate;

    private int daysRemaining;
    private BigDecimal discountPercent; // % giá bán (ví dụ 80% là giảm 20%)
    private BigDecimal currentPrice;

    // Getters/Setters thủ công để đảm bảo hoạt động
    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public BigDecimal getBasePriceAmount() {
        return basePriceAmount;
    }

    public void setBasePriceAmount(BigDecimal basePriceAmount) {
        this.basePriceAmount = basePriceAmount;
    }

    public int getPriceBaseWeightGram() {
        return priceBaseWeightGram;
    }

    public void setPriceBaseWeightGram(int priceBaseWeightGram) {
        this.priceBaseWeightGram = priceBaseWeightGram;
    }

    public Integer getExpiryPricingPolicyId() {
        return expiryPricingPolicyId;
    }

    public void setExpiryPricingPolicyId(Integer expiryPricingPolicyId) {
        this.expiryPricingPolicyId = expiryPricingPolicyId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public String getSupplierName() {
        return supplierName;
    }

    public void setSupplierName(String supplierName) {
        this.supplierName = supplierName;
    }

    public LocalDate getManufactureDate() {
        return manufactureDate;
    }

    public void setManufactureDate(LocalDate manufactureDate) {
        this.manufactureDate = manufactureDate;
    }

    public LocalDate getExpiryDate() {
        return expiryDate;
    }

    public void setExpiryDate(LocalDate expiryDate) {
        this.expiryDate = expiryDate;
    }

    public String getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(String createdDate) {
        this.createdDate = createdDate;
    }

    public int getDaysRemaining() {
        return daysRemaining;
    }

    public void setDaysRemaining(int daysRemaining) {
        this.daysRemaining = daysRemaining;
    }

    public BigDecimal getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(BigDecimal discountPercent) {
        this.discountPercent = discountPercent;
    }

    public BigDecimal getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(BigDecimal currentPrice) {
        this.currentPrice = currentPrice;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
