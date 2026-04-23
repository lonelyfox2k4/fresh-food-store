# 📍 Bản đồ Code (Code Mapping Guide): Staff & Shipper Modules

Tài liệu này đóng vai trò như một chiếc "Bản đồ kho báu", chỉ đích danh **Đường dẫn File (Path)** và **Vị trí Dòng Code (Line Numbers)** cho mọi tính năng bạn đã xây dựng. Hãy mở thẻ tệp tương ứng trong IDE (VS Code / IntelliJ) của bạn để đối chiếu trực tiếp nhé!

---

## 1. 🛡️ Module Phân Quyền & Điều Hướng (Authorization & Routing)

**Đâu là nơi chuyển hướng hệ thống ngay khi Đăng nhập xong?**
- **File:** `src\main\java\org\example\controller\AuthController.java`
- **Dòng Code:** `89 - 125` (Bên trong hàm `doPost` xử lý Đăng nhập)
- **Giải thích:** Sử dụng khối lệnh `switch (roleId)`. Nếu `roleId = 3`, gọi lệnh `resp.sendRedirect(contextPath + "/staff/orders")`.

**Đâu là nơi chuyển hướng nếu Đăng nhập bằng Google?**
- **File:** `src\main\java\org\example\controller\LoginGoogleController.java`
- **Dòng Code:** `80 - 100` 
- **Giải thích:** Logic hoàn toàn tương tự `AuthController`, ngăn chặn triệt để ai có ý định vòng qua hệ thống Google Login.

---

## 2. 🎟️ Module Quản lý Voucher (Voucher Management)

**Hệ thống chặn quyền "Tạo Voucher" của các Role khác như thế nào?**
- **Tại Cấp độ Giao diện (UI):** 
  - **File:** `src\main\webapp\staff\voucher-list.jsp`
  - **Dòng Code:** `36 - 40` (`<c:if test="${sessionScope.user.roleId == 3}">...`)
- **Tại Cấp độ Lõi (Controller - Chống Hack Link):**
  - **File:** `src\main\java\org\example\controller\VoucherServlet.java`
  - **Dòng Code:** `43 - 50` (Case `"create"`) chặn đứng mọi Request nếu `u == null || u.getRoleId() != 3`.

**Thuật toán "Khóa Xóa" Voucher đang chạy (Running) nằm ở đâu?**
- **Tại UI:** 
  - **File:** `src\main\webapp\staff\voucher-list.jsp`
  - **Dòng Code:** `109 - 117`. Dùng thẻ `<c:choose>` để quyết định: Nếu Voucher đó có `status == 1`, render ra icon "Disabled" màu xám, ngược lại render Form bấm nút Xóa.
- **Tại Controller:**
  - **File:** `VoucherServlet.java`
  - **Dòng Code:** `52 - 58` (Case `"delete"`). Ném trả ngoại lệ nếu `targetVoucher.getStatus() != 0`.

---

## 3. 📰 Module Tin tức & Truyền thông (News Article)

**Trình soạn thảo văn bản xịn sò (TinyMCE) được nhúng ở đâu?**
- **File:** `src\main\webapp\staff\news-form.jsp`
- **Dòng Code:** `89 - 100` (Phần rễ `<script>` dưới cùng trang)
- **Giải thích:** Hệ thống "móc" vào thẻ `<textarea name="content">` bằng Selector của Javascript, hô biến nó thành trình duyệt soạn thảo siêu ngầu kèm các tính năng (Bold, Italic, Căn Lề).

---

## 4. 💌 Module Phản hồi Khách hàng (Feedback Management)

**Khi Staff bấm gửi "Reply" câu trả lời, Code xử lý ở đâu?**
- **File:** `src\main\java\org\example\controller\FeedbackServlet.java`
- **Dòng Code:** `34 - 51` (Bên trong hàm `doPost`, lấy `responseText` và `staffId` từ người đang lưu phiên đăng nhập thực hiện lệnh Update xuống Database).

---

## 5. 🚚 Module Giao Hàng & Bàn Giao Quỹ (Shipper Module)

**Hành vi "Giao lại đơn" (Redeliver) cấu hình trong SQL như thế nào?**
- **File:** `src\main\java\org\example\dao\OrderDAO.java`
- **Dòng Code:** `846 - 857` (Phương thức `redeliverOrder(long orderId)`)
- **Giải thích:** Chạy lệnh UPDATE SQL đẩy `orderStatus = 3` (Đóng gói xong lại), đồng thời **TẨY TRẮNG** (`NULL`) các cột như `shipperId`, `cancelledAt` để đơn hàng quay trở về guồng máy phân phối từ đầu.

**5 Thẻ thống kê (Dashboard) của Shipper lấy dữ liệu tự động từ đâu?**
- **File:** `src\main\java\org\example\dao\OrderDAO.java`
- **Dòng Code:** `860 - 895` (Phương thức `getShipperStats(long shipperId)`)
- **Giải thích:** Sử dụng độc nhất 1 câu SQL gom nhóm đẳng cấp: `SUM(CASE WHEN shippingStatus = 3 AND paymentStatus = 2 THEN totalAmount ELSE 0 END) AS totalEarnings`. Nhờ câu SQL này mà chúng ta không cần tính tay rườm rà.

**Chức năng sống còn: Nút "Bàn Giao Tiền" (Remit C.O.D) làm cái gì?**
- **File:** `src\main\java\org\example\dao\OrderDAO.java`
- **Dòng Code:** `897 - 904` (Phương thức `remitCOD(long shipperId)`)
- **Giải thích:** UPDATE gán `paymentStatus = 3` cho ĐÚNG DUY NHẤT các đơn thuộc về tay Shipper đó mà đã đi giao xong (`shippingStatus = 3`) và Tiền Mặt đang nằm trong túi Shipper (`paymentStatus = 2`). Từ đó, biến số nợ hệ thống ngầm trên Dashboard rớt về mốc 0 VNĐ.

---
*Mẹo nhỏ khi Review: Hãy bấm chia ngoặc cửa sổ IDE (Split Tab). Một bên bật file này, một bên bật Java Source Code để "Trỏ tay - Đọc Code" cực lướt nhé!*
