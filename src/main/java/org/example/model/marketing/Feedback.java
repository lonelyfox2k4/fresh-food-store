package org.example.model.marketing;

import lombok.*;

import java.time.LocalDateTime;
import java.util.List;
import org.example.model.order.OrderItem;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Feedback {
    private long feedbackId;
    private long accountId;
    private Long orderId;
    private Long reviewId;
    private String subject;
    private String content;
    private String response;
    private String customerName;
    private byte status;
    private Long respondedByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime respondedAt;
    private LocalDateTime updatedAt;
    private int rating;
    private String orderCode;
    private List<OrderItem> itemList;
}
