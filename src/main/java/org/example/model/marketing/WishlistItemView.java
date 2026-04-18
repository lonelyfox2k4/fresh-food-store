package org.example.model.marketing;

import java.math.BigDecimal;
import java.time.LocalDateTime;

public class WishlistItemView {
    private long wishlistId;
    private long productId;
    private String productName;
    private String imageUrl;
    private BigDecimal currentPrice;
    private int priceBaseWeightGram;
    private LocalDateTime createdAt;

    public long getWishlistId() {
        return wishlistId;
    }

    public void setWishlistId(long wishlistId) {
        this.wishlistId = wishlistId;
    }

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

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public BigDecimal getCurrentPrice() {
        return currentPrice;
    }

    public void setCurrentPrice(BigDecimal currentPrice) {
        this.currentPrice = currentPrice;
    }

    public int getPriceBaseWeightGram() {
        return priceBaseWeightGram;
    }

    public void setPriceBaseWeightGram(int priceBaseWeightGram) {
        this.priceBaseWeightGram = priceBaseWeightGram;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
