package org.example.model.order;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Order {
    private long orderId;
    private String orderCode;
    private long accountId;
    private Long shipperId;
    private byte orderStatus;
    private byte paymentStatus;
    private Byte shippingStatus; // Byte (Object wrapper) vì SQL cho phép NULL
    private BigDecimal subtotalAmount;
    private BigDecimal discountAmount;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount;
    private String recipientNameSnapshot;
    private String recipientPhoneSnapshot;
    private String shippingAddressSnapshot;
    private String note;
    private LocalDateTime placedAt;
    private LocalDateTime paidAt;
    private LocalDateTime cancelledAt;
    private String cancelledReason;
}
