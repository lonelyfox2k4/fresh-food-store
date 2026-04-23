package org.example.dto.inventory;

public class ProductPackOption {
    private long productPackId;
    private long productId;
    private String productName;
    private int packWeightGram;
    private String displayName;

    public long getProductPackId() { return productPackId; }
    public void setProductPackId(long productPackId) { this.productPackId = productPackId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getPackWeightGram() { return packWeightGram; }
    public void setPackWeightGram(int packWeightGram) { this.packWeightGram = packWeightGram; }
    public String getDisplayName() { return displayName; }
    public void setDisplayName(String displayName) { this.displayName = displayName; }
}
