package org.example.model.order;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class OrderVoucher {
    private long orderVoucherId;
    private long orderId;
    private Long voucherId;
    private String voucherCodeSnapshot;
    private BigDecimal discountAmountSnapshot;
    private LocalDateTime createdAt;
}
