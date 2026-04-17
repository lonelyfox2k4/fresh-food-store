package org.example.controller;

import org.example.dao.FeedbackDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.Feedback;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/staff/feedback"})
public class FeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO = new FeedbackDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("feedbackList", feedbackDAO.getAllFeedbacks());
        request.getRequestDispatcher("/staff/feedback-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        long feedbackId = Long.parseLong(request.getParameter("feedbackId"));
        String responseText = request.getParameter("responseText");

        // Lấy ID của Staff đang đăng nhập từ Session
        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("account");
        long staffId = (staff != null) ? staff.getAccountId() : 1L; // Fallback về 1 nếu chưa login

        if (feedbackDAO.updateResponse(feedbackId, responseText, staffId)) {
            // Trả lời xong thì quay lại trang danh sách kèm thông báo
            response.sendRedirect("feedback?msg=replied");
        } else {
            response.sendRedirect("feedback?error=failed");
        }
    }
}
