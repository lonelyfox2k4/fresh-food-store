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
            acc = dao.getAccountByEmail(email);
        }

        // 4. LƯU LIÊN KẾT GOOGLE (Để bảng AccountGoogleLinks nảy số)
        if (acc != null) {
            dao.linkGoogleAccount(acc.getAccountId(), googleId, email);

            // 5. Thiết lập session và chuyển trang
            req.getSession().setAttribute("user", acc);
            // Chỉ RoleId 1 (Admin) mới vào được dashboard
            if (acc.getRoleId() == 1) {
                resp.sendRedirect("admin/dashboard");
            } else {
                resp.sendRedirect("home");
            }
        } else {
            // Trường hợp hy hữu không tạo được acc
            resp.sendRedirect("login");
        }
    }
}