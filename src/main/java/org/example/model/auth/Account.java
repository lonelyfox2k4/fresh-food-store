package org.example.model.auth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Account {
    private long accountId;
    private int roleId;
    private String email;
    private String passwordHash;
    private String fullName;
    private String phone;
    private boolean status;
    private boolean emailVerified;
    private Timestamp createdAt;
}