package org.example.model.catalog;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ProductPack {
    private long productPackId;
    private long productId;
    private int packWeightGram;
    private String sku;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /** Tồn kho khả dụng – tính từ InventoryBatches lúc query, không lưu trong DB */
    private int availableStock;

    public long getProductPackId() { return productPackId; }
    public void setProductPackId(long productPackId) { this.productPackId = productPackId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public int getPackWeightGram() { return packWeightGram; }
    public void setPackWeightGram(int packWeightGram) { this.packWeightGram = packWeightGram; }
    public String getSku() { return sku; }
    public void setSku(String sku) { this.sku = sku; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public int getAvailableStock() { return availableStock; }
    public void setAvailableStock(int availableStock) { this.availableStock = availableStock; }
}
