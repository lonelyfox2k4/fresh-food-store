package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.utils.EmailUtils;
import org.example.utils.ValidationUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.security.SecureRandom;

@WebServlet("/forgot-password")
public class ForgotPasswordController extends HttpServlet {

    private String generateComplexPassword(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!@#$%^&*";
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            int index = random.nextInt(chars.length());
            sb.append(chars.charAt(index));
        }
        return sb.toString();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession();
        session.removeAttribute("resetEmail");
        req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        AccountDAO dao = new AccountDAO();
        HttpSession session = req.getSession();

        if ("send-otp".equals(action)) {
            String email = req.getParameter("email");

            if (!ValidationUtils.isValidEmail(email)) {
                req.setAttribute("error", "Email không đúng định dạng!");
                req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
                return;
            }

            if (dao.getAccountByEmail(email) != null) {
                // Kiểm tra thời gian chờ 60s
                Long lastSentTime = (Long) session.getAttribute("lastOtpSentTime");
                long currentTime = System.currentTimeMillis();
                if (lastSentTime != null && (currentTime - lastSentTime) < 60000) {
                    long remaining = 60 - (currentTime - lastSentTime) / 1000;
                    req.setAttribute("error", "Vui lòng đợi " + remaining + " giây nữa để yêu cầu mã mới.");
                    req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
                    return;
                }

                String otp = String.valueOf((int) (Math.random() * 899999) + 100000);
                session.setAttribute("otp", otp);
                session.setAttribute("resetEmail", email);
                session.setAttribute("lastOtpSentTime", currentTime);

                try {
                    EmailUtils.sendEmail(email, "Mã xác thực OTP", "Mã OTP của bạn là: " + otp);
                    req.setAttribute("msg", "Mã OTP đã được gửi về Email: " + email);
                    req.setAttribute("step", "verify-otp");
                } catch (Exception e) {
                    req.setAttribute("error", "Lỗi gửi mail: " + e.getMessage());
                }
            } else {
                req.setAttribute("error", "Email này không tồn tại!");
            }
        }
        else if ("verify-otp".equals(action)) {
            String userOtp = req.getParameter("otp");
            String systemOtp = (String) session.getAttribute("otp");
            String email = (String) session.getAttribute("resetEmail");
            Long lastSentTime = (Long) session.getAttribute("lastOtpSentTime");
            long currentTime = System.currentTimeMillis();

            if (systemOtp == null) {
                req.setAttribute("error", "Mã xác thực không tồn tại hoặc đã hết hạn!");
                req.setAttribute("step", "send-otp");
                req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
                return;
            }

            if (lastSentTime != null && (currentTime - lastSentTime) > 120000) {
                session.removeAttribute("otp");
                req.setAttribute("error", "Mã OTP đã hết hạn (2 phút). Vui lòng yêu cầu mã mới!");
                req.setAttribute("step", "send-otp");
                req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
                return;
            }

            if (userOtp != null && userOtp.equals(systemOtp)) {
                String newPass = generateComplexPassword(10);

                String hashedPassword = dao.encodePassword(newPass);

                boolean isUpdated = dao.resetPassword(email, hashedPassword);

                if (isUpdated) {
                    try {
                        EmailUtils.sendEmail(email, "Mật khẩu mới của bạn",
                                "Xác thực thành công. Mật khẩu mới để đăng nhập là: " + newPass);

                        req.setAttribute("msg", "Thành công! Mật khẩu mới đã được gửi vào Email.");
                        session.removeAttribute("otp");
                        session.removeAttribute("resetEmail");
                    } catch (Exception e) {
                        req.setAttribute("error", "Lỗi gửi mail: " + e.getMessage());
                    }
                } else {
                    req.setAttribute("error", "Lỗi: Không thể cập nhật Database.");
                }
            } else {
                req.setAttribute("error", "Mã OTP không chính xác!");
                req.setAttribute("step", "verify-otp");
            }
        }
        req.getRequestDispatcher("/main/forgot-password.jsp").forward(req, resp);
    }
}