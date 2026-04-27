package org.example.dao;

import org.example.model.auth.Account;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class AccountDAO {

    // =========================================================================
    // 1. AUTHENTICATION & SECURITY (Đăng nhập, Đăng ký, Quên mật khẩu, Google)
    // =========================================================================

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
        return insertAccount(roleId, email, password, fullName, phone, false);
    }

    public boolean insertAccount(int roleId, String email, String password, String fullName, String phone, boolean emailVerified) {
        String sql = "INSERT INTO dbo.Accounts (roleId, email, passwordHash, fullName, phone, status, emailVerified) VALUES (?, ?, ?, ?, ?, 1, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String hashedPassword = encodePassword(password);
            ps.setInt(1, roleId);
            ps.setString(2, email);
            ps.setString(3, hashedPassword);
            ps.setString(4, fullName);
            ps.setString(5, phone);
            ps.setInt(6, emailVerified ? 1 : 0);
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

    public void linkGoogleAccount(long accountId, String googleId, String googleEmail) {
        // Lệnh này check xem đã link chưa, chưa thì mới Insert
        String sql = "IF NOT EXISTS (SELECT 1 FROM AccountGoogleLinks WHERE googleUserId = ?) " +
                "INSERT INTO AccountGoogleLinks (accountId, googleUserId, googleEmail, linkedAt) VALUES (?, ?, ?, SYSUTCDATETIME())";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, googleId);
            ps.setLong(2, accountId);
            ps.setString(3, googleId);
            ps.setString(4, googleEmail);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updatePassword(long accountId, String newPassword) {
        String sql = "UPDATE dbo.Accounts SET passwordHash = ? WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, encodePassword(newPassword));
            ps.setLong(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // =========================================================================
    // 2. USER MANAGEMENT & PROFILE (Quản lý người dùng, Cập nhật thông tin)
    // =========================================================================

    public Account getAccountById(long id) {
        String sql = "SELECT * FROM dbo.Accounts WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateProfile(long accountId, String fullName, String phone) {
        String sql = "UPDATE dbo.Accounts SET fullName = ?, phone = ? WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, phone);
            ps.setLong(3, accountId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(long id, boolean status) {
        String sql = "UPDATE dbo.Accounts SET status = ? WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateAccountAdmin(long id, String name, String phone, int roleId, boolean status) {
        String sql = "UPDATE dbo.Accounts SET fullName = ?, phone = ?, roleId = ?, status = ? WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setInt(3, roleId);
            ps.setBoolean(4, status);
            ps.setLong(5, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public int countUsers(String txtSearch, String roleId, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM dbo.Accounts WHERE 1=1 ");

        if (txtSearch != null && !txtSearch.trim().isEmpty()) {
            sql.append(" AND (fullName LIKE ? OR email LIKE ?) ");
        }
        if (roleId != null && !roleId.trim().isEmpty()) {
            sql.append(" AND roleId = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ? ");
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                ps.setString(i++, "%" + txtSearch + "%");
                ps.setString(i++, "%" + txtSearch + "%");
            }
            if (roleId != null && !roleId.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(roleId));
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setBoolean(i++, Boolean.parseBoolean(status));
            }

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Account> searchUsers(String txtSearch, String roleId, String status, String sortBy, String sortDir, int offset, int limit) {
        List<Account> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM dbo.Accounts WHERE 1=1 ");

        if (txtSearch != null && !txtSearch.trim().isEmpty()) {
            sql.append(" AND (fullName LIKE ? OR email LIKE ?) ");
        }
        if (roleId != null && !roleId.trim().isEmpty()) {
            sql.append(" AND roleId = ? ");
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND status = ? ");
        }

        // Ghép Sort (Nếu null hoặc rỗng thì mặc định theo ID)
        String orderBy = (sortBy != null && !sortBy.trim().isEmpty()) ? sortBy : "accountId";
        String orderDir = (sortDir != null && !sortDir.trim().isEmpty()) ? sortDir : "ASC";
        sql.append(" ORDER BY ").append(orderBy).append(" ").append(orderDir);
        
        // Thêm Pagination cho SQL Server
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            int i = 1;
            if (txtSearch != null && !txtSearch.trim().isEmpty()) {
                ps.setString(i++, "%" + txtSearch + "%");
                ps.setString(i++, "%" + txtSearch + "%");
            }
            if (roleId != null && !roleId.trim().isEmpty()) {
                ps.setInt(i++, Integer.parseInt(roleId));
            }
            if (status != null && !status.trim().isEmpty()) {
                ps.setBoolean(i++, Boolean.parseBoolean(status));
            }
            
            // Set Offset và Limit
            ps.setInt(i++, offset);
            ps.setInt(i++, limit);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new Account(rs.getLong("accountId"), rs.getInt("roleId"), rs.getString("email"),
                        rs.getString("passwordHash"), rs.getString("fullName"), rs.getString("phone"),
                        rs.getBoolean("status"), rs.getBoolean("emailVerified"), rs.getTimestamp("createdAt")));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
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

    public List<Account> getAccountsByRole(int roleId) {
        List<Account> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Accounts WHERE roleId = ? AND status = 1";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            try (ResultSet rs = ps.executeQuery()) {
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
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // =========================================================================
    // 3. DASHBOARD & STATS (Thống kê cho trang quản trị)
    // =========================================================================

    public java.util.Map<String, Integer> getUserSummaryStats() {
        java.util.Map<String, Integer> stats = new java.util.HashMap<>();
        String sql = "SELECT " +
                     "SUM(CASE WHEN roleId IN (1, 2) THEN 1 ELSE 0 END) as totalAdminManager, " +
                     "SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as totalBanned, " +
                     "SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as totalActive " +
                     "FROM dbo.Accounts";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                stats.put("adminManager", rs.getInt("totalAdminManager"));
                stats.put("banned", rs.getInt("totalBanned"));
                stats.put("active", rs.getInt("totalActive"));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }
}
