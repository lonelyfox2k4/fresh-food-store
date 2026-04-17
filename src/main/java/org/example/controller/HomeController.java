package org.example.controller;

import org.example.dao.CategoryDAO;
import org.example.dao.ProductDAO;
import org.example.model.catalog.Category;
import org.example.model.catalog.Product;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;


@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    // Khởi tạo DAO
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt UTF-8 để hiển thị Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // 1. Gọi DAO lấy dữ liệu THẬT từ Database
            List<Product> flashSaleList = productDAO.getFlashSaleProducts();
            List<Product> bestSellerList = productDAO.getBestSellerProducts();
            List<Category> categoryList = categoryDAO.getAllActiveCategories();


            // 2. Gắn vào Request để ném sang JSP
            request.setAttribute("flashSaleProducts", flashSaleList);
            request.setAttribute("bestSellerProducts", bestSellerList);
            request.setAttribute("categories", categoryList);
            // 3. Forward sang trang home.jsp
            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi DB, có thể redirect về trang báo lỗi (500)
            response.getWriter().println("Lỗi kết nối Hệ thống! Vui lòng thử lại sau.");
        }
    }
}