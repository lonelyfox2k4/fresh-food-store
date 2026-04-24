# 🚀 Cẩm nang Sinh tồn: Code Review Module Staff & Shipper

Chào mừng bạn đến với tài liệu ôn tập và chuẩn bị "bảo vệ" Code. Để tự tin 100% trước bất kỳ câu hỏi nào của Mentor/Giảng viên/Team Leader vào ngày mai, bạn chỉ cần nắm vững bộ khung tư duy dưới đây. Tài liệu này được thiết kế để bạn "học tủ" hiểu sâu vào trọng tâm của thứ mình thực sự đang làm.

---

## 🧭 1. Kiến trúc tổng quan (Mô hình MVC)
Dự án "Fresh Food Store" đang vận hành bằng kiến trúc **MVC (Model - View - Controller)** kết hợp với **JSP/Servlet** thuần.

- **Model (DAO & Entities):** Thu thập, tính toán dữ liệu trực tiếp từ SQL Server. Nằm trong `org.example.dao` (VD: `OrderDAO`, `VoucherDAO`).
- **View (JSP):** Chịu trách nhiệm hiển thị giao diện. Nằm trong thư mục `/src/main/webapp/staff/` và `/src/main/webapp/shipper/`. Tại đây, bạn dùng JSTL (`<c:forEach>`, `<c:if>`) để render các biến đổ về từ Servlet.
- **Controller (Servlet):** Nơi xử lý Login, tiếp nhận thao tác người dùng (nhấn nút, nộp form) và điều hướng. Nằm trong `org.example.controller`.

---

## 🔒 2. Cơ chế phân quyền (Authorization)
Điều đầu tiên bạn có thể bị hỏi: *"Làm sao hệ thống biết ai là Staff, ai là Shipper để khóa các chức năng?"*

> **Điểm then chốt:** Dự án sử dụng `roleId` trong Entity `Account` quy đổi thứ bậc như sau:
> - `roleId == 3`: **Staff** (Nhân viên Cửa hàng)
> - `roleId == 4`: **Shipper** (Nhân viên Giao hàng)

- **Tại Controller (Bảo mật Back-end):**
  Trong `AuthController.java` hoặc `LoginGoogleController`, ngay khi bắt được User ID đăng nhập, hệ thống lập tức chĩa nhánh `if-else` tự động ném ông Staff vào `staff/orders` và tống Shipper sang `shipper/orders`.
- **Bảo mật ngầm ở Voucher:** Trong `VoucherServlet`, dù người ta có cố tình gõ link `voucher?action=create`, thì Servlet vẫn chặn: `if (user == null || user.getRoleId() != 3)` (Manager hay Shipper đều bị chặn lại).

---

## 👩‍💼 3. Trọng tâm Code: Module Staff
Staff là vị trí "chăm khách, đẩy sale", bạn cần nắm 4 mảng quản lý chính:

### a) Order Management (Bán Hàng)
- **Kịch bản:** Xác nhận hóa đơn đợi xử lý, bốc hàng và gán đơn cho Shipper, hoặc thao tác "Hoàn tiền thủ công" (Refund) cho các đơn VNPAY bị hủy.
- **DAO chịu trách nhiệm:** `OrderDAO`.
- **Câu hỏi ngầm định:** "Khi ấn Xác nhận (Confirm), số lượng tồn kho (Stock) giải quyết thế nào?" -> Phải cập nhật trừ `stockQuantity` ở `ProductDAO` luôn ngay lúc xác nhận.

### b) Voucher Management (Marketing)
Dùng `VoucherServlet.java` kết nối với file `voucher-list.jsp`.
> **Cực Điểm:**
> Đây là Code do bạn cất công sửa, lúc review hãy show diễn ra:
> - **BR-01:** Phân quyền cứng chỉ RoleId=3 (Staff) mới gọi được hàm tạo Voucher.
> - **BR-02 (Logic An Toàn Cốt Lõi):** Voucher đang chạy (Status = 1) thì tuyệt đối File `VoucherServlet.java` (hàm Delete) sẽ gạt bỏ, chống xóa để bảo vệ dữ liệu giỏ hàng của Khách Hàng. UI tự động xám màu cờ-lê/thùng-rác dựa trên (`if v.status == 1`). 

