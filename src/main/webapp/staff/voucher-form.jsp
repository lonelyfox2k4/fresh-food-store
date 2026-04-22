<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thiết lập Voucher | Fresh Food Store</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
</head>
<body class="bg-light">
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="voucher" />
    </jsp:include>

    <div class="page-header mt-n2 mb-4">
        <div class="container-fluid px-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/voucher">Voucher</a></li>
                    <li class="breadcrumb-item active">Tạo mới</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">Thiết lập Voucher Mới</h2>
            <p class="text-white-50 small mb-0 mt-1">Cấu hình tham số khuyến mãi cho chiến dịch bán hàng.</p>
        </div>
    </div>

    <div class="container py-3">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary-subtle p-2 rounded-3 me-3">
                                <i class="bi bi-ticket-perforated-fill text-primary fs-4"></i>
                            </div>
                            <h5 class="mb-0 fw-bold">Thông tin chiến dịch</h5>
                        </div>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <c:if test="${not empty param.error}">
                            <div class="alert alert-danger border-0 shadow-sm mb-4 d-flex align-items-center">
                                <i class="fas fa-exclamation-triangle me-3 fs-4"></i>
                                <div>
                                    <c:choose>
                                        <c:when test="${param.error == 'duplicate_code'}"><strong>Lỗi:</strong> Mã voucher này đã tồn tại trong hệ thống.</c:when>
                                        <c:when test="${param.error == 'invalid_dates'}"><strong>Lỗi:</strong> Thời gian kết thúc phải sau thời gian bắt đầu.</c:when>
                                        <c:when test="${param.error == 'start_in_past'}"><strong>Lỗi:</strong> Thời gian bắt đầu không được ở trong quá khứ.</c:when>
                                        <c:when test="${param.error == 'invalid_percent'}"><strong>Lỗi:</strong> Giá trị giảm % phải từ 1 đến 100.</c:when>
                                        <c:when test="${param.error == 'discount_too_high'}"><strong>Lỗi:</strong> Số tiền giảm không được vượt quá giá trị đơn tối thiểu.</c:when>
                                        <c:when test="${param.error == 'code_length'}"><strong>Lỗi:</strong> Mã voucher phải dài từ 5 đến 15 ký tự.</c:when>
                                        <c:otherwise><strong>Lỗi:</strong> Đã có lỗi xảy ra. Vui lòng kiểm tra lại dữ liệu.</c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>

                        <form action="voucher" method="POST" class="needs-validation" novalidate>
                            <input type="hidden" name="action" value="create">

                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Mã Voucher (Code)</label>
                                    <div class="input-group has-validation">
                                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-barcode"></i></span>
                                        <input type="text" name="voucherCode" class="form-control border-start-0 ps-0" 
                                               placeholder="VD: UUDAI2026" required pattern="[A-Z0-9]{5,15}">
                                        <div class="invalid-feedback">Mã từ 5-15 ký tự, chỉ gồm chữ in hoa và số.</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Tên chương trình</label>
                                    <input type="text" name="voucherName" class="form-control" placeholder="VD: Giảm giá rau sạch hè" required minlength="5">
                                    <div class="invalid-feedback">Vui lòng nhập tên chương trình (tối thiểu 5 ký tự).</div>
                                </div>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-4">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Loại giảm giá</label>
                                    <select name="discountType" id="discountType" class="form-select bg-light border-0">
                                        <option value="1">Giảm theo %</option>
                                        <option value="2">Giảm theo tiền mặt</option>
                                    </select>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Giá trị giảm</label>
                                    <div class="input-group has-validation">
                                        <input type="number" name="discountValue" id="discountValue" class="form-control" placeholder="Nhập số %" required min="1">
                                        <span class="input-group-text bg-light border-0" id="discountUnit">%</span>
                                        <div class="invalid-feedback" id="discountValueFeedback">Vui lòng nhập giá trị giảm hợp lệ.</div>
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Số lượng phát hành</label>
                                    <input type="number" name="usageLimit" class="form-control" placeholder="Tổng số lượt dùng" required min="1">
                                    <div class="invalid-feedback">Vui lòng nhập số lượng tối thiểu là 1.</div>
                                </div>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Đơn tối thiểu (Min order)</label>
                                    <div class="input-group has-validation">
                                        <input type="number" name="minOrderAmount" class="form-control" value="0" min="0" required>
                                        <span class="input-group-text bg-light border-0">VNĐ</span>
                                        <div class="invalid-feedback">Vui lòng nhập giá trị lớn hơn hoặc bằng 0.</div>
                                    </div>
                                </div>
                                <div class="col-md-6" id="maxDiscountGroup">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Giảm tối đa (Max discount)</label>
                                    <div class="input-group has-validation">
                                        <input type="number" name="maxDiscountAmount" id="maxDiscountInput" class="form-control" value="100000" min="0">
                                        <span class="input-group-text bg-light border-0">VNĐ</span>
                                        <div class="invalid-feedback">Mức giảm tối đa là bắt buộc đối với loại voucher %.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Thời gian bắt đầu</label>
                                    <input type="datetime-local" name="startAt" class="form-control" required>
                                    <div class="invalid-feedback">Ngày bắt đầu không được để trống hoặc ở quá khứ.</div>
                                </div>
                                <div class="col-md-6">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Thời gian kết thúc</label>
                                    <input type="datetime-local" name="endAt" class="form-control" required>
                                    <div class="invalid-feedback">Vui lòng chọn ngày kết thúc và phải sau ngày bắt đầu.</div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small text-uppercase">Ghi chú lý do tạo voucher</label>
                                <textarea name="requestNote" class="form-control" rows="3" placeholder="Ghi chú đính kèm để Manager duyệt mã..."></textarea>
                            </div>

                            <div class="d-flex justify-content-between mt-5 pt-4 border-top">
                                <a href="voucher" class="btn btn-light px-4 py-2 rounded-pill shadow-sm">
                                    <i class="bi bi-x-lg me-2"></i>Hủy bỏ
                                </a>
                                <button type="submit" class="btn btn-brand px-5 py-2 rounded-pill shadow-lg">
                                    <i class="bi bi-send-check me-2"></i>Gửi yêu cầu phát hành
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.querySelector('form');
            const typeSelect = document.getElementById('discountType');
            const valueInput = document.getElementById('discountValue');
            const unitSpan = document.getElementById('discountUnit');
            const maxDiscountGroup = document.getElementById('maxDiscountGroup');
            const maxDiscountInput = document.getElementById('maxDiscountInput');
            const startInput = document.getElementsByName('startAt')[0];
            const endInput = document.getElementsByName('endAt')[0];
            const minOrderInput = document.getElementsByName('minOrderAmount')[0];

            // 1. DYNAMIC UI LOGIC
            function updateDisplay() {
                if (typeSelect.value === '1') { // Percentage
                    unitSpan.textContent = '%';
                    valueInput.placeholder = 'Nhập số % (VD: 10)';
                    valueInput.setAttribute('max', '100');
                    maxDiscountGroup.style.display = 'block';
                    maxDiscountInput.required = true;
                } else { // Flat Amount
                    unitSpan.textContent = 'VNĐ';
                    valueInput.placeholder = 'Nhập số tiền (VD: 50000)';
                    valueInput.removeAttribute('max');
                    maxDiscountGroup.style.display = 'none';
                    maxDiscountInput.required = false;
                    maxDiscountInput.value = valueInput.value; // Sync
                }
            }

            typeSelect.addEventListener('change', updateDisplay);
            valueInput.addEventListener('input', () => {
                if (typeSelect.value === '2') maxDiscountInput.value = valueInput.value;
            });
            updateDisplay();

            // 2. VALIDATION LOGIC
            form.addEventListener('submit', function(event) {
                let isValid = true;
                const errors = [];

                // Reset custom validations
                startInput.setCustomValidity('');
                endInput.setCustomValidity('');
                valueInput.setCustomValidity('');

                // Check Dates
                const start = new Date(startInput.value);
                const end = new Date(endInput.value);
                const now = new Date();

                if (start < now.setMinutes(now.getMinutes() - 10)) {
                    startInput.setCustomValidity('Thời gian bắt đầu không được ở trong quá khứ.');
                    isValid = false;
                }

                if (end <= start) {
                    endInput.setCustomValidity('Thời gian kết thúc phải sau thời gian bắt đầu.');
                    isValid = false;
                }

                // Check Flat Amount vs Min Order
                if (typeSelect.value === '2') {
                    const discount = parseFloat(valueInput.value);
                    const minOrder = parseFloat(minOrderInput.value);
                    if (discount >= minOrder && minOrder > 0) {
                        valueInput.setCustomValidity('Số tiền giảm phải nhỏ hơn giá trị đơn tối thiểu.');
                        isValid = false;
                    }
                }

                if (!form.checkValidity() || !isValid) {
                    event.preventDefault();
                    event.stopPropagation();
                }

                form.classList.add('was-validated');
            }, false);

            // 3. AUTO-SET MIN DATES
            const nowIso = new Date().toISOString().slice(0, 16);
            if (!startInput.value) startInput.min = nowIso;
        });
    </script>
</body>
</html>