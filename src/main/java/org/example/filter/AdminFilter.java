package org.example.filter;

import org.example.model.auth.Account;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*"})
public class AdminFilter implements Filter {

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

        // Admin (roleId=1) → Cho phép vào /admin/*
        if (roleId == 1) {
            chain.doFilter(request, response);
            return;
        }

        // Nếu là Manager (2), Staff (3) hoặc các role khác → Không được vào khu vực Admin
        // Redirect về trang chủ hoặc trang riêng của họ
        if (roleId == 2) {
            resp.sendRedirect(req.getContextPath() + "/manager/products");
        } else if (roleId == 3) {
            resp.sendRedirect(req.getContextPath() + "/staff/voucher");
        } else {
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {}
}
