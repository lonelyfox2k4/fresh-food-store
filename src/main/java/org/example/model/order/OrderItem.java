package org.example.model.order;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor @AllArgsConstructor
public class OrderItem {
    private long orderItemId;
    private long orderId;
    private long productId;
    private Long productPackId;
    private String productNameSnapshot;
    private int packWeightGramSnapshot;
    private String imageUrlSnapshot;
    private BigDecimal computedPackBasePriceSnapshot;
    private int orderedQuantity;
    private BigDecimal lineSubtotalSnapshot;
    private BigDecimal lineDiscountSnapshot;
    private BigDecimal lineTotalSnapshot;
    private boolean isReviewed;

    // Explicit getters/setters (fallback when Lombok annotation processing unavailable)
    public boolean isReviewed() { return isReviewed; }
    public void setReviewed(boolean reviewed) { isReviewed = reviewed; }

    public long getOrderItemId() { return orderItemId; }
    public void setOrderItemId(long orderItemId) { this.orderItemId = orderItemId; }
    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public Long getProductPackId() { return productPackId; }
    public void setProductPackId(Long productPackId) { this.productPackId = productPackId; }
    public String getProductNameSnapshot() { return productNameSnapshot; }
    public void setProductNameSnapshot(String v) { this.productNameSnapshot = v; }
    public int getPackWeightGramSnapshot() { return packWeightGramSnapshot; }
    public void setPackWeightGramSnapshot(int v) { this.packWeightGramSnapshot = v; }
    public String getImageUrlSnapshot() { return imageUrlSnapshot; }
    public void setImageUrlSnapshot(String v) { this.imageUrlSnapshot = v; }
    public BigDecimal getComputedPackBasePriceSnapshot() { return computedPackBasePriceSnapshot; }
    public void setComputedPackBasePriceSnapshot(BigDecimal v) { this.computedPackBasePriceSnapshot = v; }
    public int getOrderedQuantity() { return orderedQuantity; }
    public void setOrderedQuantity(int orderedQuantity) { this.orderedQuantity = orderedQuantity; }
    public BigDecimal getLineSubtotalSnapshot() { return lineSubtotalSnapshot; }
    public void setLineSubtotalSnapshot(BigDecimal v) { this.lineSubtotalSnapshot = v; }
    public BigDecimal getLineDiscountSnapshot() { return lineDiscountSnapshot; }
    public void setLineDiscountSnapshot(BigDecimal v) { this.lineDiscountSnapshot = v; }
    public BigDecimal getLineTotalSnapshot() { return lineTotalSnapshot; }
    public void setLineTotalSnapshot(BigDecimal v) { this.lineTotalSnapshot = v; }
}
