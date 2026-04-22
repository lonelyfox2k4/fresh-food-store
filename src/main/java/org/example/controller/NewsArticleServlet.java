package org.example.controller;

import org.example.dao.NewsArticleDAO;
import org.example.model.content.NewsArticle;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import org.example.model.auth.Account;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NewsArticleServlet", urlPatterns = {"/staff/news"})
public class NewsArticleServlet extends HttpServlet {
    private NewsArticleDAO newsDAO = new NewsArticleDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("list".equals(action)) {
            request.setAttribute("newsList", newsDAO.getAllNews());
            request.getRequestDispatcher("/staff/news-list.jsp").forward(request, response);
        }
        // Cả tạo và sửa đều dùng chung news-form.jsp
        else if ("create".equals(action)) {
            request.getRequestDispatcher("/staff/news-form.jsp").forward(request, response);
        }
        else if ("edit".equals(action)) {
            try {
                long id = Long.parseLong(request.getParameter("newsId"));
                NewsArticle existingNews = newsDAO.getNewsById(id);
                request.setAttribute("news", existingNews); // Đẩy dữ liệu cũ sang form
                request.getRequestDispatcher("/staff/news-form.jsp").forward(request, response);
            } catch (Exception e) {
                response.sendRedirect("news?action=list&error=invalid_id");
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            if ("create".equals(action) || "update".equals(action)) {
                NewsArticle n = new NewsArticle();
                if ("update".equals(action)) {
                    n.setNewsId(Long.parseLong(request.getParameter("newsId")));
                }

                n.setTitle(request.getParameter("title"));
                n.setSummary(request.getParameter("summary"));
                n.setContent(request.getParameter("content"));
                n.setImageUrl(request.getParameter("imageUrl"));
                n.setCreatedByAccountId(1L); 
                HttpSession session = request.getSession();
                Account user = (Account) session.getAttribute("user");
                if (user != null) n.setCreatedByAccountId(user.getAccountId());

                // Kiểm tra nút bấm: publish (đăng ngay) hay draft (lưu nháp)
                String btn = request.getParameter("submitBtn");
                n.setStatus("publish".equals(btn) ? (byte)2 : (byte)0);

                if ("create".equals(action)) {
                    newsDAO.createNews(n);
                } else {
                    newsDAO.updateNews(n);
                }
            }
            else if ("changeStatus".equals(action)) {
                long id = Long.parseLong(request.getParameter("newsId"));
                byte status = Byte.parseByte(request.getParameter("status"));
                newsDAO.updateStatus(id, status);
            }
            else if ("delete".equals(action)) {
                long id = Long.parseLong(request.getParameter("newsId"));
                newsDAO.deleteNews(id);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("news?action=list");
    }
}