package org.example.model.auth;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.sql.Timestamp;

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

    public Account() {}

    public Account(long accountId, int roleId, String email, String passwordHash, String fullName, String phone, boolean status, boolean emailVerified, Timestamp createdAt) {
        this.accountId = accountId;
        this.roleId = roleId;
        this.email = email;
        this.passwordHash = passwordHash;
        this.fullName = fullName;
        this.phone = phone;
        this.status = status;
        this.emailVerified = emailVerified;
        this.createdAt = createdAt;
    }

    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }
    public int getRoleId() { return roleId; }
    public void setRoleId(int roleId) { this.roleId = roleId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPasswordHash() { return passwordHash; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public boolean isEmailVerified() { return emailVerified; }
    public void setEmailVerified(boolean emailVerified) { this.emailVerified = emailVerified; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}