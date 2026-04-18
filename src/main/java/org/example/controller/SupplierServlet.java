package org.example.controller;

import org.example.dao.SupplierDAO;
import org.example.model.inventory.Supplier;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class SupplierServlet extends HttpServlet {
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("toggle-status".equals(action)) {
            long id = Long.parseLong(request.getParameter("id"));
            boolean status = Boolean.parseBoolean(request.getParameter("status"));
            supplierDAO.updateStatus(id, status);
            response.sendRedirect("suppliers");
        } else {
            request.setAttribute("suppliers", supplierDAO.getAllSuppliers());
            request.getRequestDispatcher("/manager/suppliers.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        
        Supplier s = new Supplier();
        s.setSupplierName(request.getParameter("supplierName"));
        s.setPhone(request.getParameter("phone"));
        s.setEmail(request.getParameter("email"));
        s.setAddress(request.getParameter("address"));
        s.setNote(request.getParameter("note"));
        s.setStatus(request.getParameter("status") != null);

        if (idStr == null || idStr.isEmpty()) {
            supplierDAO.insertSupplier(s);
        } else {
            s.setSupplierId(Long.parseLong(idStr));
            supplierDAO.updateSupplier(s);
        }
        response.sendRedirect("suppliers");
    }
}
