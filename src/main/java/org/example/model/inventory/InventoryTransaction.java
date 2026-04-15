package org.example.model.inventory;

import lombok.*;

import java.time.LocalDateTime;

@Data@NoArgsConstructor @AllArgsConstructor
public class InventoryTransaction {
    private long inventoryTransactionId;
    private long batchId;
    private byte transactionType;
    private int quantity;
    private String referenceType;
    private Long referenceId;
    private Long performedByAccountId;
    private String note;
    private LocalDateTime transactionAt;
}
