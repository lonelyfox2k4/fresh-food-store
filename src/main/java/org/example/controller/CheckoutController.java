package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.VoucherDAO;
import org.example.dto.CartItemDTO;
import org.example.model.auth.Account;
import org.example.model.marketing.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    private final CartDAO    cartDAO    = new CartDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        Account user = (Account) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<CartItemDTO> cartItems = cartDAO.getCartItemDTOsByAccountId(user.getAccountId());
        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        // 1. Subtotal
        BigDecimal subtotal = cartItems.stream()
                .map(CartItemDTO::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        // 2. Voucher Discount
        BigDecimal voucherDiscount = BigDecimal.ZERO;
        Voucher appliedVoucher = (Voucher) req.getSession().getAttribute("appliedVoucher");
        if (appliedVoucher != null) {
            voucherDiscount = voucherDAO.calculateDiscount(appliedVoucher, subtotal);
        }

        // 3. Shipping Fee (Free > 500.000, else 30.000)
        BigDecimal shippingFee = subtotal.compareTo(new BigDecimal("500000")) >= 0
                ? BigDecimal.ZERO : new BigDecimal("30000");

        // 4. Grand Total
        BigDecimal total = subtotal.subtract(voucherDiscount).add(shippingFee).max(BigDecimal.ZERO);

        req.setAttribute("cartItems",       cartItems);
        req.setAttribute("subtotal",        subtotal);
        req.setAttribute("appliedVoucher",  appliedVoucher);
        req.setAttribute("voucherDiscount", voucherDiscount);
        req.setAttribute("shippingFee",    shippingFee);
        req.setAttribute("total",           total);

        req.getRequestDispatcher("/main/checkout.jsp").forward(req, resp);
    }
}
