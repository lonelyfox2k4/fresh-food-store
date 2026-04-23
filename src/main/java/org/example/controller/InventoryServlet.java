package org.example.controller;

import org.example.dao.InventoryDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class InventoryServlet extends HttpServlet {
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("detail".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            request.setAttribute("batch", inventoryDAO.getInventoryBatchDetail(id));
            request.getRequestDispatcher("/manager/inventory-detail.jsp").forward(request, response);
            return;
        }

        boolean expiredOnly = "expired".equals(action);
        request.setAttribute("expiredOnly", expiredOnly);
        request.setAttribute("batches", inventoryDAO.getInventoryBatchList(expiredOnly));
        request.getRequestDispatcher("/manager/inventory-list.jsp").forward(request, response);
    }
}
