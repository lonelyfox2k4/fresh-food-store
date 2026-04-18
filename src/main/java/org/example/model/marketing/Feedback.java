package org.example.model.marketing;

import lombok.*;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Feedback {
    private long feedbackId;
    private long accountId;
    private Long orderId;
    private Long reviewId;
    private String subject;
    private String content;
    private Integer rating;
    private String response;
    private byte status;
    private Long respondedByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime respondedAt;
    private LocalDateTime updatedAt;

    // Explicit Getters and Setters (Fallback for environments where Lombok annotation processing is disabled)
    public long getFeedbackId() { return feedbackId; }
    public void setFeedbackId(long feedbackId) { this.feedbackId = feedbackId; }
    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getReviewId() { return reviewId; }
    public void setReviewId(Long reviewId) { this.reviewId = reviewId; }
    public String getSubject() { return subject; }
    public void setSubject(String subject) { this.subject = subject; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getRating() { return rating; }
    public void setRating(Integer rating) { this.rating = rating; }
    public String getResponse() { return response; }
    public void setResponse(String response) { this.response = response; }
    public byte getStatus() { return status; }
    public void setStatus(byte status) { this.status = status; }
    public Long getRespondedByAccountId() { return respondedByAccountId; }
    public void setRespondedByAccountId(Long respondedByAccountId) { this.respondedByAccountId = respondedByAccountId; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getRespondedAt() { return respondedAt; }
    public void setRespondedAt(LocalDateTime respondedAt) { this.respondedAt = respondedAt; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
