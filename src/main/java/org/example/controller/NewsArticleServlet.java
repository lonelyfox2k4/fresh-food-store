package org.example.controller;

import org.example.dao.NewsArticleDAO;
import org.example.model.auth.Account;
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

        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        // 1. Authorization Check (Only Admin=1 or Staff=2 can modify news)
        if (user == null || (user.getRoleId() != 1 && user.getRoleId() != 2)) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        try {
            if ("create".equals(action) || "update".equals(action)) {
                String title = request.getParameter("title");
                String summary = request.getParameter("summary");
                String content = request.getParameter("content");
                String imageUrl = request.getParameter("imageUrl");

                // 2. Logic Validation
                String error = null;
                if (title == null || title.trim().length() < 5) error = "Tiêu đề quá ngắn (tối thiểu 5 ký tự)";
                else if (title.length() > 150) error = "Tiêu đề quá dài (tối đa 150 ký tự)";
                else if (summary == null || summary.trim().length() < 10) error = "Tóm tắt quá ngắn (tối thiểu 10 ký tự)";
                else if (summary.length() > 300) error = "Tóm tắt quá dài (tối đa 300 ký tự)";
                else if (content == null || content.trim().isEmpty()) error = "Nội dung bài viết không được để trống";

                if (error != null) {
                    request.setAttribute("error", error);
                    // Preserve input data
                    NewsArticle n = new NewsArticle();
                    if ("update".equals(action)) n.setNewsId(Long.parseLong(request.getParameter("newsId")));
                    n.setTitle(title);
                    n.setSummary(summary);
                    n.setContent(content);
                    n.setImageUrl(imageUrl);
                    request.setAttribute("news", n);
                    request.getRequestDispatcher("/staff/news-form.jsp").forward(request, response);
                    return;
                }

                NewsArticle n = new NewsArticle();
                if ("update".equals(action)) {
                    n.setNewsId(Long.parseLong(request.getParameter("newsId")));
                }

                n.setTitle(title.trim());
                n.setSummary(summary.trim());
                n.setContent(content);
                n.setImageUrl(imageUrl != null ? imageUrl.trim() : null);
                n.setCreatedByAccountId(user.getAccountId());

                // Button choice: publish (2) or draft (0)
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