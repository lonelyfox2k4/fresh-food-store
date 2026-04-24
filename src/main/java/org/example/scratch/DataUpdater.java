package org.example.scratch;

import org.example.dao.NewsArticleDAO;
import org.example.model.content.NewsArticle;

public class DataUpdater {
    public static void main(String[] args) {
        NewsArticleDAO dao = new NewsArticleDAO();

        // 1. Xóa bài cũ
        System.out.println("Deleting News ID 11: " + dao.deleteNews(11));
        System.out.println("Deleting News ID 12: " + dao.deleteNews(12));

        // 2. Thêm bài mới hoàn chỉnh (Status = 2: Published)
        
        // Bài 1
        NewsArticle n1 = new NewsArticle();
        n1.setTitle("5 Bí Quyết Chọn Thịt Bò Tươi Ngon Chuẩn VietGAP");
        n1.setSummary("Làm thế nào để phân biệt thịt bò tươi và thịt bò đã qua xử lý? Fresh Food chia sẻ 5 dấu hiệu nhận biết cực đơn giản giúp bạn luôn có bữa ăn chất lượng.");
        n1.setContent("Thịt bò là thực phẩm giàu dinh dưỡng, nhưng việc chọn được miếng thịt tươi không phải ai cũng biết. \n\n1. Màu sắc: Thịt bò tươi phải có màu đỏ tươi, không đỏ sẫm.\n2. Độ đàn hồi: Khi ấn tay vào miếng thịt, vết lõm phải biến mất ngay lập tức.\n3. Mùi: Không có mùi hôi hay mùi lạ...\n4. Mỡ: Mỡ bò tươi thường có màu trắng ngà hoặc vàng nhạt.\n5. Thớ thịt: Chọn thớ thịt nhỏ, mịn sẽ mềm hơn khi nấu.");
        n1.setImageUrl("https://images.unsplash.com/photo-1544025162-d76694265947?ixlib=rb-4.0.3&auto=format&fit=crop&w=1169&q=80");
        n1.setStatus((byte)2);
        n1.setCreatedByAccountId(1L);
        System.out.println("Adding News 1: " + dao.createNews(n1));

        // Bài 2
        NewsArticle n2 = new NewsArticle();
        n2.setTitle("Rau Xanh Mùa Hè: Cách Bảo Quản Tươi Lâu Đến 7 Ngày");
        n2.setSummary("Thời tiết nắng nóng khiến rau củ nhanh héo. Hãy cùng khám phá bí quyết bọc giấy báo và túi zip để rau luôn xanh giòn như lúc mới mua.");
        n2.setContent("Để rau không bị héo úa trong tủ lạnh suốt cả tuần, hãy làm theo các bước sau:\n\n- Loại bỏ phần lá sâu, úng nhưng không được rửa rau trước khi cất.\n- Sử dụng túi zip hoặc hộp nhựa kín để giữ ẩm.\n- Đặc biệt, lót thêm một lớp giấy thấm sẽ giúp hút bớt hơi nước thừa, giữ rau không bị thối nhũn.");
        n2.setImageUrl("https://images.unsplash.com/photo-1566385101042-1a000c1267c4?ixlib=rb-4.0.3&auto=format&fit=crop&w=1332&q=80");
        n2.setStatus((byte)2);
        n2.setCreatedByAccountId(1L);
        System.out.println("Adding News 2: " + dao.createNews(n2));

        // Bài 3
        NewsArticle n3 = new NewsArticle();
        n3.setTitle("Chế Độ Ăn 'Clean Eating' Cùng Thực Phẩm Sạch");
        n3.setSummary("Clean Eating không chỉ là giảm cân mà là một lối sống. Tìm hiểu cách kết hợp thịt nạc và rau organic vào bữa ăn hàng ngày để tăng cường sức đề kháng.");
        n3.setContent("Ăn sạch (Clean Eating) là việc ưu tiên thực phẩm ở dạng nguyên bản nhất.\n\n- Ưu tiên các loại thịt trắng, thịt nạc.\n- Ăn nhiều rau xanh và hoa quả ít đường.\n- Hạn chế gia vị và đường tinh luyện. Kết hợp cùng các sản phẩm từ Fresh Food Store để đảm bảo nguồn gốc sạch nhất nhé!");
        n3.setImageUrl("https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&auto=format&fit=crop&w=1153&q=80");
        n3.setStatus((byte)2);
        n3.setCreatedByAccountId(1L);
        System.out.println("Adding News 3: " + dao.createNews(n3));
    }
}
