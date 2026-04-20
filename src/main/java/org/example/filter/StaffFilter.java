package org.example.filter;

import org.example.model.auth.Account;

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

        // 1. Chưa đăng nhập → về trang login
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra Role
        int roleId = user.getRoleId();

        // Admin (1), Manager (2), và Staff (3) → Được phép vào /staff/*
        if (roleId == 1 || roleId == 2 || roleId == 3) {
            chain.doFilter(request, response);
            return;
        }

        // Các role khác (Shipper, Customer) → về home
        resp.sendRedirect(req.getContextPath() + "/home");
    }

    @Override
    public void destroy() {}
}
