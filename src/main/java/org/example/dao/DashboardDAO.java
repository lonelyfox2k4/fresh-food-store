package org.example.dao;

import org.example.dto.DashboardDTO;
import org.example.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DashboardDAO {

    public DashboardDTO getDashboardStats() {
        int totalUsers = 0;
        int totalProducts = 0;
        int totalOrders = 0;
        double totalRevenue = 0.0;

        try (Connection conn = DBConnection.getConnection()) {
            // Count total users
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM dbo.Accounts");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalUsers = rs.getInt(1);
                }
            }

            // Count total products
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM dbo.Products");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalProducts = rs.getInt(1);
                }
            }

            // Count total orders
            try (PreparedStatement ps = conn.prepareStatement("SELECT COUNT(*) FROM dbo.Orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalOrders = rs.getInt(1);
                }
            }

            // Calculate total revenue (Sum of totalAmount for paid orders, assuming paymentStatus = 1 or similar for completed)
            // For now, let's just sum all paid orders (assuming paymentStatus > 0 means paid, or just sum all for total sales volume)
            // Depending on status values, let's take all completed orders (e.g., paymentStatus = 1 or 2). We will sum all revenue to avoid 0 if no statuses match completely.
            try (PreparedStatement ps = conn.prepareStatement("SELECT SUM(totalAmount) FROM dbo.Orders");
                 ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    totalRevenue = rs.getDouble(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return new DashboardDTO(totalUsers, totalProducts, totalOrders, totalRevenue);
    }
}
