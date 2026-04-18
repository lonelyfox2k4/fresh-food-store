package org.example.controller;

import org.example.model.auth.Account;
import org.example.utils.EmailUtils;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/resend-otp")
public class ResendOtpController extends HttpServlet {

    // Nếu người dùng cố tình gõ URL /resend-otp trên trình duyệt (phương thức GET)
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Đuổi họ về trang đăng ký vì không có dữ liệu để gửi lại
        resp.sendRedirect("register");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        // Lấy thông tin người dùng đang đăng ký dở từ Session
        Account tempUser = (Account) session.getAttribute("tempUser");

        if (tempUser != null) {
            // Kiểm tra thời gian chờ 60s
            Long lastSentTime = (Long) session.getAttribute("lastOtpSentTime");
            long currentTime = System.currentTimeMillis();
            if (lastSentTime != null && (currentTime - lastSentTime) < 60000) {
                long remaining = 60 - (currentTime - lastSentTime) / 1000;
                req.setAttribute("errorMsg", "Vui lòng đợi " + remaining + " giây nữa để gửi lại mã.");
                req.getRequestDispatcher("/main/verify-register.jsp").forward(req, resp);
                return;
            }

            // 1. Tạo mã OTP mới ngẫu nhiên 6 số
            String newOtp = String.valueOf((int) (Math.random() * 899999) + 100000);

            // 2. Cập nhật mã mới vào Session (để lúc xác nhận khớp với mã này)
            session.setAttribute("registerOtp", newOtp);
            session.setAttribute("lastOtpSentTime", currentTime);

            try {
                // 3. Gửi lại Email với mã mới
                EmailUtils.sendEmail(tempUser.getEmail(), "Gửi lại mã OTP xác thực", "Mã OTP mới của bạn là: " + newOtp);

                // 4. Thông báo thành công và giữ người dùng ở lại trang nhập OTP
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