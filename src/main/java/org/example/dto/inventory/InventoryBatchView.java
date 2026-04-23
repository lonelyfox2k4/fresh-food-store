package org.example.dto.inventory;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class InventoryBatchView {
    private long batchId;
    private long receiptId;
    private long receiptItemId;
    private long productId;
    private long productPackId;
    private long supplierId;
    private String receiptCode;
    private String supplierName;
    private String productName;
    private int packWeightGram;
    private String batchCode;
    private LocalDate manufactureDate;
    private LocalDate expiryDate;
    private LocalDateTime receivedAt;
    private int quantityOnHand;
    private int quantityReserved;
    private int availableStock;
    private BigDecimal unitCost;
    private String note;
    private int status;
    private long daysRemaining;
    private boolean expired;
    private boolean expiringSoon;
    private List<InventoryTransactionView> transactions = new ArrayList<>();

    public long getBatchId() { return batchId; }
    public void setBatchId(long batchId) { this.batchId = batchId; }
    public long getReceiptId() { return receiptId; }
    public void setReceiptId(long receiptId) { this.receiptId = receiptId; }
    public long getReceiptItemId() { return receiptItemId; }
    public void setReceiptItemId(long receiptItemId) { this.receiptItemId = receiptItemId; }
    public long getProductId() { return productId; }
    public void setProductId(long productId) { this.productId = productId; }
    public long getProductPackId() { return productPackId; }
    public void setProductPackId(long productPackId) { this.productPackId = productPackId; }
    public long getSupplierId() { return supplierId; }
    public void setSupplierId(long supplierId) { this.supplierId = supplierId; }
    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
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
    public LocalDateTime getReceivedAt() { return receivedAt; }
    public void setReceivedAt(LocalDateTime receivedAt) { this.receivedAt = receivedAt; }
    public int getQuantityOnHand() { return quantityOnHand; }
    public void setQuantityOnHand(int quantityOnHand) { this.quantityOnHand = quantityOnHand; }
    public int getQuantityReserved() { return quantityReserved; }
    public void setQuantityReserved(int quantityReserved) { this.quantityReserved = quantityReserved; }
    public int getAvailableStock() { return availableStock; }
    public void setAvailableStock(int availableStock) { this.availableStock = availableStock; }
    public BigDecimal getUnitCost() { return unitCost; }
    public void setUnitCost(BigDecimal unitCost) { this.unitCost = unitCost; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public long getDaysRemaining() { return daysRemaining; }
    public void setDaysRemaining(long daysRemaining) { this.daysRemaining = daysRemaining; }
    public boolean isExpired() { return expired; }
    public void setExpired(boolean expired) { this.expired = expired; }
    public boolean isExpiringSoon() { return expiringSoon; }
    public void setExpiringSoon(boolean expiringSoon) { this.expiringSoon = expiringSoon; }
    public List<InventoryTransactionView> getTransactions() { return transactions; }
    public void setTransactions(List<InventoryTransactionView> transactions) { this.transactions = transactions; }
}
