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
                Voucher v = new Voucher();
                // 1. Lấy thông tin cơ bản
                v.setVoucherCode(request.getParameter("voucherCode"));
                v.setVoucherName(request.getParameter("voucherName"));
                v.setDiscountType(Byte.parseByte(request.getParameter("discountType")));

                // 2. Xử lý BigDecimal
                v.setDiscountValue(new BigDecimal(request.getParameter("discountValue")));
                v.setMinOrderAmount(new BigDecimal(request.getParameter("minOrderAmount")));
                v.setMaxDiscountAmount(new BigDecimal(request.getParameter("maxDiscountAmount")));

                // 3. Xử lý số lượng
                String usageLimitStr = request.getParameter("usageLimit");
                v.setUsageLimit((usageLimitStr != null && !usageLimitStr.isEmpty()) ? Integer.parseInt(usageLimitStr) : null);
                v.setUsedCount(0);

                // 4. Xử lý thời gian (Xử lý chuỗi từ datetime-local)
                String startAtStr = request.getParameter("startAt");
                String endAtStr = request.getParameter("endAt");
                v.setStartAt(LocalDateTime.parse(startAtStr.length() == 16 ? startAtStr + ":00" : startAtStr));
                v.setEndAt(LocalDateTime.parse(endAtStr.length() == 16 ? endAtStr + ":00" : endAtStr));

                // 5. Trạng thái và Người tạo (Lấy từ Session)
                v.setStatus((byte) 0); 
                HttpSession session = request.getSession();
                Account user = (Account) session.getAttribute("user");
                v.setCreatedByAccountId(user != null ? user.getAccountId() : 1L);

                // 6. Lấy lời nhắn gửi Admin cho bảng VoucherRequests
                String requestNote = request.getParameter("requestNote");
                if (requestNote == null || requestNote.isEmpty()) {
                    requestNote = "Staff yêu cầu tạo voucher mới";
                }

                // GỌI HÀM TRANSACTION 2 TRONG 1
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