package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.OrderDAO;
import org.example.dto.CartItemDTO;
import org.example.model.auth.Account;
import org.example.model.marketing.Voucher;
import org.example.model.order.Order;
import org.example.utils.VnPayConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet(name = "PlaceOrderController", urlPatterns = {"/place-order"})
public class PlaceOrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();
    private final CartDAO  cartDAO  = new CartDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        // --- Auth check ---
        Account user = (Account) session.getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // --- 1. Extract shipping info ---
        String recipientName   = req.getParameter("recipientName") != null ? req.getParameter("recipientName").trim() : "";
        String recipientPhone  = req.getParameter("recipientPhone") != null ? req.getParameter("recipientPhone").trim() : "";
        String shippingAddress = req.getParameter("shippingAddress") != null ? req.getParameter("shippingAddress").trim() : "";
        String note            = req.getParameter("note") != null ? req.getParameter("note").trim() : "";
        String paymentMethod   = req.getParameter("paymentMethod");
        if (paymentMethod == null) paymentMethod = "COD";

        // --- 1.1 Validation ---
        if (recipientName.isEmpty() || recipientPhone.isEmpty() || shippingAddress.isEmpty()) {
            session.setAttribute("checkoutError", "Vui lòng điền đầy đủ thông tin giao hàng.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // Phone: 10 digits, starts with 0
        if (!recipientPhone.matches("^0\\d{9}$")) {
            session.setAttribute("checkoutError", "Số điện thoại không hợp lệ (phải có 10 chữ số và bắt đầu bằng số 0).");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // Name: No special characters (allow Unicode letters, numbers, and spaces)
        if (!recipientName.matches("^[\\p{L}0-9\\s]+$")) {
            session.setAttribute("checkoutError", "Tên người nhận không được chứa ký tự đặc biệt.");
            resp.sendRedirect(req.getContextPath() + "/checkout");
            return;
        }

        // --- 2. Load cart ---
        long accountId = user.getAccountId();
        long cartId    = cartDAO.findOrCreateCartIdByAccountId(accountId);
        List<CartItemDTO> cartItems = cartDAO.getCartItemDTOsByAccountId(accountId);
        Voucher voucher = (Voucher) session.getAttribute("appliedVoucher");

        if (cartItems.isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        try {
            // --- 3. Create order ---
            // Always clear cart immediately to prevent duplicate submissions
            boolean shouldClearCart = true;
            long orderId = orderDAO.createOrder(
                    accountId, recipientName, recipientPhone,
                    shippingAddress, note, cartItems, voucher, cartId, paymentMethod,
                    shouldClearCart
            );

            // --- 4. Clean up session ---
            session.removeAttribute("appliedVoucher");
            session.removeAttribute("cartCount");

            // --- 5. Route by payment method ---
            if ("VNPAY".equalsIgnoreCase(paymentMethod)) {
                String paymentUrl = buildVnPayUrl(req, orderId, accountId,  user);
                resp.sendRedirect(paymentUrl);
            } else {
                // COD
                resp.sendRedirect(req.getContextPath() + "/order-success?id=" + orderId);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("checkoutError", e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/checkout");
        }
    }

    /**
     * Builds the VNPAY payment URL with a correct HMAC-SHA512 signature.
     *
     * Key rules (VNPAY 2.1.0):
     *  - Hash string  : raw (non-encoded) field names & values, sorted alphabetically
     *  - Query string : URL-encoded field names & values
     *  - vnp_Bill_*   : appended to query AFTER hashing — never included in the hash
     */
    private String buildVnPayUrl(HttpServletRequest req,
                                 long orderId,
                                 long accountId,
                                 Account user) throws Exception {

        Order order = orderDAO.getOrderById(orderId, accountId);
        long amount = order.getTotalAmount()
                .multiply(new java.math.BigDecimal(100))
                .longValue();

        String returnUrl = req.getScheme() + "://"
                + req.getServerName() + ":"
                + req.getServerPort()
                + req.getContextPath() + "/vnpay-return";

        Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmss");
        String createDate  = sdf.format(cld.getTime());
        cld.add(Calendar.MINUTE, 15);
        String expireDate  = sdf.format(cld.getTime());

        // Gộp tất cả params vào MỘT TreeMap duy nhất để tự động sort alphabet
        Map<String, String> vnp_Params = new TreeMap<>();
        vnp_Params.put("vnp_Version",    VnPayConfig.VNP_VERSION);
        vnp_Params.put("vnp_Command",    VnPayConfig.VNP_COMMAND);
        vnp_Params.put("vnp_TmnCode",    VnPayConfig.VNP_TMN_CODE);
        vnp_Params.put("vnp_Amount",     String.valueOf(amount));
        vnp_Params.put("vnp_CurrCode",   "VND");
        vnp_Params.put("vnp_TxnRef",     String.valueOf(orderId));
        vnp_Params.put("vnp_OrderInfo",  "ThanhToan_" + order.getOrderCode());
        vnp_Params.put("vnp_OrderType",  VnPayConfig.VNP_ORDER_TYPE);
        vnp_Params.put("vnp_Locale",     "vn");
        vnp_Params.put("vnp_ReturnUrl",  returnUrl);
        vnp_Params.put("vnp_IpAddr",     VnPayConfig.getIpAddress(req));
        vnp_Params.put("vnp_CreateDate", createDate);
        vnp_Params.put("vnp_ExpireDate", expireDate);



        // Build chuỗi Hash và Query
        List<String> hashParts  = new ArrayList<>();
        List<String> queryParts = new ArrayList<>();

        for (Map.Entry<String, String> entry : vnp_Params.entrySet()) {
            String name  = entry.getKey();
            String value = entry.getValue();
            if (value != null && !value.isEmpty()) {
                // ✅ Gọi hàm vnpEncode từ VnPayConfig
                String encodedValue = VnPayConfig.vnpEncode(value);
                String encodedName  = VnPayConfig.vnpEncode(name);

                hashParts.add(name + "=" + encodedValue);
                queryParts.add(encodedName + "=" + encodedValue);
            }
        }

        String hashData    = String.join("&", hashParts);
        String secureHash  = VnPayConfig.hmacSHA512(VnPayConfig.VNP_HASH_SECRET, hashData);
        String queryString = String.join("&", queryParts);

        return VnPayConfig.VNP_URL
                + "?" + queryString
                + "&vnp_SecureHash=" + secureHash;
    }
}