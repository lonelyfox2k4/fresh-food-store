package org.example.model.content;

import lombok.*;
import java.time.LocalDateTime;

@Data @NoArgsConstructor @AllArgsConstructor
public class NewsArticle {
    private long newsId;
    private String title;
    private String summary;
    private String content;
    private String imageUrl;
    private byte status;
    private long createdByAccountId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime publishedAt;
}