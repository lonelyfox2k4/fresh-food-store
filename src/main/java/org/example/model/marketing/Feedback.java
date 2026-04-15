package org.example.model.marketing;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Feedback {
    private long feedbackId;
    private long accountId;
    private Long orderId;
    private String subject;
    private String content;
    private String response;
    private byte status;
    private Long respondedByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime respondedAt;
    private LocalDateTime updatedAt;
}
