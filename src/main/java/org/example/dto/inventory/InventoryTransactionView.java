package org.example.dto.inventory;

import java.time.LocalDateTime;

public class InventoryTransactionView {
    private long inventoryTransactionId;
    private int transactionType;
    private int quantity;
    private String referenceType;
    private Long referenceId;
    private Long performedByAccountId;
    private String performerName;
    private String note;
    private LocalDateTime transactionAt;

    public long getInventoryTransactionId() { return inventoryTransactionId; }
    public void setInventoryTransactionId(long inventoryTransactionId) { this.inventoryTransactionId = inventoryTransactionId; }
    public int getTransactionType() { return transactionType; }
    public void setTransactionType(int transactionType) { this.transactionType = transactionType; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public String getReferenceType() { return referenceType; }
    public void setReferenceType(String referenceType) { this.referenceType = referenceType; }
    public Long getReferenceId() { return referenceId; }
    public void setReferenceId(Long referenceId) { this.referenceId = referenceId; }
    public Long getPerformedByAccountId() { return performedByAccountId; }
    public void setPerformedByAccountId(Long performedByAccountId) { this.performedByAccountId = performedByAccountId; }
    public String getPerformerName() { return performerName; }
    public void setPerformerName(String performerName) { this.performerName = performerName; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getTransactionAt() { return transactionAt; }
    public void setTransactionAt(LocalDateTime transactionAt) { this.transactionAt = transactionAt; }
}
