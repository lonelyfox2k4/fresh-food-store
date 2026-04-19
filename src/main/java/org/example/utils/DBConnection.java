package org.example.utils;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    public static Connection getConnection() {
        try {
            String url = "jdbc:sqlserver://localhost:1433;databaseName=fresh_food_store;encrypt=false";
            String user = "sa";
            String password = "123"; // User's local DB password

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            return DriverManager.getConnection(url, user, password);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static void main(String[] args) {
        Connection conn = getConnection();
        if (conn != null) {
            System.out.println("Kết nối Database thành công!");
            try {
                conn.close();
            } catch (Exception e) {
            }
        } else {
            System.out.println("Kết nối Database thất bại.");
        }
    }
}