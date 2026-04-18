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

        String reviewIdStr = request.getParameter("reviewId");
        String responseText = request.getParameter("responseText");

        if (reviewIdStr == null || reviewIdStr.isEmpty()) {
            response.sendRedirect("feedback?error=missing_id");
            return;
        }

        long reviewId = Long.parseLong(reviewIdStr);

        // Lấy ID của Staff đang đăng nhập từ Session
        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("user"); // Fixed: using "user" key which is common in this project
        long staffId = (staff != null) ? staff.getAccountId() : 1L;

        if (feedbackDAO.saveOrUpdateResponse(reviewId, responseText, staffId)) {
            response.sendRedirect("feedback?msg=replied");
        } else {
            response.sendRedirect("feedback?error=failed");
        }
    }
}
