package org.example.controller;

import org.example.dao.CategoryDAO;
import org.example.dao.CartDAO;
import org.example.dao.NewsArticleDAO;
import org.example.dao.ProductDAO;
import org.example.dao.WishlistDAO;
import org.example.model.auth.Account;
import org.example.model.content.NewsArticle;
import org.example.model.catalog.Category;
import org.example.model.catalog.Product;
import org.example.dto.ProductDTO;
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
import java.util.Set;


@WebServlet(name = "HomeServlet", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    // Khởi tạo DAO
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final CartDAO cartDAO = new CartDAO();
    private final WishlistDAO wishlistDAO = new WishlistDAO();
    private final NewsArticleDAO newsDAO = new NewsArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Đặt UTF-8 để hiển thị Tiếng Việt không bị lỗi font
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        try {
            // 1. Gọi DAO lấy dữ liệu THẬT từ Database
            List<ProductDTO> flashSaleList = productDAO.getFlashSaleProducts();
            List<ProductDTO> bestSellerList = productDAO.getBestSellerProducts();
            List<Category> categoryList = categoryDAO.getAllActiveCategories();
            List<NewsArticle> latestNews = newsDAO.getLatestPublishedNews(4);

            // 2. Gắn vào Request để ném sang JSP
            request.setAttribute("flashSaleProducts", flashSaleList);
            request.setAttribute("bestSellerProducts", bestSellerList);
            request.setAttribute("categories", categoryList);
            request.setAttribute("latestNews", latestNews);

            Object userObj = request.getSession().getAttribute("user");
            if (userObj instanceof Account) {
                Account acc = (Account) userObj;
                request.getSession().setAttribute("cartCount", cartDAO.countCartLines(acc.getAccountId()));
                Set<Long> wishedIds = wishlistDAO.getWishlistedProductIds(acc.getAccountId());
                request.setAttribute("wishedProductIds", wishedIds);
            }

            moveFlashToRequest(request, "cartSuccessMsg");
            moveFlashToRequest(request, "cartErrorMsg");
            moveFlashToRequest(request, "wishlistSuccessMsg");
            moveFlashToRequest(request, "wishlistErrorMsg");
            // 3. Forward sang trang home.jsp
            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            // Nếu lỗi DB, có thể redirect về trang báo lỗi (500)
            response.getWriter().println("Lỗi kết nối Hệ thống! Vui lòng thử lại sau.");
        }
    }

    private void moveFlashToRequest(HttpServletRequest req, String key) {
        Object value = req.getSession().getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            req.getSession().removeAttribute(key);
        }
    }
}
