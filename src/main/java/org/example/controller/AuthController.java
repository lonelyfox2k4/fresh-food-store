package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.dao.CartDAO;
import org.example.model.auth.Account;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import org.example.utils.ValidationUtils;
import org.example.utils.EmailUtils;

@WebServlet(urlPatterns = {"/login", "/register", "/logout"})
public class AuthController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();
    private CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/login".equals(path)) {
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
        } else if ("/register".equals(path)) {
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
        } else if ("/logout".equals(path)) {
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            resp.sendRedirect("home");
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

        if (!ValidationUtils.isNonEmpty(email, password)) {
            req.setAttribute("errorMsg", "Email và mật khẩu không được bỏ trống!");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
            return;
        }

        if (!ValidationUtils.isValidEmail(email)) {
            req.setAttribute("errorMsg", "Định dạng Email không hợp lệ!");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
            return;
        }

        Account acc = dao.login(email, password);
        if (acc != null) {
            req.changeSessionId(); // Bảo mật: Fix Session Fixation
            req.getSession().setAttribute("user", acc);
            req.getSession().setAttribute("cartCount", cartDAO.countCartLines(acc.getAccountId()));
            if (acc.getRoleId() == 1) {
                resp.sendRedirect("admin/dashboard");
            } else if (acc.getRoleId() == 2) {
                resp.sendRedirect("manager/products");
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

        // 1. Kiểm tra các trường bắt buộc không được để trống
        if (!ValidationUtils.isNonEmpty(name, email, password)) {
            req.setAttribute("errorMsg", "Vui lòng nhập đầy đủ các trường bắt buộc!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra định dạng Email chuẩn
        if (!ValidationUtils.isValidEmail(email)) {
            req.setAttribute("errorMsg", "Email không đúng định dạng (VD: example@gmail.com)!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra số điện thoại (nếu nhập thì phải đúng 10 số)
        if (phone != null && !phone.trim().isEmpty() && !ValidationUtils.isValidPhone(phone)) {
            req.setAttribute("errorMsg", "Số điện thoại phải bao gồm đúng 10 chữ số!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 4. Kiểm tra Mật khẩu: Ít nhất 8 ký tự, có Hoa, Thường và Số
        if (!ValidationUtils.isValidPassword(password)) {
            req.setAttribute("errorMsg", "Mật khẩu phải từ 8 ký tự, bao gồm ít nhất 1 chữ hoa, 1 chữ thường và 1 số!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 5. Khôi phục luồng OTP (Bug 1)
        if (dao.getAccountByEmail(email) != null) {
            req.setAttribute("errorMsg", "Email này đã tồn tại trong hệ thống.");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        Account tempUser = new Account();
        tempUser.setEmail(email);
        tempUser.setPasswordHash(dao.encodePassword(password));
        tempUser.setFullName(name);
        tempUser.setPhone(phone);
        
        String otp = String.valueOf((int) (Math.random() * 899999) + 100000);
        HttpSession session = req.getSession();
        session.setAttribute("tempUser", tempUser);
        session.setAttribute("registerOtp", otp);
        session.setAttribute("lastOtpSentTime", System.currentTimeMillis());
        session.setAttribute("otpAttempts", 0);

        try {
            EmailUtils.sendEmail(email, "Xác nhận đăng ký tài khoản", "Mã xác thực OTP của bạn là: " + otp);
            resp.sendRedirect("verify-register");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("errorMsg", "Lỗi mạng: Không thể gửi email chứa mã OTP. Vui lòng thử lại sau.");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
        }
    }
}
