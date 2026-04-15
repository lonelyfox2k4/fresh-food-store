package org.example.model.marketing;

import lombok.*;

import java.time.LocalDateTime;


@Data@NoArgsConstructor @AllArgsConstructor
public class VoucherRequest {
    private long voucherRequestId;
    private Long voucherId;
    private long accountId;
    private byte requestStatus;
    private String requestNote;
    private Long reviewedByAccountId;
    private LocalDateTime requestedAt;
    private LocalDateTime reviewedAt;
}
