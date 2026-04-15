package org.example.model.marketing;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Wishlist {
    private long wishlistId;
    private long accountId;
    private long productId;
    private LocalDateTime createdAt;
}
