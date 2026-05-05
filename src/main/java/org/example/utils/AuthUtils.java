package org.example.utils;

import org.example.model.auth.Account;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AuthUtils {

    /**
     * Handles all tasks after a successful login: sets session attributes and redirects.
     */
    public static void handleLoginSuccess(Account acc, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        // 1. Change Session ID to prevent Session Fixation
        req.changeSessionId();

        // 2. Set User session
        req.getSession().setAttribute("user", acc);

        // 3. Set Cart Count
        org.example.dao.CartDAO cartDAO = new org.example.dao.CartDAO();
        req.getSession().setAttribute("cartCount", cartDAO.countCartLines(acc.getAccountId()));

        // 4. Redirect based on Role
        redirectByRole(acc, req, resp);
    }

    /**
     * Redirects the user to the appropriate dashboard based on their role.
     */
    public static void redirectByRole(Account acc, HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String contextPath = req.getContextPath();
        int roleId = acc.getRoleId();

        switch (roleId) {
            case RoleConstant.ADMIN:
                resp.sendRedirect(contextPath + "/admin/dashboard");
                break;
            case RoleConstant.MANAGER:
                resp.sendRedirect(contextPath + "/manager/products");
                break;
            case RoleConstant.STAFF:
                resp.sendRedirect(contextPath + "/staff/orders");
                break;
            case RoleConstant.SHIPPER:
                resp.sendRedirect(contextPath + "/shipper/orders");
                break;
            case RoleConstant.CUSTOMER:
            default:
                resp.sendRedirect(contextPath + "/home");
                break;
        }
    }
}
