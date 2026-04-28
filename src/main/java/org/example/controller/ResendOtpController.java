package org.example.controller;

import org.example.model.auth.Account;
import org.example.utils.EmailUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/resend-otp")
public class ResendOtpController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.sendRedirect("register");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        Account tempUser = (Account) session.getAttribute("tempUser");

        if (tempUser != null) {
            Long lastSentTime = (Long) session.getAttribute("lastOtpSentTime");
            long currentTime = System.currentTimeMillis();
            if (lastSentTime != null && (currentTime - lastSentTime) < 60000) {
                long remaining = 60 - (currentTime - lastSentTime) / 1000;
                req.setAttribute("errorMsg", "Vui lòng đợi " + remaining + " giây nữa để gửi lại mã.");
                req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
                return;
            }

            String newOtp = String.valueOf((int) (Math.random() * 899999) + 100000);

            session.setAttribute("registerOtp", newOtp);
            session.setAttribute("lastOtpSentTime", currentTime);

            try {
                EmailUtils.sendEmail(tempUser.getEmail(), "Gửi lại mã OTP xác thực", "Mã OTP mới của bạn là: " + newOtp);

                req.setAttribute("msg", "Mã OTP mới đã được gửi lại vào Email của bạn!");
            } catch (Exception e) {
                // Nếu lỗi gửi mail (do mạng hoặc tài khoản mail bị block)
                req.setAttribute("errorMsg", "Lỗi gửi mail: " + e.getMessage());
            }
            req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
        } else {
            // Nếu session hết hạn (tempUser bị null), bắt đăng ký lại từ đầu
            resp.sendRedirect("register");
        }
    }
}