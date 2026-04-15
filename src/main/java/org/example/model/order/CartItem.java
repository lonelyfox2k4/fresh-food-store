package org.example.model.order;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class CartItem {
    private long cartItemId;
    private long cartId;
    private long productPackId;
    private int quantity;
    private LocalDateTime addedAt;
    private LocalDateTime updatedAt;
}