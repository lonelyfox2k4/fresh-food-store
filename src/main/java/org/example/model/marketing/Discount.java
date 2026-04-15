package org.example.model.marketing;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Discount {
    private long discountId;
    private String discountName;
    private byte targetType;
    private Long productId;
    private Integer categoryId;
    private byte discountType;
    private BigDecimal discountValue;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private byte status;
    private long createdByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}