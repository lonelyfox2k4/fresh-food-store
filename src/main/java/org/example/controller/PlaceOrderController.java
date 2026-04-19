package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.OrderDAO;
import org.example.dto.CartItemDTO;
import org.example.model.auth.Account;
import org.example.model.marketing.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "PlaceOrderController", urlPatterns = {"/place-order"})
public class PlaceOrderController extends HttpServlet {

    private final OrderDAO  orderDAO = new OrderDAO();
    private final CartDAO   cartDAO  = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // 1. Extract shipping info
        String recipientName   = req.getParameter("recipientName");
        String recipientPhone  = req.getParameter("recipientPhone");
        String shippingAddress = req.getParameter("shippingAddress");
        String note            = req.getParameter("note");

        // 2. Prepare data for OrderDAO
        long accountId = user.getAccountId();
        long cartId    = cartDAO.findOrCreateCartIdByAccountId(accountId);
        List<CartItemDTO> cartItems = cartDAO.getCartItemDTOsByAccountId(accountId);
        Voucher voucher = (Voucher) session.getAttribute("appliedVoucher");

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        try {
            // 3. Create Order (FEFO transaction)
            long orderId = orderDAO.createOrder(
                    accountId, recipientName, recipientPhone, 
                    shippingAddress, note, cartItems, voucher, cartId
            );

            // 4. Cleanup and Redirect
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("cartCount"); // Reset cart count in session
            resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);

        } catch (Exception e) {
            // Log error and notify user
            e.printStackTrace();
            session.setAttribute("checkoutError", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }
}
