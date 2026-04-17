package org.example.model.order;

import lombok.*;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Order {
    private long orderId;
    private String orderCode;
    private long accountId;
    private Long shipperId;
    private byte orderStatus;
    private byte paymentStatus;
    private Byte shippingStatus;
    private BigDecimal subtotalAmount;
    private BigDecimal discountAmount;
    private BigDecimal shippingFee;
    private BigDecimal totalAmount;
    private String recipientNameSnapshot;
    private String recipientPhoneSnapshot;
    private String shippingAddressSnapshot;
    private String note;
    private LocalDateTime placedAt;
    private LocalDateTime paidAt;
    private LocalDateTime cancelledAt;
    private String cancelledReason;

    // Explicit accessors (safety fallback if Lombok annotation processing is unavailable)
    public long getOrderId() { return orderId; }
    public void setOrderId(long orderId) { this.orderId = orderId; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }
    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }
    public Long getShipperId() { return shipperId; }
    public void setShipperId(Long shipperId) { this.shipperId = shipperId; }
    public byte getOrderStatus() { return orderStatus; }
    public void setOrderStatus(byte orderStatus) { this.orderStatus = orderStatus; }
    public byte getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(byte paymentStatus) { this.paymentStatus = paymentStatus; }
    public Byte getShippingStatus() { return shippingStatus; }
    public void setShippingStatus(Byte shippingStatus) { this.shippingStatus = shippingStatus; }
    public BigDecimal getSubtotalAmount() { return subtotalAmount; }
    public void setSubtotalAmount(BigDecimal subtotalAmount) { this.subtotalAmount = subtotalAmount; }
    public BigDecimal getDiscountAmount() { return discountAmount; }
    public void setDiscountAmount(BigDecimal discountAmount) { this.discountAmount = discountAmount; }
    public BigDecimal getShippingFee() { return shippingFee; }
    public void setShippingFee(BigDecimal shippingFee) { this.shippingFee = shippingFee; }
    public BigDecimal getTotalAmount() { return totalAmount; }
    public void setTotalAmount(BigDecimal totalAmount) { this.totalAmount = totalAmount; }
    public String getRecipientNameSnapshot() { return recipientNameSnapshot; }
    public void setRecipientNameSnapshot(String v) { this.recipientNameSnapshot = v; }
    public String getRecipientPhoneSnapshot() { return recipientPhoneSnapshot; }
    public void setRecipientPhoneSnapshot(String v) { this.recipientPhoneSnapshot = v; }
    public String getShippingAddressSnapshot() { return shippingAddressSnapshot; }
    public void setShippingAddressSnapshot(String v) { this.shippingAddressSnapshot = v; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public LocalDateTime getPlacedAt() { return placedAt; }
    public void setPlacedAt(LocalDateTime placedAt) { this.placedAt = placedAt; }
    public LocalDateTime getPaidAt() { return paidAt; }
    public void setPaidAt(LocalDateTime paidAt) { this.paidAt = paidAt; }
    public LocalDateTime getCancelledAt() { return cancelledAt; }
    public void setCancelledAt(LocalDateTime cancelledAt) { this.cancelledAt = cancelledAt; }
    public String getCancelledReason() { return cancelledReason; }
    public void setCancelledReason(String cancelledReason) { this.cancelledReason = cancelledReason; }
}
