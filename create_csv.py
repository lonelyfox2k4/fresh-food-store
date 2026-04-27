import csv

data = [
    ["Mã TC", "Tên kịch bản", "Điều kiện", "Các bước thực hiện", "Kết quả mong đợi", "Kết quả thực tế (Hệ thống trả về)", "Trạng thái"],
    ["TC_01", "Đăng nhập thành công (Khách hàng)", "Tài khoản Customer hợp lệ", "Nhập Email & Mật khẩu đúng > Nhấn 'Đăng nhập'", "Chuyển hướng tới trang chủ (/home). Tạo Session đăng nhập.", "Đã khởi tạo Session user, chuyển hướng chính xác đến /home.", "Pass"],
    ["TC_02", "Đăng nhập thành công (Quản trị viên)", "Tài khoản Admin/Manager/Staff", "Nhập Email & Mật khẩu đúng > Nhấn 'Đăng nhập'", "Chuyển hướng đúng theo Role (VD: /admin/dashboard hoặc /manager/products).", "Chuyển hướng chính xác dựa vào Switch-case roleId trong code.", "Pass"],
    ["TC_03", "Bỏ trống thông tin", "", "Bỏ trống Email/Password > Nhấn 'Đăng nhập'", "Hiển thị thông báo lỗi yêu cầu không được bỏ trống.", "Hiển thị lỗi: 'Email và mật khẩu không được bỏ trống!'", "Pass"],
    ["TC_04", "Sai định dạng Email", "", "Nhập Email không có @ > Nhấn 'Đăng nhập'", "Hiển thị thông báo lỗi sai định dạng Email.", "Hiển thị lỗi: 'Định dạng Email không hợp lệ!'", "Pass"],
    ["TC_05", "Sai thông tin đăng nhập", "", "Nhập Email đúng, Pass sai (hoặc ngược lại)", "Hiển thị thông báo sai thông tin. Không cho đăng nhập.", "Hiển thị lỗi: 'Tài khoản hoặc mật khẩu không chính xác!'", "Pass"],
    ["TC_06", "Tài khoản bị khóa", "Trạng thái status = 0", "Nhập thông tin đúng > Nhấn 'Đăng nhập'", "Chặn đăng nhập, thông báo tài khoản đã bị khóa.", "Hiển thị lỗi: 'Tài khoản của bạn đã bị khóa! Vui lòng liên hệ quản trị viên.'", "Pass"],
    ["TC_07", "Email chưa xác thực (OTP)", "Chưa verify OTP khi đăng ký", "Nhập thông tin đúng > Nhấn 'Đăng nhập'", "Yêu cầu người dùng kiểm tra lại email hoặc xác thực.", "Hiển thị lỗi: 'Email của bạn chưa được xác thực! Vui lòng kiểm tra hộp thư.'", "Pass"],
    ["TC_08", "Login bằng Google", "", "Bấm nút Đăng nhập với Google > Chọn tài khoản", "Khởi tạo Session và chuyển hướng trang chủ mượt mà.", "Đăng nhập thành công, tạo/lưu thông tin qua LoginGoogleController.", "Pass"]
]

with open("c:/Users/LENOVO/Learn/FFS/fresh-food-store/Test_Cases_Login.csv", "w", encoding="utf-8-sig", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(data)
