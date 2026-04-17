package org.example.model.catalog;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ExpiryPricingPolicy {
    private int policyId;
    private String policyName;
    private boolean status;
    private String note;
    private LocalDateTime createdAt;
    private Long createdById;
    private LocalDateTime updatedAt;
    private Long updatedById;
}
