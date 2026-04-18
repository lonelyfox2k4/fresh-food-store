package org.example.dto;

import lombok.*;
import java.math.BigDecimal;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class CartItemDTO {
    private long cartItemId;
    private long cartId;
    private long productPackId;
    private long productId;
    private String productName;
    private String imageUrl;
    private int packWeightGram;
    private BigDecimal basePriceAmount;
    private int priceBaseWeightGram;
    private Integer expiryPricingPolicyId;
    private int quantity;
    /** basePriceAmount * packWeightGram / priceBaseWeightGram */
    private BigDecimal computedPackBasePrice;
    /** computedPackBasePrice * quantity */
    private BigDecimal lineTotal;

    public long getCartItemId() { return cartItemId; }
    public void setCartItemId(long cartItemId) { this.cartItemId = cartItemId; }
    public long getCartId() { return cartId; }
    public void setCartId(long cartId) { this.cartId = cartId; }
    public long getProductPackId() { return productPackId; }
    public void setProductPackId(long productPackId) { this.productPackId = productPackId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
    public int getPackWeightGram() { return packWeightGram; }
    public void setPackWeightGram(int packWeightGram) { this.packWeightGram = packWeightGram; }
    public BigDecimal getBasePriceAmount() { return basePriceAmount; }
    public void setBasePriceAmount(BigDecimal basePriceAmount) { this.basePriceAmount = basePriceAmount; }
    public int getPriceBaseWeightGram() { return priceBaseWeightGram; }
    public void setPriceBaseWeightGram(int priceBaseWeightGram) { this.priceBaseWeightGram = priceBaseWeightGram; }
    public Integer getExpiryPricingPolicyId() { return expiryPricingPolicyId; }
    public void setExpiryPricingPolicyId(Integer expiryPricingPolicyId) { this.expiryPricingPolicyId = expiryPricingPolicyId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public BigDecimal getComputedPackBasePrice() { return computedPackBasePrice; }
    public void setComputedPackBasePrice(BigDecimal computedPackBasePrice) { this.computedPackBasePrice = computedPackBasePrice; }
    public BigDecimal getLineTotal() { return lineTotal; }
    public void setLineTotal(BigDecimal lineTotal) { this.lineTotal = lineTotal; }
}
