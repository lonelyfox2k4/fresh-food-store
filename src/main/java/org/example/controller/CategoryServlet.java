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
    // Khởi tạo đối tượng DAO dùng chung cho toàn bộ Servlet này để tương tác với cơ sở dữ liệu
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    /**
     * Phương thức doGet: Thường dùng để xử lý các yêu cầu lấy dữ liệu (hiển thị trang, lấy danh sách)
     * hoặc các thao tác truyền tham số trực tiếp trên thanh URL (như xóa).
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if (action.equals("delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            categoryDAO.updateStatus(id, false);
            response.sendRedirect("categories");
        } else {
            request.setAttribute("categories", categoryDAO.getAllActiveCategories());
            request.getRequestDispatcher("/manager/categories.jsp").forward(request, response);
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
