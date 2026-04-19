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
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        Account user = (session != null) ? (Account) session.getAttribute("user") : null;

        if (user != null && user.getRoleId() == 1) {
            // Hợp lệ - cho qua
            chain.doFilter(request, response);
        } else {
            // Không phải admin hoặc chưa đăng nhập -> văng về home
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {
    }
}
