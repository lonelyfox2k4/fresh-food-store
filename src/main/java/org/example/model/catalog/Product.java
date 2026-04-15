package org.example.model.catalog;

import lombok.*;

import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Product {
    private long productId;
    private int categoryId;
    private String productName;
    private String description;
    private String imageUrl;
    private BigDecimal basePriceAmount;
    private int priceBaseWeightGram;
    private Integer expiryPricingPolicyId;
    private boolean status;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
