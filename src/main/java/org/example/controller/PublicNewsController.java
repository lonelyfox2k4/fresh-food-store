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
        if (idStr == null || idStr.isEmpty()) {
            System.out.println("[PublicNewsController] Missing ID parameter");
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h3>Hệ thống tin tức đang hoạt động</h3>");
            response.getWriter().println("<p>Vui lòng cung cấp ID bài viết hợp lệ.</p>");
            response.getWriter().println("<hr><a href='" + request.getContextPath() + "/home'>Quay lại trang chủ</a>");
            return;
        }

        try {
            long id = Long.parseLong(idStr);
            System.out.println("[PublicNewsController] Requesting news ID: " + id);
            
            NewsArticle article = newsDAO.getNewsById(id);

            if (article == null) {
                System.out.println("[PublicNewsController] Article not found for ID: " + id);
                response.sendRedirect(request.getContextPath() + "/home?error=not_found");
                return;
            }
            
            if (article.getStatus() != 2) {
                System.out.println("[PublicNewsController] Article ID " + id + " is not published (Status: " + article.getStatus() + ")");
                response.sendRedirect(request.getContextPath() + "/home?error=not_published");
                return;
            }

            request.setAttribute("article", article);
            request.getRequestDispatcher("/news-detail.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            System.out.println("[PublicNewsController] Invalid ID format: " + idStr);
            response.sendRedirect(request.getContextPath() + "/home?error=invalid_id");
        } catch (Exception e) {
            System.err.println("[PublicNewsController] Unexpected error: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?error=system_error");
        }
    }
}
