package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.dao.CartDAO;
import org.example.model.auth.Account;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

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

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            req.setAttribute("errorMsg", "Email và mật khẩu không được bỏ trống!");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
            return;
        }

        Account acc = dao.login(email, password);

        if (acc != null) {
            req.getSession().setAttribute("user", acc);
            req.getSession().setAttribute("cartCount", cartDAO.countCartLines(acc.getAccountId()));
            if (acc.getRoleId() == 1) {
                resp.sendRedirect("admin/dashboard");
            } else {
                resp.sendRedirect("home.jsp");
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

        if (name == null || name.trim().isEmpty() || email == null || email.trim().isEmpty() || password.length() < 6) {
            req.setAttribute("errorMsg", "Vui lòng nhập đầy đủ thông tin và mật khẩu từ 6 ký tự!");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
            return;
        }

        boolean success = dao.insertAccount(5, email, password, name, phone);

        if (success) {
            req.setAttribute("errorMsg", "Đăng ký thành công! Vui lòng đăng nhập.");
            req.getRequestDispatcher("/main/login.jsp").forward(req, resp);
        } else {
            req.setAttribute("errorMsg", "Đăng ký thất bại! Email có thể đã được sử dụng.");
            req.getRequestDispatcher("/main/register.jsp").forward(req, resp);
        }
    }
}
