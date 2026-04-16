package org.example.controller;

import org.example.dao.DashboardDAO;
import org.example.dto.DashboardDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private DashboardDAO dashboardDAO = new DashboardDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        DashboardDTO stats = dashboardDAO.getDashboardStats();
        req.setAttribute("stats", stats);
        req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
    }
}
