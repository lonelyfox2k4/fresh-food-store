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

        // Allow Admin (1) and Manager (2)
        if (user != null && (user.getRoleId() == 1 || user.getRoleId() == 2)) {
            chain.doFilter(request, response);
        } else {
            // Unauthorized or not logged in -> redirect to home
            resp.sendRedirect(req.getContextPath() + "/home");
        }
    }

    @Override
    public void destroy() {
    }
}
