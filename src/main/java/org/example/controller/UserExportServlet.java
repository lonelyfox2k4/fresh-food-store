package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/admin/export-users")
public class UserExportServlet extends HttpServlet {

    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Fetch all accounts from database
        List<Account> accounts = accountDAO.getAllAccounts();

        // 2. Set response headers for CSV download
        String fileName = "danh_sach_nguoi_dung_" + new SimpleDateFormat("yyyyMMdd_HHmmss").format(new java.util.Date());
        
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ".csv");

        // 3. Write CSV content
        try (PrintWriter writer = response.getWriter()) {
            // Add BOM for Excel UTF-8 support
            writer.write('\ufeff');

            // Header row
            writer.println("ID,Họ tên,Email,Số điện thoại,Vai trò,Trạng thái,Ngày tham gia");

            // Data rows
            for (Account a : accounts) {
                StringBuilder sb = new StringBuilder();
                sb.append(a.getAccountId()).append(",");
                sb.append("\"").append(a.getFullName().replace("\"", "\"\"")).append("\",");
                sb.append(a.getEmail()).append(",");
                sb.append(a.getPhone() != null ? a.getPhone() : "").append(",");
                sb.append(getRoleName(a.getRoleId())).append(",");
                sb.append(a.isStatus() ? "Hoạt động" : "Bị khóa").append(",");
                sb.append(new SimpleDateFormat("dd/MM/yyyy HH:mm").format(a.getCreatedAt()));
                
                writer.println(sb.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getRoleName(int roleId) {
        switch (roleId) {
            case 1: return "Admin";
            case 2: return "Manager";
            case 3: return "Staff";
            case 4: return "Shipper";
            case 5: return "Customer";
            default: return "Unknown";
        }
    }
}
