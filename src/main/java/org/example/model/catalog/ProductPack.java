package org.example.model.catalog;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ProductPack {
    private long productPackId;
    private long productId;
    private int packWeightGram;
    private String sku;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
