package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.model.Account;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(urlPatterns = {"/admin/users", "/admin/update-status", "/admin/assign"})
public class AdminController extends HttpServlet {
    private AccountDAO dao = new AccountDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/users".equals(path)) {
            req.setAttribute("users", dao.getAllAccounts());
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } else if ("/admin/assign".equals(path)) {
            req.getRequestDispatcher("/admin/assign.jsp").forward(req, resp);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String path = req.getServletPath();
        if ("/admin/update-status".equals(path)) {
            long id = Long.parseLong(req.getParameter("id"));
            boolean status = Boolean.parseBoolean(req.getParameter("status"));
            dao.updateStatus(id, !status);
            resp.sendRedirect("users");
        } else if ("/admin/assign".equals(path)) {
            int roleId = Integer.parseInt(req.getParameter("roleId"));
            String email = req.getParameter("email");
            String name = req.getParameter("name");
            dao.insertAccount(roleId, email, "123456", name, req.getParameter("phone"));
            resp.sendRedirect("users");
        }
    }
}