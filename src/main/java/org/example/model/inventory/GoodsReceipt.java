package org.example.model.inventory;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class GoodsReceipt {
    private long receiptId;
    private String receiptCode;
    private long supplierId;
    private long receivedByAccountId;
    private LocalDateTime receivedAt;
    private byte status;
    private String note;
    private LocalDateTime createdAt;
}
