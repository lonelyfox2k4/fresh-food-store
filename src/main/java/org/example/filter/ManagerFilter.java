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
https://github.com/lonelyfox2k4/fresh-food-store/pull/20/conflict?name=src%252Fmain%252Fwebapp%252Fmanager%252Fproducts.jsp&ancestor_oid=e36c97f19fa0feda2d34335d474690f1d5e67c06&base_oid=530a20869c17743d65165383024e5d69b90755eb&head_oid=79f94b8956f93041c324ea653cc93732d1642b9c
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
