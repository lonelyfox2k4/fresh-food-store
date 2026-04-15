package org.example.model.inventory;

import lombok.*;

import java.time.LocalDateTime;

@Data
@NoArgsConstructor @AllArgsConstructor
public class Supplier {
    private long supplierId;
    private String supplierName;
    private String phone;
    private String email;
    private String address;
    private boolean status;
    private String note;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
