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

@WebServlet(urlPatterns = {"/profile", "/profile/update"})
public class ProfileController extends HttpServlet {
    private final AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        Account profile = accountDAO.getAccountById(currentUser.getAccountId());
        if (profile == null) {
            profile = currentUser;
        } else {
            req.getSession().setAttribute("user", profile);
        }

        req.setAttribute("profile", profile);
        moveFlashToRequest(req, "successMsg");
        moveFlashToRequest(req, "openEditMode");
        moveFlashToRequest(req, "profileFullNameInput");
        moveFlashToRequest(req, "profilePhoneInput");
        moveFlashToRequest(req, "fullNameError");
        moveFlashToRequest(req, "phoneError");
        moveFlashToRequest(req, "profileGeneralError");

        if ("1".equals(req.getParameter("edit"))) {
            req.setAttribute("openEditMode", true);
        }

        req.getRequestDispatcher("/main/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        if ("/profile/update".equals(path)) {
            handleUpdateProfile(req, resp, currentUser);
        } else {
            resp.sendRedirect(req.getContextPath() + "/profile");
        }
    }

    private void handleUpdateProfile(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        String fullNameRaw = req.getParameter("fullName");
        String phoneRaw = req.getParameter("phone");

        String fullName = fullNameRaw == null ? "" : fullNameRaw.trim();
        String phone = phoneRaw == null ? null : phoneRaw.trim();
        if (phone != null && phone.isEmpty()) {
            phone = null;
        }

        if (fullName.isEmpty()) {
            setFlash(req, "fullNameError", "Họ tên không được để trống.");
            setFlash(req, "profileFullNameInput", fullNameRaw);
            setFlash(req, "profilePhoneInput", phoneRaw);
            setFlash(req, "openEditMode", true);
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        if (phone != null && phone.length() > 30) {
            setFlash(req, "phoneError", "Số điện thoại không hợp lệ.");
            setFlash(req, "profileFullNameInput", fullNameRaw);
            setFlash(req, "profilePhoneInput", phoneRaw);
            setFlash(req, "openEditMode", true);
            resp.sendRedirect(req.getContextPath() + "/profile");
            return;
        }

        boolean updated = accountDAO.updateProfile(currentUser.getAccountId(), fullName, phone);
        if (updated) {
            Account refreshed = accountDAO.getAccountById(currentUser.getAccountId());
            if (refreshed != null) {
                req.getSession().setAttribute("user", refreshed);
            }
            setFlash(req, "successMsg", "Cập nhật thông tin thành công.");
        } else {
            setFlash(req, "profileGeneralError", "Cập nhật thất bại. Vui lòng thử lại.");
            setFlash(req, "profileFullNameInput", fullNameRaw);
            setFlash(req, "profilePhoneInput", phoneRaw);
            setFlash(req, "openEditMode", true);
        }
        resp.sendRedirect(req.getContextPath() + "/profile");
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

}
