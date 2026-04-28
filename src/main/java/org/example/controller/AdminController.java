package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import org.example.utils.EmailUtils;
import org.example.utils.ValidationUtils;

@WebServlet(urlPatterns = {"/admin/users", "/admin/update-status", "/admin/assign"})
public class AdminController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/users".equals(path)) {
            String txtSearch = req.getParameter("search");
            String roleId = req.getParameter("roleId");
            String status = req.getParameter("status");
            String sortBy = req.getParameter("sortBy");
            String sortDir = req.getParameter("sortDir");

            int page = 1;
            int limit = 10;
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException ignored) {}
            }
            int offset = (page - 1) * limit;

            int totalRecords = dao.countUsers(txtSearch, roleId, status);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            List<Account> list = dao.searchUsers(txtSearch, roleId, status, sortBy, sortDir, offset, limit);

            req.setAttribute("users", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);
            req.setAttribute("userStats", dao.getUserSummaryStats());
            
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } else if ("/admin/assign".equals(path)) {
            req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        if ("/admin/update-status".equals(path)) {
            long id = Long.parseLong(req.getParameter("id"));
            boolean status = Boolean.parseBoolean(req.getParameter("status"));
            
            Account target = dao.getAccountById(id);
            if (target != null && target.getRoleId() == 1) {
                resp.sendRedirect("users?error=" + java.net.URLEncoder.encode("Không thể khóa tài khoản Quản trị viên!", "UTF-8"));
                return;
            }

            dao.updateStatus(id, !status);
            resp.sendRedirect("users?msg=" + java.net.URLEncoder.encode("Cập nhật trạng thái thành công", "UTF-8"));

        } else if ("/admin/assign".equals(path)) {
            String roleIdStr = req.getParameter("roleId");
            String email = req.getParameter("email");
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");

            if (!ValidationUtils.isNonEmpty(roleIdStr, email, name)) {
                req.setAttribute("error", "Vui lòng nhập đầy đủ Họ tên, Email và chọn Vai trò!");
                req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
                return;
            }

            if (!ValidationUtils.isValidEmail(email)) {
                req.setAttribute("error", "Địa chỉ Email không đúng định dạng!");
                req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
                return;
            }

            if (phone != null && !phone.trim().isEmpty() && !ValidationUtils.isValidPhone(phone)) {
                req.setAttribute("error", "Số điện thoại phải bắt đầu bằng số 0 và bao gồm đúng 10 chữ số!");
                req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
                return;
            }

            int roleId = Integer.parseInt(roleIdStr);
            String defaultPass = "FreshFood123";
            boolean success = dao.insertAccount(roleId, email, defaultPass, name, phone);
            
            if (success) {
                dao.verifyEmail(email);
                
                String subject = "Thông báo: Tài khoản của bạn tại Fresh Food Store đã được cấp";
                String message = "Chào " + name + ",\n\n"
                        + "Admin đã cấp tài khoản cho bạn trên hệ thống Fresh Food Store.\n"
                        + "Dưới đây là thông tin đăng nhập của bạn:\n"
                        + "- Email: " + email + "\n"
                        + "- Mật khẩu mặc định: " + defaultPass + "\n\n"
                        + "Vui lòng đăng nhập và đổi mật khẩu ngay để bảo mật tài khoản.\n"
                        + "Trân trọng,\nBan quản trị Fresh Food Store.";
                
                try {
                    EmailUtils.sendEmail(email, subject, message);
                } catch (Exception e) {
                    e.printStackTrace();
                }
                
                resp.sendRedirect("users?msg=Assign success");
            } else {
                req.setAttribute("error", "Lỗi: Email này đã được sử dụng trong hệ thống.");
                req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
            }
        }
    }
}