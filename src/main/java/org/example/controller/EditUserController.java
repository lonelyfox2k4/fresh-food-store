package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/edit")
public class EditUserController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    // 1. Khi bấm nút "Sửa" ở bảng: Load dữ liệu cũ lên form
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long id = Long.parseLong(req.getParameter("id"));
        Account acc = dao.getAccountById(id); // Mày cần hàm này trong DAO
        req.setAttribute("user", acc);
        req.getRequestDispatcher("/admin/edit.jsp").forward(req, resp);
    }

    // 2. Khi bấm nút "Lưu" ở trang edit: Update vào DB
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        long id = Long.parseLong(req.getParameter("id"));
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        int roleId = Integer.parseInt(req.getParameter("roleId"));
        boolean status = Boolean.parseBoolean(req.getParameter("status"));

        // Gọi hàm update trong DAO
        boolean success = dao.updateAccountAdmin(id, name, phone, roleId, status);

        if (success) {
            resp.sendRedirect("users?msg=Update success");
        } else {
            resp.sendRedirect("users?error=Update failed");
        }
    }
}