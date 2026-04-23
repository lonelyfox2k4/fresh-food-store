package org.example.dto.inventory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class GoodsReceiptView {
    private long receiptId;
    private String receiptCode;
    private long supplierId;
    private String supplierName;
    private String supplierPhone;
    private LocalDateTime receivedAt;
    private int status;
    private String note;
    private boolean editable;
    private int totalLines;
    private int totalQuantity;
    private List<GoodsReceiptItemView> items = new ArrayList<>();

    public long getReceiptId() { return receiptId; }
    public void setReceiptId(long receiptId) { this.receiptId = receiptId; }
    public String getReceiptCode() { return receiptCode; }
    public void setReceiptCode(String receiptCode) { this.receiptCode = receiptCode; }
    public long getSupplierId() { return supplierId; }
    public void setSupplierId(long supplierId) { this.supplierId = supplierId; }
    public String getSupplierName() { return supplierName; }
    public void setSupplierName(String supplierName) { this.supplierName = supplierName; }
    public String getSupplierPhone() { return supplierPhone; }
    public void setSupplierPhone(String supplierPhone) { this.supplierPhone = supplierPhone; }
    public LocalDateTime getReceivedAt() { return receivedAt; }
    public void setReceivedAt(LocalDateTime receivedAt) { this.receivedAt = receivedAt; }
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public boolean isEditable() { return editable; }
    public void setEditable(boolean editable) { this.editable = editable; }
    public int getTotalLines() { return totalLines; }
    public void setTotalLines(int totalLines) { this.totalLines = totalLines; }
    public int getTotalQuantity() { return totalQuantity; }
    public void setTotalQuantity(int totalQuantity) { this.totalQuantity = totalQuantity; }
    public List<GoodsReceiptItemView> getItems() { return items; }
    public void setItems(List<GoodsReceiptItemView> items) { this.items = items; }
}
