<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thiết lập Voucher | Fresh Food</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
    <style>
        .main-card {
            background: white;
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
        }
        .form-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--slate-500);
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 0.5rem;
        }
        .form-control, .form-select {
            border: 1px solid var(--slate-200);
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            background-color: var(--slate-50);
            transition: all 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: var(--primary-light);
            background-color: white;
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }
        .btn-premium {
            padding: 0.75rem 1.5rem;
            border-radius: 0.75rem;
            font-weight: 600;
            transition: all 0.2s;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="voucher" />
</jsp:include>

<div class="container py-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/staff/voucher"
           class="btn btn-sm btn-light border shadow-sm">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="main-card p-4 p-md-5">
                <div class="mb-5 text-center">
                    <div class="bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center rounded-4 p-3 mb-3">
                        <i class="fas fa-ticket-alt fs-3"></i>
                    </div>
                    <h2 class="fw-bold fs-3 text-dark mb-1">Tạo Chiến Dịch Voucher Mới</h2>
                    <p class="text-secondary small">Điền các thông số chính sách để phát hành voucher.</p>
                </div>
                <div>
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

                        <div class="row g-3 mt-4">
                            <div class="col-md-4">
                                <a href="${pageContext.request.contextPath}/staff/voucher" class="btn btn-light w-100 btn-premium border-0">
                                    Hủy bỏ
                                </a>
                            </div>
                            <div class="col-md-8">
                                <button type="submit" class="btn btn-primary w-100 btn-premium shadow-lg fw-bold">
                                    <i class="fas fa-paper-plane me-2"></i>Phát hành Voucher
                                </button>
                            </div>
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