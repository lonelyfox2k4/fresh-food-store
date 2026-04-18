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

@WebServlet(urlPatterns = {"/change-password"})
public class ChangePasswordController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        moveFlashToRequest(req, "currentPasswordError");
        moveFlashToRequest(req, "newPasswordError");
        moveFlashToRequest(req, "confirmPasswordError");
        moveFlashToRequest(req, "passwordGeneralError");
        moveFlashToRequest(req, "passwordChanged");

        req.getRequestDispatcher("/main/change-password.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String currentPassword = trim(req.getParameter("currentPassword"));
        String newPassword = trim(req.getParameter("newPassword"));
        String confirmPassword = trim(req.getParameter("confirmPassword"));

        boolean hasError = false;
        if (currentPassword.isEmpty()) {
            setFlash(req, "currentPasswordError", "Mật khẩu hiện tại không được để trống.");
            hasError = true;
        }
        if (newPassword.isEmpty()) {
            setFlash(req, "newPasswordError", "Mật khẩu mới không được để trống.");
            hasError = true;
        }
        if (confirmPassword.isEmpty()) {
            setFlash(req, "confirmPasswordError", "Xác nhận mật khẩu không được để trống.");
            hasError = true;
        }

        if (hasError) {
            resp.sendRedirect(req.getContextPath() + "/change-password");
            return;
        }

        if (newPassword.length() < 6) {
            setFlash(req, "newPasswordError", "Mật khẩu mới phải từ 6 ký tự.");
            resp.sendRedirect(req.getContextPath() + "/change-password");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            setFlash(req, "confirmPasswordError", "Xác nhận mật khẩu không khớp.");
            resp.sendRedirect(req.getContextPath() + "/change-password");
            return;
        }

        Account validCurrentUser = accountDAO.login(currentUser.getEmail(), currentPassword);
        if (validCurrentUser == null) {
            setFlash(req, "currentPasswordError", "Mật khẩu hiện tại không đúng.");
            resp.sendRedirect(req.getContextPath() + "/change-password");
            return;
        }

        boolean changed = accountDAO.updatePassword(currentUser.getAccountId(), newPassword);
        if (changed) {
            setFlash(req, "passwordChanged", true);
            resp.sendRedirect(req.getContextPath() + "/change-password");
            return;
        }

        setFlash(req, "passwordGeneralError", "Đổi mật khẩu thất bại. Vui lòng thử lại.");
        resp.sendRedirect(req.getContextPath() + "/change-password");
    }

    private Account getSessionUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("user");
        if (!(user instanceof Account)) {
            return null;
        }
        return (Account) user;
    }

    private void setFlash(HttpServletRequest req, String key, Object value) {
        req.getSession().setAttribute(key, value);
    }

    private void moveFlashToRequest(HttpServletRequest req, String key) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return;
        }
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
