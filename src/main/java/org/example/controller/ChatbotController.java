package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.example.dao.CategoryDAO;
import org.example.dao.OrderDAO;
import org.example.dao.ProductDAO;
import org.example.dao.VoucherDAO;
import org.example.model.auth.Account;
import org.example.model.catalog.Category;
import org.example.model.catalog.Product;
import org.example.model.marketing.Voucher;
import org.example.model.order.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.BufferedReader;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet("/api/chatbot")
public class ChatbotController extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final OrderDAO orderDAO = new OrderDAO();
    private final VoucherDAO voucherDAO = new VoucherDAO();
    private final Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json; charset=UTF-8");

        StringBuilder buffer = new StringBuilder();
        BufferedReader reader = req.getReader();
        String line;
        while ((line = reader.readLine()) != null) {
            buffer.append(line);
        }

        String userMessage = "";
        try {
            JsonObject payload = gson.fromJson(buffer.toString(), JsonObject.class);
            if (payload != null && payload.has("message") && !payload.get("message").isJsonNull()) {
                userMessage = payload.get("message").getAsString().toLowerCase().trim();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        HttpSession session = req.getSession(false);
        Account user = (session != null) ? (Account) session.getAttribute("user") : null;
        
        String botReply = generateResponse(userMessage, user);

        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("reply", botReply);
        resp.getWriter().write(gson.toJson(responseJson));
    }

    private String generateResponse(String message, Account user) {
        String helpGuide = "✨ **BẠN CẦN MÌNH GIÚP GÌ HÔNG NÈ?**\n"
                + "🔎 **Tìm món ngon**: Gõ 'Giá [tên món]' hoặc 'Tìm [tên món]' nha.\n"
                + "📦 **Xem đơn hàng**: Gõ 'Đơn hàng' để mình check trạng thái cho.\n"
                + "🎁 **Săn Voucher**: Gõ 'Mã giảm giá' để lấy quà nè.\n"
                + "🆕 **Hàng mới về**: Gõ 'Có gì mới' để xem đồ tươi hôm nay.\n"
                + "📍 **Địa chỉ**: Gõ 'Liên hệ' để biết shop ở đâu nha.\n"
                + "---------------------------\n"
                + "🌿 *Cứ nhắn tin cho mình, mình đợi bạn đó!*";

        if (message.isEmpty() || message.equals("hướng dẫn") || message.equals("help") || message.equals("?")) {
            return "Dạ chào " + (user != null ? "**" + user.getFullName() + "** " : "") + "ạ! 👋\n"
                 + "Mình là **Bé Bot Tươi Xanh** đây, rất vui được gặp bạn! ✨\n\n" + helpGuide;
        }

        // Logic 0: Kiểm tra đơn hàng
        if (message.contains("đơn hàng") || message.contains("đang ở đâu") || message.contains("giao chưa")) {
            if (user == null) {
                return "Bạn ơi, bạn đăng nhập giúp mình để mình vào kho tìm đơn hàng của bạn mới được nha! 🔑✨";
            }
            List<Order> latestOrders = orderDAO.getLatestOrdersByAccount(user.getAccountId(), 3);
            if (latestOrders.isEmpty()) {
                return "Hix, mình chưa thấy đơn hàng nào của bạn hết. Bạn đi shopping một vòng rồi quay lại đây nha! 🛒💨";
            }
            StringBuilder sb = new StringBuilder("Dạ, mình tìm thấy 3 đơn hàng gần nhất của bạn đây nè:\n");
            for (Order o : latestOrders) {
                sb.append("📦 **").append(o.getOrderCode()).append("**: ").append(getStatusName(o.getOrderStatus()))
                  .append(" (").append(getPaymentStatusName(o.getPaymentStatus())).append(")\n");
            }
            sb.append("\nBạn vào mục 'Lịch sử mua hàng' để xem chi tiết hơn nha!");
            return sb.toString();
        }

        // Logic 1: Hỏi về danh mục
        if (message.contains("danh mục") || message.contains("loại") || message.contains("category")) {
            List<Category> cats = categoryDAO.getAllActiveCategories();
            if (cats.isEmpty()) return "Dạ hiện tại kệ hàng nhà mình đang trống, bạn đợi mình xíu nha!";
            StringBuilder sb = new StringBuilder("Nhà mình đang có sẵn các loại thực phẩm tươi ngon này nè:\n");
            for (Category c : cats) {
                sb.append("✅ ").append(c.getCategoryName()).append("\n");
            }
            sb.append("\nBạn thích loại nào thì cứ nhắn mình tìm giá cho nhé!");
            return sb.toString();
        }

        // Logic 2: Hỏi về liên hệ
        if (message.contains("liên hệ") || message.contains("hotline") || message.contains("địa chỉ") || message.contains("cửa hàng")) {
            return "🏠 **Fresh Food Store** đây ạ!\n📍 Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM\n📞 Hotline: 1900 1234 (Gọi mình ngay nếu cần nha!)\n✉️ Email: cskh@freshfood.vn\n\nRất mong được đón tiếp bạn tại cửa hàng!";
        }

        // Logic 3: Voucher / Khuyến mãi
        if (message.contains("khuyến mãi") || message.contains("voucher") || message.contains("giảm giá") || message.contains("mã")) {
            List<Voucher> vouchers = voucherDAO.getActiveVouchers();
            if (vouchers.isEmpty()) return "Tiếc quá, hiện tại mình chưa có mã giảm giá mới. Bạn quay lại thăm mình sau nha! 🥺";
            StringBuilder sb = new StringBuilder("Aha! Mình đang giữ mấy mã giảm giá siêu hời cho bạn đây:\n");
            for (Voucher v : vouchers) {
                String type = (v.getDiscountType() == 1) ? v.getDiscountValue() + "%" : NumberFormat.getCurrencyInstance(new Locale("vi", "VN")).format(v.getDiscountValue()).replace("₫", "VNĐ");
                sb.append("🎟️ Mã: **").append(v.getVoucherCode()).append("** - Giảm ").append(type).append("\n");
            }
            sb.append("\nSố lượng có hạn nên bạn dùng ngay kẻo hết nhé! 🎁✨");
            return sb.toString();
        }

        // Logic 4: Sản phẩm mới
        if (message.contains("mới") || message.contains("gợi ý") || message.contains("có gì ngon")) {
            List<Product> news = productDAO.getNewestProducts(3);
            if (news.isEmpty()) return "Hôm nay mình chưa có hàng mới về, nhưng đồ cũ vẫn rất tươi ngon đó nha!";
            StringBuilder sb = new StringBuilder("Gợi ý cho bạn 3 món vừa mới 'cập bến' nhà mình hôm nay:\n");
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            for (Product p : news) {
                String formattedPrice = currencyFormat.format(p.getBasePriceAmount()).replace("₫", "VNĐ");
                sb.append("✨ **").append(p.getProductName()).append("** - ").append(formattedPrice).append("\n");
            }
            sb.append("\nMua ngay cho nóng bạn ơi! 🥦🍅");
            return sb.toString();
        }

        // Logic 5: Hỏi về gía / tìm kiếm
        if (message.contains("giá") || message.contains("tìm") || message.contains("mua") || message.contains("bao nhiêu")) {
            String keyword = message
                    .replace("mức", "").replace("hỏi", "").replace("giá", "")
                    .replace("tìm", "").replace("mua", "").replace("bao nhiêu", "")
                    .replace("cho", "").replace("tiền", "").replace("của", "").trim();

            if (keyword.isEmpty()) {
                return "Bạn muốn tìm giá món nào thì nhắn tên món đó cho mình biết với nha! (Vd: 'Giá thịt heo')";
            }

            List<Product> products = productDAO.searchProductsByChatbot(keyword);
            if (products.isEmpty()) {
                return "Dạ mình tìm khắp kho rồi mà chưa thấy món '" + keyword + "'. Bạn thử tìm món khác giúp mình nha! 🥺";
            }

            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            StringBuilder sb = new StringBuilder("Mình tìm thấy mấy món này đúng ý bạn nè:\n");
            for (Product p : products) {
                String formattedPrice = currencyFormat.format(p.getBasePriceAmount()).replace("₫", "VNĐ");
                sb.append("🛒 **").append(p.getProductName()).append("** - ").append(formattedPrice).append("\n");
            }
            return sb.toString();
        }

        // Logic 6: Câu chào
        if (message.equals("hi") || message.equals("hello") || message.contains("chào")) {
            return "Dạ chào bạn! Mình là **Bé Bot Tươi Xanh**, rất vui được hỗ trợ bạn ngày hôm nay ạ! ✨\n\n" + helpGuide;
        }

        // Fallback
        return "Hix, câu này mình chưa hiểu lắm... Bạn gõ theo hướng dẫn bên dưới để mình giúp bạn nhanh hơn nha! 👇\n\n" + helpGuide;
    }

    private String getStatusName(byte status) {
        switch (status) {
            case 1: return "Chờ xác nhận";
            case 2: return "Đã xác nhận";
            case 3: return "Đang đóng gói";
            case 4: return "Đang giao";
            case 5: return "Hoàn thành";
            case 6: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    private String getPaymentStatusName(byte status) {
        switch (status) {
            case 1: return "Chưa thanh toán";
            case 2: return "Đã thanh toán";
            case 3: return "Lỗi thanh toán";
            case 4: return "Đã hoàn tiền";
            default: return "Không xác định";
        }
    }
}
