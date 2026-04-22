package org.example.filter;

import org.example.model.auth.Account;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Filter to protect /manager/* routes.
 * Allows access to Admin (roleId 1) and Manager (roleId 2).
 */
@WebFilter(urlPatterns = {"/manager/*"})
public class ManagerFilter implements Filter {
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        org.example.dao.AccountDAO dao = new org.example.dao.AccountDAO();

        // 1. Kiểm tra đăng nhập
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 2. Kiểm tra trạng thái tài khoản
        Account currentAcc = dao.getAccountById(user.getAccountId());
        if (currentAcc == null || !currentAcc.isStatus()) {
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/login?errorMsg=banned");
            return;
        }

        // 3. Cho phép Admin (1) và Manager (2)
        if (user.getRoleId() == 1 || user.getRoleId() == 2) {
            chain.doFilter(request, response);
        } else {
            // Không có quyền -> về trang chủ
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {
    }
}
