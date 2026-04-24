package org.example.model.order;

import java.math.BigDecimal;

public class CartItemView {
    private long cartItemId;
    private long productId;
    private long productPackId;
    private String productName;
    private Integer packWeightGram;
    private String imageUrl;
    private BigDecimal unitPrice;
    private int quantity;
    private BigDecimal lineTotal;
    private int availableStock;

    public long getCartItemId() {
        return cartItemId;
    }
    public void setCartItemId(long cartItemId) {
        this.cartItemId = cartItemId;
    }

    public long getProductId() {
        return productId;
    }

    public void setProductId(long productId) {
        this.productId = productId;
    }

    public long getProductPackId() {
        return productPackId;
    }

    public void setProductPackId(long productPackId) {
        this.productPackId = productPackId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getPackWeightGram() {
        return packWeightGram;
    }

    public void setPackWeightGram(Integer packWeightGram) {
        this.packWeightGram = packWeightGram;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getLineTotal() {
        return lineTotal;
    }

    public void setLineTotal(BigDecimal lineTotal) {
        this.lineTotal = lineTotal;
    }

    public int getAvailableStock() {
        return availableStock;
    }

    public void setAvailableStock(int availableStock) {
        this.availableStock = availableStock;
    }
}
