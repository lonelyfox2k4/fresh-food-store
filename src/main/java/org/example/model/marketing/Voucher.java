package org.example.model.marketing;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Voucher {
    private long voucherId;
    private String voucherCode;
    private String voucherName;
    private byte discountType;
    private BigDecimal discountValue;
    private BigDecimal minOrderAmount;
    private BigDecimal maxDiscountAmount;
    private Integer usageLimit;
    private int usedCount;
    private LocalDateTime startAt;
    private LocalDateTime endAt;
    private byte status;
    private long createdByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
