package org.example.controller;

import org.example.dao.FeedbackDAO;
import org.example.dao.OrderItemDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.Feedback;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/staff/feedback"})
public class FeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO = new FeedbackDAO();
    private OrderItemDAO orderItemDAO = new OrderItemDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Feedback> feedbackList = feedbackDAO.getAllFeedbacks();
        
        // Fetch order items for each feedback linked to an order
        for (Feedback f : feedbackList) {
            if (f.getOrderId() != null) {
                f.setItemList(orderItemDAO.getOrderItemsByOrderId(f.getOrderId()));
            }
        }
        
        request.setAttribute("feedbackList", feedbackList);
        request.getRequestDispatcher("/staff/feedback-list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String feedbackIdStr = request.getParameter("feedbackId");
        String reviewIdStr = request.getParameter("reviewId");
        long feedbackId = (feedbackIdStr != null && !feedbackIdStr.isEmpty()) ? Long.parseLong(feedbackIdStr) : 0L;
        Long reviewId = (reviewIdStr != null && !reviewIdStr.isEmpty()) ? Long.parseLong(reviewIdStr) : null;
        
        String responseText = request.getParameter("responseText");
        HttpSession session = request.getSession();



        // Lấy ID của Staff đang đăng nhập từ Session
        Account staff = (Account) session.getAttribute("user");
        long staffId = (staff != null) ? staff.getAccountId() : 1L; 

        if (feedbackDAO.saveResponse(feedbackId, reviewId, responseText, staffId, staff != null ? staff.getAccountId() : 1L)) {
            // Trả lời xong thì quay lại trang danh sách kèm thông báo
            response.sendRedirect("feedback?msg=replied");
        } else {
            response.sendRedirect("feedback?error=failed");
        }
    }
}
