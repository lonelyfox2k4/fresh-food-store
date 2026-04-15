package org.example.model.order;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Cart {
    private long cartId;
    private long accountId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}