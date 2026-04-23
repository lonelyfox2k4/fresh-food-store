package org.example.dto.inventory;

import java.math.BigDecimal;
import java.time.LocalDate;

public class GoodsReceiptItemView {
    private long receiptItemId;
    private long productPackId;
    private long batchId;
    private String productName;
    private int packWeightGram;
    private String batchCode;
    private LocalDate manufactureDate;
    private LocalDate expiryDate;
    private int quantityReceived;
    private BigDecimal unitCost;
    private int quantityOnHand;
    private int quantityReserved;
    private int availableStock;
    private long daysRemaining;
    private boolean expired;
    private boolean expiringSoon;
    private String note;

    public long getReceiptItemId() { return receiptItemId; }
    public void setReceiptItemId(long receiptItemId) { this.receiptItemId = receiptItemId; }
    public long getProductPackId() { return productPackId; }
    public void setProductPackId(long productPackId) { this.productPackId = productPackId; }
    public long getBatchId() { return batchId; }
    public void setBatchId(long batchId) { this.batchId = batchId; }
    public String getProductName() { return productName; }
    public void setProductName(String productName) { this.productName = productName; }
    public int getPackWeightGram() { return packWeightGram; }
    public void setPackWeightGram(int packWeightGram) { this.packWeightGram = packWeightGram; }
    public String getBatchCode() { return batchCode; }
    public void setBatchCode(String batchCode) { this.batchCode = batchCode; }
    public LocalDate getManufactureDate() { return manufactureDate; }
    public void setManufactureDate(LocalDate manufactureDate) { this.manufactureDate = manufactureDate; }
    public LocalDate getExpiryDate() { return expiryDate; }
    public void setExpiryDate(LocalDate expiryDate) { this.expiryDate = expiryDate; }
    public int getQuantityReceived() { return quantityReceived; }
    public void setQuantityReceived(int quantityReceived) { this.quantityReceived = quantityReceived; }
    public BigDecimal getUnitCost() { return unitCost; }
    public void setUnitCost(BigDecimal unitCost) { this.unitCost = unitCost; }
    public int getQuantityOnHand() { return quantityOnHand; }
    public void setQuantityOnHand(int quantityOnHand) { this.quantityOnHand = quantityOnHand; }
    public int getQuantityReserved() { return quantityReserved; }
    public void setQuantityReserved(int quantityReserved) { this.quantityReserved = quantityReserved; }
    public int getAvailableStock() { return availableStock; }
    public void setAvailableStock(int availableStock) { this.availableStock = availableStock; }
    public long getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(long daysRemaining) { this.daysRemaining = daysRemaining; }
    public boolean isExpired() { return expired; }
    public void setExpired(boolean expired) { this.expired = expired; }
    public boolean isExpiringSoon() { return expiringSoon; }
    public void setExpiringSoon(boolean expiringSoon) { this.expiringSoon = expiringSoon; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
}
