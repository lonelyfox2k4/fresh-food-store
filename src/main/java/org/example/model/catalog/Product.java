package org.example.model.catalog;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Product {
    private long productId;
    private int categoryId;
    private String categoryName;
    private String productName;
    private String description;
    private String imageUrl;
    private BigDecimal basePriceAmount;
    private int priceBaseWeightGram;
    private Integer expiryPricingPolicyId;
    private String policyName;
    private Long supplierId;
    private String supplierName;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Explicit getters/setters if Lombok fails in some environments
    public Integer getExpiryPricingPolicyId() { return expiryPricingPolicyId; }
    public void setExpiryPricingPolicyId(Integer expiryPricingPolicyId) { this.expiryPricingPolicyId = expiryPricingPolicyId; }
    public String getPolicyName() { return policyName; }
    public void setPolicyName(String policyName) { this.policyName = policyName; }
    public Long getSupplierId() { return supplierId; }
    public void setSupplierId(Long supplierId) { this.supplierId = supplierId; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
}
