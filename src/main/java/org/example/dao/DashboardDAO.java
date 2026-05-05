package org.example.dao;

import org.example.dto.DashboardDTO;
import org.example.model.auth.Account;
import org.example.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class DashboardDAO {

    public DashboardDTO getDashboardStats() {
        int totalUsers = 0;
        int activeUsers = 0;
        int lockedUsers = 0;
        Map<String, Integer> roleDistribution = new HashMap<>();
        List<Account> recentUsers = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection()) {
            // 1. Fetch User Counts
            String countSql = "SELECT " +
                              "COUNT(*) as total, " +
                              "SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) as active, " +
                              "SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) as locked " +
                              "FROM dbo.Accounts";
            try (PreparedStatement ps = conn.prepareStatement(countSql);
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalUsers = rs.getInt("total");
                    activeUsers = rs.getInt("active");
                    lockedUsers = rs.getInt("locked");
                }
            }

            // 2. Count users by role
            String roleSql = "SELECT r.roleName, COUNT(a.accountId) as count " +
                             "FROM dbo.Roles r " +
                             "LEFT JOIN dbo.Accounts a ON r.roleId = a.roleId " +
                             "GROUP BY r.roleName";
            try (PreparedStatement ps = conn.prepareStatement(roleSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roleDistribution.put(rs.getString("roleName"), rs.getInt("count"));
                }
            }

            // 3. Fetch 5 Recent Users
            String recentSql = "SELECT TOP 5 * FROM dbo.Accounts ORDER BY createdAt DESC";
            try (PreparedStatement ps = conn.prepareStatement(recentSql);
                 ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    recentUsers.add(new Account(
                            rs.getLong("accountId"),
                            rs.getInt("roleId"),
                            rs.getString("email"),
                            null, // Don't need passwordHash for dashboard
                            rs.getString("fullName"),
                            rs.getString("phone"),
                            rs.getBoolean("status"),
                            rs.getBoolean("emailVerified"),
                            rs.getTimestamp("createdAt")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new DashboardDTO(totalUsers, activeUsers, lockedUsers, roleDistribution, recentUsers);
    }
}
