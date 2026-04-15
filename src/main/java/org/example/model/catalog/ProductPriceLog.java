package org.example.model.catalog;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ProductPriceLog {
    private long priceLogId;
    private long productId;
    private BigDecimal oldBasePriceAmount;
    private BigDecimal newBasePriceAmount;
    private long changedByAccountId;
    private LocalDateTime changedAt;
    private String note;
}
