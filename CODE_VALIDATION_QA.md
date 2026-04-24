# 🛡️ Tủ Câu Hỏi Code Review: Bí Kíp Về "Validate" (Xử Lý Kiểm Tra)

Trong bất cứ buổi bảo vệ Source Code nào, Mentor rất chuộng "vặn vẹo" các câu hỏi liên quan đến tính bảo mật và kiểm tra tính hợp lệ của dữ liệu (Validation). Bộ tủ câu hỏi này tập trung đúng vào các mạch máu của Staff & Shipper Modules!

---

## 💥 1. Phân biệt Validate Client-side và Server-side

> **Câu hỏi 1:** *"Trong Web của em, Client-side Validation và Server-side Validation hoạt động phối hợp với nhau thế nào?"*

**Cách Trả Lời "Ăn Điểm":**
- **Client-side (Phía Giao diện):** Nằm gọn bên trong các file `.jsp`. Ở màn hình tạo Tin tức (`news-form.jsp`), em có dùng thuộc tính HTML5 là `required` cho thẻ `<input>` (Tiêu đề) và `<textarea>` (Nội dung). Nó ngăn chặn người dùng từ việc nhấn Submit những Form rỗng tuếch, giúp giảm tải rác lên máy chủ.
- **Server-side (Phía Máy chủ Controller):** Ngược lại, Validation từ phía Server nằm ở các file `.java` Servlet. Vì hacker có thể qua mặt Client-side bằng Postman hoặc F12 (DevTools) và gỡ cái chữ `required` đó đi rồi truyền thẳng tệp tin lên. Buộc back-end Java của em phải kiểm thử lại các tham số. Nếu ai đó chọc link `Long.parseLong(request.getParameter("id"))` mà truyền số má sai lệch thì BackEnd sẽ trả thẳng báo lỗi chứ không chạy đi phá Data.

---

## 🕵️‍♂️ 2. Validate Quyền Lực Ẩn (Authorization Check)

> **Câu hỏi 2:** *"Bên giao diện, em đã ẩn (Hide) nút Thêm Voucher mới đối với Role không phải 3 (Ví dụ như Manager 2) bằng chức năng của JSTL. Nhưng nếu anh bắt được cái Link chức năng tạo Voucher đó rồi gửi lên dưới quyền tài khoản ID 2... Em chặn kiểu gì?"*

**Cách Trả Lời "Ăn Điểm":**
- Cười nửa miệng, và tự tin giơ File `VoucherServlet.java` -> `case "create":` ra.
- "Thưa anh/chị, giao diện JSTL chỉ lừa được mắt ruồi (Hiển thị UI). Còn về Mạch ngầm (Logic API), dòng `44-48` có đoạn Check quyền sống còn: 
`Account u = (Account) request.getSession().getAttribute("user");`
`if (u == null || u.getRoleId() != 3) { ... redirect('unauthorized'); }`. 
"Do vậy dẫu có hack kiểu gì mà cái Session Role của anh không đứng chữ số 3 (Nhân viên) thì Java em ném trả anh ra chuồng gà luôn lập tức."

---

## 🗝️ 3. Cấm Thuật Xóa Bản Ghi "Running" (Business Logic Validation)

> **Câu hỏi 3:** *"Khi một Voucher đã được chuyển sang chế độ Active (Chạy). Em Validate logic thế nào để không ai được XÓA ĐI, làm mất mã giảm giá giỏ hàng của khách?"*

**Cách Trả Lời "Ăn Điểm":**
- "Em dùng phương pháp **Chốt Khóa Dữ Kiện Tĩnh (Double Locking)**."
- Khóa 1 (Mắt): Ở file `voucher-list.jsp`, vòng lặp kiểm tra Cờ (Flag): `<c:if test="${v.status == 1}">`. Lúc này cái Icon hình thùng rác của giao diện thay vì bao bọc trong cái thẻ `<form Action="Delete">` thì nó chỉ xuất ra một biến ảo là cục Nút "Disable" màu Xám, nhấp chuột vô là vô giá trị.
- Khóa 2 (Máy chủ): Lỡ đâu có thằng hacker nhấp Link `action=delete&id=5`? Bên xử lý Java em gọi thẳng vào Database, soi xem cái Model Voucher ID=5 nó mang Status là 1 hay 0. Nếu `Voucher.getStatus() != 0`. Lệnh Xóa sẽ Auto-Break (Ngắt bỏ) để cấm phá hoại cơ sở dữ liệu hiện hữu.

---

## 🚫 4. Tình huống Shipper Nhận Sai Giá Trị Quỹ (Metric Validation - Extra Focus)

> **Câu hỏi 4:** *"Nếu một bác Shipper đi giao C.O.D. Nhưng bác đó không thu đồng nào hôm nay. Bác đó nổi hứng bấm "Remit Cash/Bàn giao quỹ" thì sao? Hệ thống em nổ hay vẫn chạy?"*

**Cách Trả Lời "Ăn Điểm":**
"Nó vẫn chạy mượt mà mà không nổ lỗi! Vì ở tầng Data Model (`OrderDAO`), câu Query hàm `remitCOD(shipperId)` của em yêu cầu khắt khe các điều kiện rẽ nhánh: `shippingStatus = 3` (Xong), và đặc biệt `paymentStatus = 2` (Đang giữ tiền). 
Nghĩa là nếu ổng không đụng vào đơn nào thành công (Không có tiền đang găm), thì Query Update trả về chả có đối tượng (0 rows affected). Metric tiền nong Reset từ 0 về thành 0 đồng, bảo đảm toàn vẹn tài chính nội tại. Đơn của đồng chí Shipper A thì Shipper B không thể nhúng tay Remit chéo (Do Check Khóa ID Account) trên Servlet."

---

## Mẹo Nhỏ Trả Lời Tổng Hợp Cho Mọi Tình Huống:
Khi bị hỏi gắt về "Có bắt lỗi đoạn ABC kia không?", hãy sử dụng công thức chung 3 Bước:
1. Em chặn Rỗng (Null) và Bắt Lỗi ở Màn Lưới Giao Diện HTML5.
2. Em Tái Kiểm Tra (Re-Validate) tính toàn vẹn Dữ Liệu ở Server-Side Java.
3. Em Khóa Ràng Buộc Nâng Cao (Status & Role Id Check) để chống người truy cập chéo.
