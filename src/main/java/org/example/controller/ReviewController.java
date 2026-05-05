package org.example.controller;

import org.example.dao.ReviewDAO;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/review/add")
public class ReviewController extends HttpServlet {

    private final ReviewDAO reviewDAO = new ReviewDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user = (Account) req.getSession().getAttribute("user");

        String productIdParam = req.getParameter("productId");
        String ratingParam    = req.getParameter("rating");
        String comment        = req.getParameter("comment");

        String redirectTo = req.getParameter("redirect");

        try {
            long productId = Long.parseLong(productIdParam);
            byte rating    = Byte.parseByte(ratingParam);

            if (rating < 1 || rating > 5) {
                req.getSession().setAttribute("reviewError", "Điểm đánh giá phải từ 1 đến 5 sao!");
            } else if (comment == null || comment.trim().isEmpty()) {
                req.getSession().setAttribute("reviewError", "Vui lòng nhập nội dung đánh giá!");
            } else if (org.example.utils.ValidationUtils.hasSensitiveWords(comment)) {
                req.getSession().setAttribute("reviewError", "Nội dung đánh giá chứa từ ngữ không phù hợp. Vui lòng điều chỉnh lại!");
            } else {
                if (!reviewDAO.canReview(user.getAccountId(), productId)) {
                    req.getSession().setAttribute("reviewError", "Bạn đã đánh giá sản phẩm này hoặc chưa đủ điều kiện để đánh giá!");
                } else {
                    boolean ok = reviewDAO.addReview(productId, user.getAccountId(), rating, comment.trim());
                    if (ok) {
                        req.getSession().setAttribute("reviewSuccess", "Đánh giá của bạn đã được ghi nhận! Cảm ơn.");
                    } else {
                        req.getSession().setAttribute("reviewError", "Không thể gửi đánh giá. Vui lòng thử lại!");
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("reviewError", "Dữ liệu không hợp lệ!");
        }

        if (redirectTo != null && !redirectTo.isEmpty()) {
            resp.sendRedirect(redirectTo);
        } else {
            resp.sendRedirect(req.getContextPath() + "/products");
        }
    }
}
