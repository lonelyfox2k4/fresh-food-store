USE fresh_food_store;
GO

SET QUOTED_IDENTIFIER ON;
SET ANSI_NULLS ON;
GO

INSERT INTO dbo.Feedbacks (accountId, subject, content, status)
VALUES 
(2, N'Đơn hàng giao trễ', N'Tài xế giao hàng quá chậm, rau củ có dấu hiệu héo do đi ngoài đường lâu.', 0),
(2, N'Sản phẩm không đúng mô tả', N'Trong mô tả ghi là nho không hạt, nhưng tôi nhận được nho có hạt. Mong cửa hàng check lại.', 0),
(2, N'Thái độ Shipper tốt', N'Bạn nhân viên giao hàng gọi điện rất thân thiện, đồ thì đóng gói cẩn thận. Mình rất thích dịch vụ bên bạn.', 1),
(2, N'Rau củ dập nát', N'Hôm nay nhận thùng xà lách bị dập khá nhiều ở dưới đáy. Đề nghị cải thiện chất lượng thùng carton.', 0),
(2, N'Xin đổi điểm thành quà', N'Cho mình hỏi mình tích lũy được điểm rồi thì làm sao để quy đổi được ra Voucher giảm giá 50k?', 0),
(2, N'Lỗi thanh toán VNPAY', N'Lúc nãy thao tác thành công trừ tiền rồi mà tài khoản báo vẫn chưa xác nhận đơn, admin hỗ trợ mình với ạ.', 0);
GO
