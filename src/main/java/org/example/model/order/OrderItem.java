package org.example.model.order;

import lombok.*;

import java.math.BigDecimal;

@Data
@NoArgsConstructor @AllArgsConstructor
public class OrderItem {
    private long orderItemId;
    private long orderId;
    private long productId;
    private Long productPackId;
    private String productNameSnapshot;
    private int packWeightGramSnapshot;
    private String imageUrlSnapshot;
    private BigDecimal computedPackBasePriceSnapshot;
    private int orderedQuantity;
    private BigDecimal lineSubtotalSnapshot;
    private BigDecimal lineDiscountSnapshot;
    private BigDecimal lineTotalSnapshot;
}
