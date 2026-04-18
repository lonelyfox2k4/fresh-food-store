package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.CategoryDAO;
import org.example.dao.OrderDAO;
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

@WebServlet(urlPatterns = {"/checkout", "/place-order", "/voucher/apply"})
public class CheckoutController extends HttpServlet {

    private final CartDAO     cartDAO     = new CartDAO();
    private final OrderDAO    orderDAO    = new OrderDAO();
    private final VoucherDAO  voucherDAO  = new VoucherDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/checkout".equals(req.getServletPath())) {
            showCheckout(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        switch (req.getServletPath()) {
            case "/voucher/apply": handleApplyVoucher(req, resp); break;
            case "/place-order":   handlePlaceOrder(req, resp);   break;
        }
    }

    // ── Show checkout form ────────────────────────────────────────────────────

    private void showCheckout(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user   = getUser(req);
        long    cartId = cartDAO.getOrCreateCart(user.getAccountId());
        List<CartItemDTO> cartItems = cartDAO.getCartItems(cartId);

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        BigDecimal subtotal = cartItems.stream()
                .map(CartItemDTO::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);
        BigDecimal shippingFee = subtotal.compareTo(new BigDecimal("500000")) >= 0
                ? BigDecimal.ZERO : new BigDecimal("30000");

        // Load saved voucher from session
        Voucher savedVoucher = (Voucher) req.getSession().getAttribute("appliedVoucher");
        BigDecimal voucherDiscount = BigDecimal.ZERO;
        if (savedVoucher != null) {
            voucherDiscount = voucherDAO.calculateDiscount(savedVoucher, subtotal);
        }

        BigDecimal total = subtotal.subtract(voucherDiscount).add(shippingFee).max(BigDecimal.ZERO);

        req.setAttribute("cartItems",      cartItems);
        req.setAttribute("cartId",         cartId);
        req.setAttribute("subtotal",       subtotal);
        req.setAttribute("shippingFee",    shippingFee);
        req.setAttribute("voucherDiscount",voucherDiscount);
        req.setAttribute("total",          total);
        req.setAttribute("appliedVoucher", savedVoucher);
        req.setAttribute("categories",     categoryDAO.getAllActiveCategories());

        req.getRequestDispatcher("/checkout.jsp").forward(req, resp);
    }

    // ── Apply voucher (AJAX-friendly redirect) ────────────────────────────────

    private void handleApplyVoucher(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String code = req.getParameter("voucherCode");
        Account user = getUser(req);
        long cartId = cartDAO.getOrCreateCart(user.getAccountId());
        List<CartItemDTO> cartItems = cartDAO.getCartItems(cartId);

        BigDecimal subtotal = cartItems.stream()
                .map(CartItemDTO::getLineTotal)
                .reduce(BigDecimal.ZERO, BigDecimal::add);

        if (code != null && !code.trim().isEmpty()) {
            Voucher voucher = voucherDAO.getValidVoucherByCode(code, subtotal);
            if (voucher != null) {
                req.getSession().setAttribute("appliedVoucher", voucher);
                req.getSession().setAttribute("voucherMsg", "success:Áp dụng mã \"" + voucher.getVoucherCode() + "\" thành công!");
            } else {
                req.getSession().removeAttribute("appliedVoucher");
                req.getSession().setAttribute("voucherMsg", "error:Mã giảm giá không hợp lệ hoặc chưa đủ điều kiện áp dụng!");
            }
        } else {
            req.getSession().removeAttribute("appliedVoucher");
            req.getSession().setAttribute("voucherMsg", "info:Đã xóa mã giảm giá.");
        }
        resp.sendRedirect(req.getContextPath() + "/checkout");
    }

    // ── Place order ───────────────────────────────────────────────────────────

    private void handlePlaceOrder(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user   = getUser(req);
        long    cartId = cartDAO.getOrCreateCart(user.getAccountId());
        List<CartItemDTO> cartItems = cartDAO.getCartItems(cartId);

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        String name    = req.getParameter("recipientName");
        String phone   = req.getParameter("recipientPhone");
        String address = req.getParameter("shippingAddress");
        String note    = req.getParameter("note");

        // Basic validation
        if (name == null || name.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || address == null || address.trim().isEmpty()) {
            req.getSession().setAttribute("checkoutError",
                    "Vui lòng điền đầy đủ họ tên, số điện thoại và địa chỉ giao hàng!");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        Voucher voucher = (Voucher) req.getSession().getAttribute("appliedVoucher");

        try {
            long orderId = orderDAO.createOrder(
                    user.getAccountId(), name.trim(), phone.trim(),
                    address.trim(), note, cartItems, voucher, cartId);

            // Clear session voucher & update cart count
            req.getSession().removeAttribute("appliedVoucher");
            req.getSession().removeAttribute("voucherMsg");
            req.getSession().setAttribute("cartCount", 0);

            resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);

        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("checkoutError", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }

    private Account getUser(HttpServletRequest req) {
        return (Account) req.getSession().getAttribute("user");
    }
}
