package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/admin/users", "/admin/update-status", "/admin/assign"})
public class AdminController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/users".equals(path)) {
            // Lấy dữ liệu từ các ô nhập/chọn trên giao diện
            String txtSearch = req.getParameter("search");
            String roleId = req.getParameter("roleId");
            String status = req.getParameter("status");
            String sortBy = req.getParameter("sortBy");
            String sortDir = req.getParameter("sortDir");

            // Pagination params
            int page = 1;
            int limit = 10; // Cố định 10 users / trang
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    page = Integer.parseInt(pageParam);
                    if (page < 1) page = 1;
                } catch (NumberFormatException ignored) {}
            }
            int offset = (page - 1) * limit;

            // Lấy tổng số user theo filter
            int totalRecords = dao.countUsers(txtSearch, roleId, status);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            // Gọi hàm tìm kiếm nâng cao với offset, limit
            List<Account> list = dao.searchUsers(txtSearch, roleId, status, sortBy, sortDir, offset, limit);

            req.setAttribute("users", list);
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("totalRecords", totalRecords);
            
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
            // Đảo ngược trạng thái hiện tại (Ban/Unban)
            dao.updateStatus(id, !status);
            resp.sendRedirect("users");

        } else if ("/admin/assign".equals(path)) {
            // Logic "Create" trong CRUD: Admin cấp tài khoản mới
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String email = req.getParameter("email");
            String name = req.getParameter("name");
            String phone = req.getParameter("phone");

            dao.insertAccount(roleId, email, "123456", name, phone);
            resp.sendRedirect("users");
        }
    }
}