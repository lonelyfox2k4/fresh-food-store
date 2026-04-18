package org.example.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AccountDTO {
    private long accountId;
    private String email;
    private String fullName;
    private String phone;
    private String roleName;
    private boolean status;
    private boolean emailVerified;
    private Timestamp createdAt;
}