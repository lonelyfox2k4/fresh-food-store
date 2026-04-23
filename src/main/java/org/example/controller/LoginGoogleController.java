package org.example.controller;

import com.google.gson.JsonObject;
import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import org.example.utils.GoogleUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String code = req.getParameter("code");

        // 1. Kiểm tra code từ Google
        if (code == null || code.isEmpty()) {
            resp.sendRedirect("login");
            return; // Dừng lại ở đây nếu không có code
        }

        // 2. Lấy thông tin user từ Google
        String accessToken = GoogleUtils.getToken(code);
        JsonObject googleUser = GoogleUtils.getUserInfo(accessToken);

        String email = googleUser.get("email").getAsString();
        String name = googleUser.get("name").getAsString();
        String googleId = googleUser.get("id").getAsString();

        AccountDAO dao = new AccountDAO();
        Account acc = dao.getAccountByEmail(email);

        // 3. Xử lý logic Account
        if (acc == null) {
            // Nếu chưa có tài khoản, tạo mới (Role 5 là Customer)
            dao.insertAccount(5, email, "google_login_no_pass", name, "");
            dao.verifyEmail(email); // Tự động xác thực vì Google đã xác thực rồi
            acc = dao.getAccountByEmail(email);
        }

        // 4. LƯU LIÊN KẾT GOOGLE (Để bảng AccountGoogleLinks nảy số)
        if (acc != null) {
            // Tự động xác thực email nếu login qua Google (Trường hợp tài khoản đã tồn tại từ trước nhưng chưa verify)
            if (!acc.isEmailVerified()) {
                dao.verifyEmail(email);
                acc.setEmailVerified(true);
            }

            // KIỂM TRA TRẠNG THÁI TÀI KHOẢN (BAN)
            if (!acc.isStatus()) {
                req.setAttribute("errorMsg", "Tài khoản của bạn đã bị khóa! Vui lòng liên hệ quản trị viên.");
                req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
                return;
            }

            dao.linkGoogleAccount(acc.getAccountId(), googleId, email);

            // 5. Thiết lập session và chuyển trang
            req.getSession().setAttribute("user", acc);
            
            String contextPath = req.getContextPath();
            int roleId = acc.getRoleId();
            
            switch (roleId) {
                case 1: // Admin
                    resp.sendRedirect(contextPath + "/admin/dashboard");
                    break;
                case 2: // Manager
                    resp.sendRedirect(contextPath + "/manager/products");
                    break;
                case 3: // Staff
                    resp.sendRedirect(contextPath + "/staff/orders");
                    break;
                case 4: // Shipper
                    resp.sendRedirect(contextPath + "/shipper/orders");
                    break;
                default: // Customer/Others
                    resp.sendRedirect(contextPath + "/home");
                    break;
            }
        } else {
            // Trường hợp hy hữu không tạo được acc
            resp.sendRedirect("login");
        }
    }
}
