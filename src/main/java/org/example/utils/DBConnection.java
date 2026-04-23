package org.example.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class DBConnection {
    private static HikariDataSource dataSource;

    static {
        try {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl("jdbc:sqlserver://localhost:1433;databaseName=fresh_food_store;encrypt=false");
            config.setUsername("sa");
            config.setPassword("123");
            config.setDriverClassName("com.microsoft.sqlserver.jdbc.SQLServerDriver");

            // Cấu hình tối ưu cho Connection Pool
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(30000);
            config.setConnectionTimeout(20000);
            config.setMaxLifetime(1800000);

            dataSource = new HikariDataSource(config);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi khởi tạo HikariCP: " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        try {
            return dataSource.getConnection();
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("Kết nối Database qua HikariCP thành công!");
            try {
                conn.close();
            } catch (Exception e) {
            }
        } else {
            System.out.println("Kết nối Database thất bại.");
        }
    }
}