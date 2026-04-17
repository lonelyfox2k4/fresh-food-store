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

    public int getRuleId() { return ruleId; }
    public void setRuleId(int ruleId) { this.ruleId = ruleId; }
    public int getPolicyId() { return policyId; }
    public void setPolicyId(int policyId) { this.policyId = policyId; }
    public int getMinDaysRemaining() { return minDaysRemaining; }
    public void setMinDaysRemaining(int minDaysRemaining) { this.minDaysRemaining = minDaysRemaining; }
    public BigDecimal getSellPricePercent() { return sellPricePercent; }
    public void setSellPricePercent(BigDecimal sellPricePercent) { this.sellPricePercent = sellPricePercent; }
}
