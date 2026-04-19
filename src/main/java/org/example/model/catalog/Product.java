package org.example.model.catalog;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * Model ánh xạ 1:1 với bảng dbo.Products trong Database.
 * Không thêm các trường hiển thị vào đây để tránh làm sai lệch cấu trúc dữ liệu.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Product {
    private long productId;
    private int categoryId;
    private String productName;
    private String description;
    private String imageUrl;
    private BigDecimal basePriceAmount;
    private int priceBaseWeightGram;
    private Integer expiryPricingPolicyId;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Explicit getters/setters (dự phòng trường hợp Lombok không hoạt động)
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public BigDecimal getBasePriceAmount() { return basePriceAmount; }
    public void setBasePriceAmount(BigDecimal basePriceAmount) { this.basePriceAmount = basePriceAmount; }
    public int getPriceBaseWeightGram() { return priceBaseWeightGram; }
    public void setPriceBaseWeightGram(int priceBaseWeightGram) { this.priceBaseWeightGram = priceBaseWeightGram; }
    public Integer getExpiryPricingPolicyId() { return expiryPricingPolicyId; }
    public void setExpiryPricingPolicyId(Integer expiryPricingPolicyId) { this.expiryPricingPolicyId = expiryPricingPolicyId; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
