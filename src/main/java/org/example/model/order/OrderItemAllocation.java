package org.example.model.order;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@Data
@NoArgsConstructor @AllArgsConstructor
public class OrderItemAllocation {
    private long allocationId;
    private long orderItemId;
    private long batchId;
    private String batchCodeSnapshot;
    private LocalDate expiryDateSnapshot; // SQL là DATE
    private int quantity;
    private BigDecimal basePackPriceSnapshot;
    private BigDecimal sellPricePercentSnapshot;
    private BigDecimal finalPackPriceSnapshot;
    private BigDecimal lineTotalSnapshot;
}
