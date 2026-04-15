package org.example.dto;

import java.sql.Timestamp;

public class AccountDTO {
    private long accountId;
    private String email;
    private String fullName;
    private String phone;
    private String roleName;
    private boolean status;
    private Timestamp createdAt;

    public AccountDTO() {}

    public AccountDTO(long accountId, String email, String fullName, String phone, String roleName, boolean status, Timestamp createdAt) {
        this.accountId = accountId;
        this.email = email;
        this.fullName = fullName;
        this.phone = phone;
        this.roleName = roleName;
        this.status = status;
        this.createdAt = createdAt;
    }

    public long getAccountId() { return accountId; }
    public void setAccountId(long accountId) { this.accountId = accountId; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getRoleName() { return roleName; }
    public void setRoleName(String roleName) { this.roleName = roleName; }
    public boolean isStatus() { return status; }
    public void setStatus(boolean status) { this.status = status; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}

