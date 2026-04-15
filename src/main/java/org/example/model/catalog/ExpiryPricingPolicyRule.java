package org.example.model.catalog;

import lombok.*;

import java.math.BigDecimal;

@Data
@NoArgsConstructor @AllArgsConstructor
public class ExpiryPricingPolicyRule {
    private int ruleId;
    private int policyId;
    private int minDaysRemaining;
    private BigDecimal sellPricePercent;
}
