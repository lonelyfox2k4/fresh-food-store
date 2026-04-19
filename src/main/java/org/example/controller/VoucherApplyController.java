package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.VoucherDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "VoucherApplyController", urlPatterns = {"/voucher/apply"})
public class VoucherApplyController extends HttpServlet {

    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final CartDAO    cartDAO    = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        HttpSession session = req.getSession();
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String code = req.getParameter("voucherCode");
        
        // 1. Remove voucher if empty code provided (Un-apply)
        if (code == null || code.trim().isEmpty()) {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("voucherMsg", "info:Đã gỡ mã giảm giá.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // 2. Fetch and Validate
        BigDecimal subtotal = cartDAO.getCartTotalAmount(user.getAccountId());
        Voucher voucher = voucherDAO.getValidVoucherByCode(code, subtotal);

        if (voucher != null) {
            session.setAttribute("appliedVoucher", voucher);
            session.setAttribute("voucherMsg", "success:Áp dụng mã '" + voucher.getVoucherCode() + "' thành công!");
        } else {
            session.removeAttribute("appliedVoucher");
            session.setAttribute("voucherMsg", "error:Mã giảm giá không hợp lệ, đã hết hạn hoặc chưa đủ điều kiện.");
        }

        resp.sendRedirect(req.getContextPath() + "/checkout");
    }
}
