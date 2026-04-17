<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thiết lập Voucher mới | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container py-3">
    <div class="mb-4">
        <a href="voucher" class="btn btn-sm btn-light text-muted border-0 shadow-sm"><i class="bi bi-arrow-left"></i> Quay lại</a>
    </div>
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0 fw-bold">🎫 Tạo Chiến Dịch Voucher Mới</h5>
                </div>
                <div class="card-body p-4">
                    <form action="voucher" method="POST">
                        <input type="hidden" name="action" value="create">

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Mã Voucher (Code)</label>
                                <input type="text" name="voucherCode" class="form-control" placeholder="VD: UUDAI2026" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Tên chương trình</label>
                                <input type="text" name="voucherName" class="form-control" placeholder="VD: Giảm giá rau sạch hè" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Loại giảm giá</label>
                                <select name="discountType" class="form-select">
                                    <option value="1">Giảm theo %</option>
                                    <option value="2">Giảm theo tiền mặt</option>
                                </select>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Giá trị giảm</label>
                                <input type="number" name="discountValue" class="form-control" placeholder="Số % hoặc số tiền" required>
                            </div>
                            <div class="col-md-4 mb-3">
                                <label class="form-label fw-bold">Số lượng phát hành</label>
                                <input type="number" name="usageLimit" class="form-control" placeholder="Tổng số lượt dùng" required>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Đơn tối thiểu (Min order)</label>
                                <input type="number" name="minOrderAmount" class="form-control" value="0">
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Giảm tối đa (Max discount)</label>
                                <input type="number" name="maxDiscountAmount" class="form-control" value="1000000">
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Thời gian bắt đầu</label>
                                <input type="datetime-local" name="startAt" class="form-control" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label class="form-label fw-bold">Thời gian kết thúc</label>
                                <input type="datetime-local" name="endAt" class="form-control" required>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Ghi chú gửi Admin (Lý do tạo voucher)</label>
                            <textarea name="requestNote" class="form-control" rows="2" placeholder="Ví dụ: Xin duyệt mã giảm giá cho ngày lễ 30/4"></textarea>
                        </div>

                        <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                            <a href="voucher" class="btn btn-light px-4">Hủy bỏ</a>
                            <button type="submit" class="btn btn-success btn-lg px-5">Phát hành Voucher</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>