package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.OrderDAO;
import org.example.model.auth.Account;
import org.example.utils.VnPayConfig;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.*;

/**
 * Controller to handle VNPAY Return URL after payment.
 */
@WebServlet(name = "VnPayReturnController", urlPatterns = {"/vnpay-return"})
public class VnPayReturnController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO  cartDAO  = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Account user = (Account) session.getAttribute("user");
        
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = req.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = req.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                fields.put(fieldName, fieldValue);
            }
        }

        String vnp_SecureHash = req.getParameter("vnp_SecureHash");
        fields.remove("vnp_SecureHashType");
        fields.remove("vnp_SecureHash");

        // Verify Signature
        String signValue = VnPayConfig.hashAllFields(fields);

        if (signValue.equals(vnp_SecureHash)) {
            String vnp_ResponseCode = req.getParameter("vnp_ResponseCode");
            long orderId = Long.parseLong(req.getParameter("vnp_TxnRef"));
            String transactionNo = req.getParameter("vnp_TransactionNo");

            if ("00".equals(vnp_ResponseCode)) {
                // Payment Success
                // paymentStatus = 2 (PAID), orderStatus = 2 (PROCESSING)
                orderDAO.updatePaymentStatus(orderId, (byte) 2, (byte) 2);
                orderDAO.updatePaymentTransaction(orderId, transactionNo);
                
                // Clear cart now that payment is confirmed
                if (user != null) {
                    long cartId = cartDAO.findOrCreateCartIdByAccountId(user.getAccountId());
                    cartDAO.clearCart(cartId);
                }
                
                resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
            } else {
                // Payment Failed or Cancelled - Release Inventory
                if (user != null) {
                    orderDAO.cancelOrder(orderId, user.getAccountId());
                }
                
                session.setAttribute("checkoutError", "Thanh toán không thành công hoặc đã bị hủy. Mã lỗi: " + vnp_ResponseCode);
                resp.sendRedirect(req.getContextPath() + "/checkout");
            }
        } else {
            // Invalid Signature
            session.setAttribute("checkoutError", "Chữ ký không hợp lệ. Giao dịch có thể đã bị can thiệp.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }
}
