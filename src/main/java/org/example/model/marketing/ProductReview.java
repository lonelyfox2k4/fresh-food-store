package org.example.model.marketing;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ProductReview {
    private long reviewId;
    private long productId;
    private long accountId;
    private Long sourceOrderItemId;
    private byte rating;
    private String comment;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
