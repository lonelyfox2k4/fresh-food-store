package org.example.dao;

import org.example.model.auth.Account;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class AccountDAO {

    public String encodePassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(password.getBytes());
            byte[] digest = md.digest();
            StringBuilder sb = new StringBuilder();
            for (byte b : digest) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException(e);
        }
    }

    public boolean insertAccount(int roleId, String email, String password, String fullName, String phone) {
        // Mặc định emailVerified là 0 khi đăng ký mới
        String sql = "INSERT INTO dbo.Accounts (roleId, email, passwordHash, fullName, phone, status, emailVerified) VALUES (?, ?, ?, ?, ?, 1, 0)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = encodePassword(password);
            ps.setInt(1, roleId);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public Account login(String email, String password) {
        String sql = "SELECT * FROM dbo.Accounts WHERE email = ? AND passwordHash = ? AND status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = encodePassword(password);
            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Truyền đủ 9 tham số theo thứ tự trong Model Account
                    return new Account(
                            rs.getLong("accountId"),
                            rs.getInt("roleId"),
                            rs.getString("email"),
                            rs.getString("passwordHash"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getBoolean("status"),
                            rs.getBoolean("emailVerified"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        // Phải SELECT thêm emailVerified
        String sql = "SELECT * FROM dbo.Accounts ORDER BY createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Account(
                        rs.getLong("accountId"),
                        rs.getInt("roleId"),
                        rs.getString("email"),
                        rs.getString("passwordHash"),
                        rs.getString("fullName"),
                        rs.getString("phone"),
                        rs.getBoolean("status"),
                        rs.getBoolean("emailVerified"),
                        rs.getTimestamp("createdAt")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Account getAccountByEmail(String email) {
        String sql = "SELECT * FROM dbo.Accounts WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getLong("accountId"),
                            rs.getInt("roleId"),
                            rs.getString("email"),
                            rs.getString("passwordHash"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getBoolean("status"),
                            rs.getBoolean("emailVerified"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean verifyEmail(String email) {
        String sql = "UPDATE dbo.Accounts SET emailVerified = 1 WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateStatus(long id, boolean status) {
        String sql = "UPDATE dbo.Accounts SET status = ?, updatedAt = SYSUTCDATETIME() WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean resetPassword(String email, String encodedPass) {
        String sql = "UPDATE dbo.Accounts SET passwordHash = ? WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encodedPass);
            ps.setString(2, email);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}