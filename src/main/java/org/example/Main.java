package org.example;

import org.example.utils.DBConnection;

import java.sql.Connection;

public class Main {
    public static void main(String[] args) {
        Connection conn = DBConnection.getConnection();

        if (conn != null) {
            System.out.println("✅ Kết nối DB thành công!");
        } else {
            System.out.println("❌ Kết nối DB thất bại!");
        }
    }
}