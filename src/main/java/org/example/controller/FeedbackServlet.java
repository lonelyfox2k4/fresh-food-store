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

        long feedbackId = 0;
        try {
            String fbStr = request.getParameter("feedbackId");
            if (fbStr != null && !fbStr.isEmpty()) {
                feedbackId = Long.parseLong(fbStr);
            }
        } catch (NumberFormatException e) { }

        Long reviewId = null;
        try {
            String rvStr = request.getParameter("reviewId");
            if (rvStr != null && !rvStr.isEmpty()) {
                reviewId = Long.parseLong(rvStr);
            }
        } catch (NumberFormatException e) { }

        String responseText = request.getParameter("responseText");

        // Lấy ID của Staff đang đăng nhập từ Session
        HttpSession session = request.getSession();
        Account staff = (Account) session.getAttribute("user");

        long staffId = (staff != null) ? staff.getAccountId() : 1L; // Fallback về 1 nếu chưa login

        if (feedbackDAO.saveResponse(feedbackId, reviewId, responseText, staffId, 0L)) {
            // Trả lời xong thì quay lại trang danh sách kèm thông báo
            response.sendRedirect("feedback?msg=replied");
        } else {
            response.sendRedirect("feedback?error=failed");
        }
    }
}
