package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import org.example.utils.ValidationUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

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
        String roleIdStr = req.getParameter("roleId");
        String statusStr = req.getParameter("status");

        // 1. Kiểm tra không để trống tên
        if (name == null || name.trim().isEmpty()) {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Họ tên không được để trống", "UTF-8"));
            return;
        }

        // 2. Kiểm tra số điện thoại (nếu có nhập)
        if (phone != null && !phone.trim().isEmpty() && !ValidationUtils.isValidPhone(phone)) {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Số điện thoại không đúng định dạng (10 số)", "UTF-8"));
            return;
        }

        int roleId = Integer.parseInt(roleIdStr);
        boolean status = Boolean.parseBoolean(statusStr);

        // Gọi hàm update trong DAO
        boolean success = dao.updateAccountAdmin(id, name, phone, roleId, status);

        if (success) {
            resp.sendRedirect("users?msg=" + URLEncoder.encode("Cập nhật thành công", "UTF-8"));
        } else {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Lỗi cập nhật dữ liệu", "UTF-8"));
        }
    }
}