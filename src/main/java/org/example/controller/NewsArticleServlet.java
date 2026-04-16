package org.example.controller;

import org.example.dao.NewsArticleDAO;
import org.example.model.content.NewsArticle;
import org.example.model.content.NewsStatus;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NewsArticleServlet", urlPatterns = {"/staff/news"})
public class NewsArticleServlet extends HttpServlet {

    private NewsArticleDAO newsDAO;

    @Override
    public void init() throws ServletException {
        newsDAO = new NewsArticleDAO();
    }

    // --- GET: Dùng để lấy dữ liệu hiển thị lên màn hình ---
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        if ("list".equals(action)) {
            List<NewsArticle> newsList = newsDAO.getAllNews();
            request.setAttribute("newsList", newsList);
            // Forward dữ liệu sang file JSP trong thư mục webapp
            request.getRequestDispatcher("/staff/news-list.jsp").forward(request, response);
        } else if ("create".equals(action)) {
            request.getRequestDispatcher("/staff/news-create.jsp").forward(request, response);
        }
    }

    // --- POST: Dùng để xử lý form gửi lên (Thêm, Sửa, Đổi trạng thái) ---
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/staff/news?error=missing_action");
            return;
        }

        try {
            switch (action) {
                case "create":
                    handleCreate(request, response);
                    break;
                case "update":
                    handleUpdate(request, response);
                    break;
                case "submit": // Staff gửi duyệt
                    handleStatusChange(request, response, NewsStatus.PENDING_APPROVAL);
                    break;
                case "approve": // Admin duyệt bài
                    handleStatusChange(request, response, NewsStatus.PUBLISHED);
                    break;
                case "archive": // Ẩn bài viết
                    handleStatusChange(request, response, NewsStatus.ARCHIVED);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/staff/news?error=invalid_action");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/staff/news?error=server_error");
        }
    }

    // --- LOGIC XỬ LÝ WORKFLOW ---

    private void handleCreate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // Thực tế: Lấy ID từ session người đăng nhập
        // long accountId = ((Account) request.getSession().getAttribute("loggedUser")).getId();
        long accountId = 1L; // Fix cứng tạm thời để test

        NewsArticle news = new NewsArticle();
        news.setTitle(request.getParameter("title"));
        news.setSummary(request.getParameter("summary"));
        news.setContent(request.getParameter("content"));
        news.setImageUrl(request.getParameter("imageUrl"));
        news.setCreatedByAccountId(accountId);

        if (newsDAO.createNews(news)) {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=list&msg=created_draft");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=create&error=failed");
        }
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long newsId = Long.parseLong(request.getParameter("newsId"));
        // Nút bấm "Lưu và Submit" có value = true
        boolean isSubmitForReview = "true".equals(request.getParameter("isSubmitForReview"));

        NewsArticle news = new NewsArticle();
        news.setNewsId(newsId);
        news.setTitle(request.getParameter("title"));
        news.setSummary(request.getParameter("summary"));
        news.setContent(request.getParameter("content"));
        news.setImageUrl(request.getParameter("imageUrl"));

        if (newsDAO.updateNews(news, isSubmitForReview)) {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=list&msg=updated");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=list&error=update_failed");
        }
    }

    private void handleStatusChange(HttpServletRequest request, HttpServletResponse response, NewsStatus targetStatus) throws IOException {
        long newsId = Long.parseLong(request.getParameter("newsId"));

        // TODO: Chỗ này bạn có thể check thêm phân quyền từ Session
        // Ví dụ: Nếu targetStatus == PUBLISHED thì role phải là ADMIN

        if (newsDAO.updateStatus(newsId, targetStatus)) {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=list&msg=status_changed");
        } else {
            response.sendRedirect(request.getContextPath() + "/staff/news?action=list&error=status_failed");
        }
    }
}