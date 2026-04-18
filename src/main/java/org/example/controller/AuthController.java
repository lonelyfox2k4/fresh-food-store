package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import org.example.utils.EmailUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/login".equals(path)) {
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
        } else if ("/logout".equals(path)) {
            req.getSession().invalidate();
            resp.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(req, resp);
        } else if ("/register".equals(path)) {
            handleRegister(req, resp);
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Email và mật khẩu không được bỏ trống!");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
            return;
        }

        Account acc = dao.login(email, password);

        if (acc != null) {
            req.getSession().setAttribute("user", acc);
            // Chỉ RoleId 1 (Admin) mới vào được dashboard
            if (acc.getRoleId() == 1) {
                resp.sendRedirect("admin/dashboard");
            } else {
                resp.sendRedirect("home");
            }
        } else {
            req.setAttribute("errorMsg", "Tài khoản hoặc mật khẩu không chính xác!");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");

        // 1. Check dữ liệu đầu vào
        if (name == null || name.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.length() < 6) {
            req.setAttribute("errorMsg", "Thông tin không hợp lệ!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 2. Check trùng email trước
        if (dao.getAccountByEmail(email) != null) {
            req.setAttribute("errorMsg", "Email này đã được sử dụng!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 3. TẠO OTP VÀ LƯU THÔNG TIN ĐĂNG KÝ VÀO SESSION (Chưa lưu DB)
        String otp = String.valueOf((int) (Math.random() * 899999) + 100000);
        HttpSession session = req.getSession();
        session.setAttribute("registerOtp", otp);
        session.setAttribute("tempUser", new Account(0, 5, email, password, name, phone, true, false, null));
        session.setAttribute("lastOtpSentTime", System.currentTimeMillis());

        // 4. GỬI MAIL OTP
        try {
            EmailUtils.sendEmail(email, "Mã xác thực đăng ký", "Mã OTP của bạn là: " + otp);
            // Chuyển hướng sang trang nhập OTP (mày cần tạo thêm trang này hoặc dùng chung trang cũ)
            req.setAttribute("msg", "Mã OTP đã được gửi về Email: " + email);
            req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
        } catch (Exception e) {
            req.setAttribute("errorMsg", "Lỗi gửi mail: " + e.getMessage());
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
        }
    }
}