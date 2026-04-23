package org.example.dto.inventory;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class GoodsReceiptForm {
    private Long receiptId;
    private String receiptCode;
    private Long supplierId;
    private LocalDateTime receivedAt;
    private String note;
    private List<GoodsReceiptLineForm> lines = new ArrayList<>();

    public Long getReceiptId() {
        return receiptId;
    }

    public void setReceiptId(Long receiptId) {
        this.receiptId = receiptId;
    }

    public String getReceiptCode() {
        return receiptCode;
    }

    public void setReceiptCode(String receiptCode) {
        this.receiptCode = receiptCode;
    }

    public Long getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(Long supplierId) {
        this.supplierId = supplierId;
    }

    public LocalDateTime getReceivedAt() {
        return receivedAt;
    }

    public void setReceivedAt(LocalDateTime receivedAt) {
        this.receivedAt = receivedAt;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public List<GoodsReceiptLineForm> getLines() {
        return lines;
    }

    public void setLines(List<GoodsReceiptLineForm> lines) {
        this.lines = lines;
    }
}
