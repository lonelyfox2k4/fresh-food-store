package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.dao.VoucherDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.Voucher;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet(name = "VoucherServlet", urlPatterns = {"/staff/voucher"})
public class VoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    List<Voucher> list = voucherDAO.getAllVouchers();
                    request.setAttribute("voucherList", list);
                    // Lưu ý: Forward đúng đường dẫn bỏ chữ /webapp/
                    request.getRequestDispatcher("/staff/voucher-list.jsp").forward(request, response);
                    break;

                case "create":
                    request.getRequestDispatcher("/staff/voucher-form.jsp").forward(request, response);
                    break;

                case "delete":
                    long id = Long.parseLong(request.getParameter("id"));
                    if (voucherDAO.deleteVoucher(id)) {
                        response.sendRedirect("voucher?msg=deleted");
                    } else {
                        response.sendRedirect("voucher?error=delete_failed");
                    }
                    break;

                default:
                    response.sendRedirect("voucher?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voucher?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("create".equals(action)) {
            try {
                // 1. Lấy thông tin cơ bản
                String code = request.getParameter("voucherCode").trim().toUpperCase();
                String name = request.getParameter("voucherName");
                byte type = Byte.parseByte(request.getParameter("discountType"));
                BigDecimal value = new BigDecimal(request.getParameter("discountValue"));
                BigDecimal minOrder = new BigDecimal(request.getParameter("minOrderAmount"));
                BigDecimal maxDiscountValue = new BigDecimal(request.getParameter("maxDiscountAmount"));
                String usageLimitStr = request.getParameter("usageLimit");
                String startAtStr = request.getParameter("startAt");
                String endAtStr = request.getParameter("endAt");
                
                // --- LOGIC VALIDATION ---
                
                // Rule 1: Voucher Code Length (5-15)
                if (code.length() < 5 || code.length() > 15) {
                    response.sendRedirect("voucher?action=create&error=code_length");
                    return;
                }
                
                // Rule 2: Uniqueness
                if (voucherDAO.isVoucherCodeExists(code)) {
                    response.sendRedirect("voucher?action=create&error=duplicate_code");
                    return;
                }
                
                // Rule 3: Discount Value Logic
                if (type == 1) { // Percentage
                    if (value.compareTo(BigDecimal.ONE) < 0 || value.compareTo(new BigDecimal(100)) > 0) {
                        response.sendRedirect("voucher?action=create&error=invalid_percent");
                        return;
                    }
                } else { // Flat Amount
                    if (value.compareTo(BigDecimal.ZERO) <= 0 || value.compareTo(minOrder) > 0) {
                        response.sendRedirect("voucher?action=create&error=discount_too_high");
                        return;
                    }
                }
                
                // Rule 4: Dates Logic
                LocalDateTime start = LocalDateTime.parse(startAtStr.length() == 16 ? startAtStr + ":00" : startAtStr);
                LocalDateTime end = LocalDateTime.parse(endAtStr.length() == 16 ? endAtStr + ":00" : endAtStr);
                
                if (end.isBefore(start) || end.isEqual(start)) {
                    response.sendRedirect("voucher?action=create&error=invalid_dates");
                    return;
                }
                
                if (start.isBefore(LocalDateTime.now().minusMinutes(5))) { // Allow 5min buffer for server lag
                    response.sendRedirect("voucher?action=create&error=start_in_past");
                    return;
                }

                // --- DATA PREPARATION ---
                Voucher v = new Voucher();
                v.setVoucherCode(code);
                v.setVoucherName(name);
                v.setDiscountType(type);
                v.setDiscountValue(value);
                v.setMinOrderAmount(minOrder);
                v.setMaxDiscountAmount(type == 1 ? maxDiscountValue : value); // Auto-set for flat amount
                v.setUsageLimit((usageLimitStr != null && !usageLimitStr.isEmpty()) ? Integer.parseInt(usageLimitStr) : null);
                v.setUsedCount(0);
                v.setStartAt(start);
                v.setEndAt(end);
                v.setStatus((byte) 0); 
                
                HttpSession session = request.getSession();
                Account user = (Account) session.getAttribute("user");
                v.setCreatedByAccountId(user != null ? user.getAccountId() : 1L);

                String requestNote = request.getParameter("requestNote");
                if (requestNote == null || requestNote.isEmpty()) {
                    requestNote = "Staff yêu cầu tạo voucher mới";
                }

                if (voucherDAO.createVoucherWithRequest(v, requestNote)) {
                    response.sendRedirect("voucher?action=list&msg=requested");
                } else {
                    response.sendRedirect("voucher?action=create&error=failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("voucher?action=create&error=invalid_data");
            }
        }
    }
}