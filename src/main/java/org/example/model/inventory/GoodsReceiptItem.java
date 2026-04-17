package org.example.model.inventory;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class GoodsReceiptItem {
    private long receiptItemId;
    private long receiptId;
    private long productPackId;
    private String batchCode;
    private LocalDate manufactureDate; // Chú ý: Dùng LocalDate vì SQL là DATE
    private LocalDate expiryDate;      // Chú ý: Dùng LocalDate vì SQL là DATE
    private int quantityReceived;
    private BigDecimal unitCost;
    private String note;
    private LocalDateTime createdAt;
}
