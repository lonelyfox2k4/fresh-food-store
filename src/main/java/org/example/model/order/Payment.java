package org.example.model.order;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Payment {
    private long paymentId;
    private long orderId;
    private String provider;
    private BigDecimal amount;
    private byte paymentStatus;
    private String gatewayTransactionId;
    private String gatewayOrderRef;
    private String paymentUrl;
    private LocalDateTime requestedAt;
    private LocalDateTime paidAt;
    private LocalDateTime failedAt;
    private String rawResponse;
}
