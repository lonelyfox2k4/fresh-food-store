package org.example.dao;

import org.example.model.auth.Account;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class AccountDAO {

    // --- HÀM MÃ HÓA (GIỮ NGUYÊN) ---
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

    // --- CẬP NHẬT HÀM INSERT (Mã hóa trước khi lưu) ---
    public boolean insertAccount(int roleId, String email, String password, String fullName, String phone) {
        String sql = "INSERT INTO dbo.Accounts (roleId, email, passwordHash, fullName, phone, status) VALUES (?, ?, ?, ?, ?, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Mã hóa mật khẩu ở đây
            String hashedPassword = encodePassword(password);

            ps.setInt(1, roleId);
            ps.setString(2, email);
            ps.setString(3, hashedPassword); // Lưu bản đã mã hóa
            ps.setString(4, fullName);
            ps.setString(5, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- CẬP NHẬT HÀM LOGIN (Mã hóa đầu vào để so sánh) ---
    public Account login(String email, String password) {
        String sql = "SELECT * FROM dbo.Accounts WHERE email = ? AND passwordHash = ? AND status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // Mã hóa mật khẩu người dùng vừa gõ để so sánh với mã hash trong DB
            String hashedPassword = encodePassword(password);

            ps.setString(1, email);
            ps.setString(2, hashedPassword);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getLong("accountId"), rs.getInt("roleId"), rs.getString("email"),
                            rs.getString("fullName"), rs.getString("phone"), rs.getBoolean("status"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    // --- CÁC HÀM KHÁC GIỮ NGUYÊN ---
    public List<Account> getAllAccounts() {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT accountId, roleId, email, fullName, phone, status, createdAt FROM dbo.Accounts ORDER BY createdAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Account(
                        rs.getLong("accountId"), rs.getInt("roleId"), rs.getString("email"),
                        rs.getString("fullName"), rs.getString("phone"), rs.getBoolean("status"),
                        rs.getTimestamp("createdAt")
                ));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
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

    public Account getAccountByEmail(String email) {
        String sql = "SELECT accountId, roleId, email, fullName, phone, status, createdAt FROM dbo.Accounts WHERE email = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getLong("accountId"),
                            rs.getInt("roleId"),
                            rs.getString("email"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getBoolean("status"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public Account getAccountById(long accountId) {
        String sql = "SELECT accountId, roleId, email, fullName, phone, status, createdAt FROM dbo.Accounts WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Account(
                            rs.getLong("accountId"),
                            rs.getInt("roleId"),
                            rs.getString("email"),
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getBoolean("status"),
                            rs.getTimestamp("createdAt")
                    );
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateProfile(long accountId, String fullName, String phone) {
        String sql = "UPDATE dbo.Accounts SET fullName = ?, phone = ?, updatedAt = SYSUTCDATETIME() WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setLong(3, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePassword(long accountId, String newPassword) {
        String sql = "UPDATE dbo.Accounts SET passwordHash = ?, updatedAt = SYSUTCDATETIME() WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encodePassword(newPassword));
            ps.setLong(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
