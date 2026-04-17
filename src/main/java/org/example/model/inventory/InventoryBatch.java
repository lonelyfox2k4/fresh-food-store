package org.example.model.inventory;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class InventoryBatch {
    private long batchId;
    private long receiptItemId;
    private int quantityOnHand;
    private int quantityReserved;
    private byte status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
