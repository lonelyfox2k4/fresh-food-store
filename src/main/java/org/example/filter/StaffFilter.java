package org.example.filter;

import org.example.model.auth.Account;
import org.example.utils.RoleConstant;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/staff/*"})
public class StaffFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        org.example.dao.AccountDAO dao = new org.example.dao.AccountDAO();

        // 1. Chưa đăng nhập → về trang login
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra trạng thái tài khoản
        Account currentAcc = dao.getAccountById(user.getAccountId());
        if (currentAcc == null || !currentAcc.isStatus()) {
            if (session != null) {
                try {
                    session.invalidate();
                } catch (IllegalStateException ignored) {}
            }
            resp.sendRedirect(req.getContextPath() + "/login?errorMsg=banned");
            return;
        }

        // 2. Kiểm tra Role
        int roleId = user.getRoleId();

        // Admin, Manager, và Staff → Được phép vào /staff/*
        if (roleId == RoleConstant.ADMIN || roleId == RoleConstant.MANAGER || roleId == RoleConstant.STAFF) {
            chain.doFilter(request, response);
            return;
        }

        // Các role khác (Shipper, Customer) → về home
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    public void destroy() {}
}
