package org.example.dao;

import org.example.model.Account;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AccountDAO {
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


    public boolean insertAccount(int roleId, String email, String password, String fullName, String phone) {
        String sql = "INSERT INTO dbo.Accounts (roleId, email, passwordHash, fullName, phone, status) VALUES (?, ?, ?, ?, ?, 1)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            // Nếu trùng Email, SQL Server sẽ ném Exception, hàm trả về false
            e.printStackTrace();
            return false;
        }
    }

    public Account login(String email, String password) {
        String sql = "SELECT * FROM dbo.Accounts WHERE email = ? AND passwordHash = ? AND status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, password);
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
}