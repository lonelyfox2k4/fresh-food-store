package org.example.controller;

import org.example.dao.NewsArticleDAO;
import org.example.model.content.NewsArticle;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "PublicNewsController", urlPatterns = {"/news"})
public class PublicNewsController extends HttpServlet {
    private final NewsArticleDAO newsDAO = new NewsArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        
        // Trình duyệt tiếng Việt
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        if (idStr == null || idStr.isEmpty()) {
            // CASE 1: Chuyển hướng sang danh sách tin tức (Logic xử lý nằm trong news.jsp)
            try {
                request.getRequestDispatcher("/news.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/home?error=system_error");
            }
            return;
        }

        // CASE 2: Hiển thị chi tiết bài viết
        try {
            long id = Long.parseLong(idStr);
            NewsArticle article = newsDAO.getNewsById(id);

            if (article == null || article.getStatus() != 2) {
                response.sendRedirect(request.getContextPath() + "/news?error=not_found");
                return;
            }

            request.setAttribute("article", article);
            request.getRequestDispatcher("/news-detail.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/news?error=invalid_id");
        }
    }
}
