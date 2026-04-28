package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import org.example.utils.ValidationUtils;
import org.example.utils.RoleConstant;
import org.example.utils.EmailUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/admin/edit")
public class EditUserController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        long id = Long.parseLong(req.getParameter("id"));
        Account acc = dao.getAccountById(id);
        req.setAttribute("user", acc);
        req.getRequestDispatcher("/admin/edit.jsp").forward(req, resp);
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        long id = Long.parseLong(req.getParameter("id"));
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String roleIdStr = req.getParameter("roleId");
        String statusStr = req.getParameter("status");
        
        HttpSession session = req.getSession(false);
        Account currentUser = (session != null) ? (Account) session.getAttribute("user") : null;

        if (name == null || name.trim().isEmpty()) {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Họ tên không được để trống", "UTF-8"));
            return;
        }

        if (phone != null && !phone.trim().isEmpty() && !ValidationUtils.isValidPhone(phone)) {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Số điện thoại không đúng định dạng (10 số)", "UTF-8"));
            return;
        }

        int roleId = Integer.parseInt(roleIdStr);
        boolean status = Boolean.parseBoolean(statusStr);

        Account target = dao.getAccountById(id);
        if (target != null && target.getRoleId() == RoleConstant.ADMIN) {
            roleId = RoleConstant.ADMIN;      // Luôn là Admin
            status = true;
        }

        if (currentUser != null && currentUser.getAccountId() == id) {
            if (!status || roleId != currentUser.getRoleId()) {
                resp.sendRedirect("users?error=" + URLEncoder.encode("Bạn không thể tự khóa tài khoản hoặc tự thay đổi quyền của chính mình!", "UTF-8"));
                return;
            }
        }

        boolean success = dao.updateAccountAdmin(id, name, phone, roleId, status);

        if (success) {
            if (target != null && target.getRoleId() != roleId) {
                String roleName = getRoleName(roleId);
                String subject = "[Fresh Food Store] Thông báo thay đổi vai trò tài khoản";
                String content = "Chào " + target.getFullName() + ",\n\n"
                        + "Chúng tôi xin thông báo vai trò của bạn tại Fresh Food Store đã được thay đổi thành: " + roleName + ".\n"
                        + "Vui lòng đăng nhập lại để trải nghiệm các tính năng dành riêng cho bạn.\n\n"
                        + "Chúc bạn một ngày làm việc hiệu quả!\nTrân trọng,\nBan quản trị Fresh Food Store.";
                try {
                    EmailUtils.sendEmail(target.getEmail(), subject, content);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            resp.sendRedirect("users?msg=" + URLEncoder.encode("Cập nhật thành công", "UTF-8"));
        } else {
            resp.sendRedirect("users?error=" + URLEncoder.encode("Lỗi cập nhật dữ liệu", "UTF-8"));
        }
    }

    private String getRoleName(int roleId) {
        switch (roleId) {
            case RoleConstant.ADMIN: return "Quản trị viên (Admin)";
            case RoleConstant.MANAGER: return "Quản lý (Manager)";
            case RoleConstant.STAFF: return "Nhân viên (Staff)";
            case RoleConstant.SHIPPER: return "Giao hàng (Shipper)";
            case RoleConstant.CUSTOMER: return "Khách hàng (Customer)";
            default: return "Khác";
        }
    }
}