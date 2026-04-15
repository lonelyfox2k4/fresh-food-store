package org.example.model.catalog;
import lombok.*;

import java.time.LocalDateTime;

@Data @NoArgsConstructor @AllArgsConstructor
public class Category {
    private int categoryId;
    private String categoryName;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}