### c) News Article Management (Bảng tin CMS)
- **Công nghệ nổi bật:** Tích hợp **TinyMCE** nằm trong file `news-form.jsp`. HTML do người dùng bôi đậm, in nghiêng sẽ được lưu y chang dạng mã HTML `<p>...</p>` xuống Database (Cột `content` NVARCHAR(MAX)).

### d) Feedback Management (Chăm sóc)
- Tính logic: Data từ form liên hệ gửi xuống. Ở `FeedbackServlet.java`, Staff thao tác "Reply". Khi Staff trả lời, nó lưu chuỗi text vào DB và gán Label (Nhãn) màu xanh `Status = 1` (Đã xử lý).

---

## 🚚 4. Trọng tâm Code: Module Shipper
Shipper có luồng chạy Code cô đọng nhưng mang tính sống còn đối với luồng tiền của Công ty. Tập trung vào `ShipperOrderServlet.java` và `/shipper/order-list.jsp`.

### a) Màn hình 5 Thẻ Thống Kê (Dashboard)
Trong `OrderDAO`, phương thức `getShipperStats(long shipperId)` thực hiện lệnh Query gộp `SUM(CASE WHEN...)` cực ngầu để moi ra 5 chỉ số: Tổng đơn, Đơn thành công, Đơn đang giữ, **Tiền C.O.D đã thu**, và Tiền đã nộp. Mọi thứ được gói gọn trong cấu trúc `Map<String, Object>`. Bạn lấy thẻ đó vứt ra ngoài JSP hiển thị cực kỳ dễ dàng.

### b) Flow Trạng thái Đơn chạy từ Shipper
Luật cứng: Shipper chỉ thấy đơn có `shipperId` là chính CỦA MÌNH. Không được lấy trộm đơn thằng khác rước về.
Shipper bấm nút "Giao hàng thành công" (`shippingStatus = 3`):
- Hệ thống đẩy `paymentStatus = 2` (Đã thanh toán cho Shipper). Nghĩa là Cửa hàng đang hiểu là: Xin lưu ý Shipper đang cầm tiền mặt khách đưa đấy nhé. Nợ cửa hàng sẽ tự nhảy số âm.

### c) Bàn giao Quỹ (Remit COD)
> **Hỏi xoáy:** Chức năng Remit COD hoạt động ntn?
> - **Trả lời Review Code:** "Em viết hàm `remitCOD(shipperId)` trong DAO kết nối UPDATE các Orders thỏa mãn điều kiện `shipperId = X` VÀ `shippingStatus = 3 (Đã phát xong)` VÀ `paymentStatus = 2 (Shipper đang giữ tiền)`. Sau khi bấm, DB đổi `paymentStatus = 3` (Store đã thụ nhận tiền), lập tức các biến số nợ trên thẻ Dashboard bị reset về 0 hoàn hảo!"

---

## 💡 5. Q&A: Tự "Defend" trước lúc bị Reviewer quật

1. **Reviewer:** *"Em dùng công nghệ gì để chia Layout cho trang Staff gọn gàng vậy?"*
   - **Bạn đáp:** "Em tách các thanh Menu và Header ra các file tĩnh `nav.jsp` và `header.jsp` ở thư mục Components, sau đó dùng `<jsp:include page="..." />` nhét vào (Module hóa HTML), vì vậy nếu em muốn đổi màu nút ở Menu, toàn bộ 10 trang của Staff tự động cập nhật ngay lập tức!"
   
2. **Reviewer:** *"Tại sao nút Thêm Voucher mới biến mất khỏi tài khoản Manager?"*
   - **Bạn đáp:** "Em bọc nút bằng hàm JSTL ở FE: `<c:if test="${sessionScope.user.roleId == 3}">` và cài ngầm ở BackEnd `if (roleId != 3) throw Exception;`. Chống luôn cả Postman hack API."

3. **Reviewer:** *"Luồng giao lại (Redeliver) Shipper nó hoạt động ở CSDL sao?"*
   - **Bạn đáp:** "Lệnh `redeliverOrder` sẽ set `shipperId = NULL`, quét hết dòng lý do Hủy cũ về `NULL` và đẩy trạng thái đơn quay đầu về `Status 3` (Đã đóng gói) để quay vào ô đợi Staff phân Shipper khác đi đợt 2."

---
*Chúc bạn có một buổi Code Review ngày mai quét sạch mọi điểm A+ nhé!*
