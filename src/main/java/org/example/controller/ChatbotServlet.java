package org.example.controller;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import org.example.dao.CategoryDAO;
import org.example.dao.ProductDAO;
import org.example.model.catalog.Category;
import org.example.model.catalog.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.List;
import java.util.Locale;

@WebServlet("/api/chatbot")
public class ChatbotServlet extends HttpServlet {

    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
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

        String botReply = generateResponse(userMessage);

        JsonObject responseJson = new JsonObject();
        responseJson.addProperty("reply", botReply);
        resp.getWriter().write(gson.toJson(responseJson));
    }

    private String generateResponse(String message) {
        if (message.isEmpty()) {
            return "Xin chào! Trợ lý ảo Fresh Food Store đây. Mình có thể giúp gì cho bạn hôm nay (hỏi về giá, danh mục, liên hệ)?";
        }

        // Logic 1: Hỏi về danh mục
        if (message.contains("danh mục") || message.contains("loại") || message.contains("category")) {
            List<Category> cats = categoryDAO.getAllActiveCategories();
            if (cats.isEmpty()) return "Hiện tại cửa hàng chưa có danh mục nào.";
            StringBuilder sb = new StringBuilder("Hiện tại cửa hàng mình đang có các nhóm mặt hàng sau:\n");
            for (Category c : cats) {
                sb.append("• ").append(c.getCategoryName()).append("\n");
            }
            sb.append("Bạn có thể nhắn 'tìm + tên món' để xem sản phẩm nhé!");
            return sb.toString();
        }

        // Logic 2: Hỏi về liên hệ
        if (message.contains("liên hệ") || message.contains("hotline") || message.contains("địa chỉ") || message.contains("cửa hàng")) {
            return "🏢 **Fresh Food Store**\n📍 Địa chỉ: 123 Đường ABC, Quận 1, TP.HCM\n📞 Hotline: 1900 1234\n✉️ Email: cskh@freshfood.vn\nRất hân hạnh được phục vụ bạn!";
        }

        // Logic 3: Hỏi về gía / tìm kiếm
        if (message.contains("giá") || message.contains("tìm") || message.contains("mua") || message.contains("bao nhiêu")) {
            // Loại bỏ các từ khóa thừa để lấy đúng keyword
            String keyword = message
                    .replace("mức", "")
                    .replace("hỏi", "")
                    .replace("giá", "")
                    .replace("tìm", "")
                    .replace("mua", "")
                    .replace("bao nhiêu", "")
                    .replace("cho", "")
                    .replace("tiền", "")
                    .replace("của", "")
                    .trim();

            if (keyword.isEmpty()) {
                return "Bạn muốn tra cứu giá của sản phẩm nào nhỉ? (Vd: 'giá thịt heo', 'tìm cá hồi')";
            }

            List<Product> products = productDAO.searchProductsByChatbot(keyword);
            if (products.isEmpty()) {
                return "Rất tiếc, mình không tìm thấy sản phẩm nào liên quan đến '" + keyword + "'. Bạn thử tìm từ khóa khác xem sao nha!";
            }

            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(new Locale("vi", "VN"));
            StringBuilder sb = new StringBuilder("Mình tìm thấy các sản phẩm sau:\n");
            for (Product p : products) {
                String formattedPrice = currencyFormat.format(p.getBasePriceAmount()).replace("₫", "VNĐ");
                sb.append("🛒 **").append(p.getProductName()).append("** - ").append(formattedPrice).append(" / ").append(p.getPriceBaseWeightGram()).append("g\n");
            }
            return sb.toString();
        }

        // Logic 4: Câu chào (Hi, hello, xin chào)
        if (message.equals("hi") || message.equals("hello") || message.contains("chào")) {
            return "Xin chào! Trợ lý ảo Fresh Food Store đây. Mình có thể hỗ trợ bạn tìm nhanh thông tin về sản phẩm, giá bán, danh mục hoặc liên hệ của cửa hàng ạ!";
        }

        // Fallback
        return "Xin lỗi, mình mới đi làm nên chưa hiểu rõ câu này lắm 🥲.\nBạn thử nhấn vào các gợi ý bên trên, hoặc dùng từ khóa như **'giá [tên món]'**, **'danh mục'** nha!";
    }
}
