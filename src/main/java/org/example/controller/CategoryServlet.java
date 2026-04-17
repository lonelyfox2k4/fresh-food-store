package org.example.controller;

import org.example.dao.CategoryDAO;
import org.example.model.catalog.Category;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class CategoryServlet extends HttpServlet {
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryDAO.updateStatus(id, false);
            response.sendRedirect("categories");
        } else {
            request.setAttribute("categories", categoryDAO.getAllCategories());
            request.getRequestDispatcher("/admin/categories.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        
        Category c = new Category();
        c.setCategoryName(request.getParameter("categoryName"));
        c.setStatus(request.getParameter("status") != null);

        if (idStr == null || idStr.isEmpty()) {
            categoryDAO.insertCategory(c);
        } else {
            c.setCategoryId(Integer.parseInt(idStr));
            categoryDAO.updateCategory(c);
        }
        response.sendRedirect("categories");
    }
}
