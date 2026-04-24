package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/verify-register")
public class VerifyRegisterController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Nếu khách cố tình vào link này bằng cách gõ URL thì đuổi về trang đăng ký
        req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. Fix lỗi tiếng Việt cho thông báo
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        String userOtp = req.getParameter("otp");
        String systemOtp = (String) session.getAttribute("registerOtp");
        Account tempUser = (Account) session.getAttribute("tempUser");
        Integer attempts = (Integer) session.getAttribute("otpAttempts");
        if (attempts == null) attempts = 0;

        if (systemOtp == null || tempUser == null) {
            req.setAttribute("errorMsg", "Phiên xác thực đã hết hạn hoặc không tồn tại!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 3. Kiểm tra thời hạn 2 phút (120,000 ms)
        Long lastSentTime = (Long) session.getAttribute("lastOtpSentTime");
        long currentTime = System.currentTimeMillis();
        if (lastSentTime != null && (currentTime - lastSentTime) > 120000) {
            session.removeAttribute("registerOtp");
            session.removeAttribute("tempUser");
            session.removeAttribute("otpAttempts");
            req.setAttribute("errorMsg", "Mã xác thực đã hết hạn (2 phút). Vui lòng đăng ký lại!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        // 2. Kiểm tra mã OTP
        if (userOtp != null && userOtp.equals(systemOtp)) {

            AccountDAO dao = new AccountDAO();

            // 3. OTP ĐÚNG -> LƯU VÀO DATABASE
            boolean success = dao.insertAccount(
                    5, // Role Customer
                    tempUser.getEmail(),
                    tempUser.getPasswordHash(),
                    tempUser.getFullName(),
                    tempUser.getPhone()
            );

            if (success) {
                dao.verifyEmail(tempUser.getEmail());

                // Xóa dữ liệu tạm trong session
                session.removeAttribute("registerOtp");
                session.removeAttribute("tempUser");
                session.removeAttribute("otpAttempts");

                req.setAttribute("successMsg", "Xác thực thành công! Mời bạn đăng nhập.");
                req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
            } else {
                req.setAttribute("errorMsg", "Lỗi hệ thống: Không thể tạo tài khoản.");
                req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
            }
        } else {
            // OTP sai
            attempts++;
            if (attempts >= 5) {
                session.removeAttribute("registerOtp");
                session.removeAttribute("tempUser");
                session.removeAttribute("otpAttempts");
                req.setAttribute("errorMsg", "Bạn đã nhập sai mã OTP quá 5 lần. Vui lòng đăng ký lại!");
                req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            } else {
                session.setAttribute("otpAttempts", attempts);
                req.setAttribute("errorMsg", "Mã OTP không chính xác! Bạn còn " + (5 - attempts) + " lần thử.");
                req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
            }
        }
    }
}