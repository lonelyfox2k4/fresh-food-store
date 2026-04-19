<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thiết lập Voucher | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container py-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/staff/voucher"
           class="btn btn-sm btn-light border shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow">
                <div class="card-header bg-success text-white py-3">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi bi-ticket-perforated me-2"></i>Tạo Chiến Dịch Voucher Mới
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/staff/voucher" method="POST">
                        <input type="hidden" name="action" value="create">

                        <div class="row g-3">
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Mã Voucher <span class="text-danger">*</span></label>
                                <input type="text" name="voucherCode" class="form-control"
                                       placeholder="VD: UUDAI2026" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Tên chương trình <span class="text-danger">*</span></label>
                                <input type="text" name="voucherName" class="form-control"
                                       placeholder="VD: Giảm giá rau sạch hè" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label fw-bold">Loại giảm giá</label>
                                <select name="discountType" class="form-select">
                                    <option value="1">Giảm theo % (Phần trăm)</option>
                                    <option value="2">Giảm theo tiền mặt (đ)</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Giá trị giảm <span class="text-danger">*</span></label>
                                <input type="number" name="discountValue" class="form-control"
                                       placeholder="Số % hoặc số tiền" min="0" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label fw-bold">Số lượng phát hành <span class="text-danger">*</span></label>
                                <input type="number" name="usageLimit" class="form-control"
                                       placeholder="Tổng số lượt dùng" min="1" required>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Đơn hàng tối thiểu (đ)</label>
                                <input type="number" name="minOrderAmount" class="form-control" value="0" min="0">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Giảm tối đa (đ)</label>
                                <input type="number" name="maxDiscountAmount" class="form-control" value="1000000" min="0">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label fw-bold">Thời gian bắt đầu <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="startAt" class="form-control" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-bold">Thời gian kết thúc <span class="text-danger">*</span></label>
                                <input type="datetime-local" name="endAt" class="form-control" required>
                            </div>

                            <div class="col-12">
                                <label class="form-label fw-bold">Ghi chú gửi Admin</label>
                                <textarea name="requestNote" class="form-control" rows="2"
                                          placeholder="Ví dụ: Xin duyệt mã giảm giá cho ngày lễ 30/4"></textarea>
                                <div class="form-text text-muted">Lý do tạo voucher, sẽ được gửi đến Admin để xét duyệt.</div>
                            </div>
                        </div>

                        <div class="d-flex justify-content-between mt-4 pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/staff/voucher"
                               class="btn btn-light px-4">
                                <i class="bi bi-x me-1"></i>Hủy bỏ
                            </a>
                            <button type="submit" class="btn btn-success px-5 fw-bold">
                                <i class="bi bi-send-fill me-1"></i>Phát hành Voucher
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>