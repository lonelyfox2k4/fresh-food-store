<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Duyệt Voucher | Fresh Food</title>
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
        .request-card {
            border: none;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
            margin-bottom: 2rem;
            background: white;
        }
        .request-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1);
        }
        .voucher-badge {
            font-size: 1.25rem;
            font-weight: 800;
            color: var(--primary);
            background: var(--primary-light);
            padding: 0.5rem 1rem;
            border-radius: 12px;
            display: inline-block;
        }
        .btn-approve {
            background-color: #10b981;
            color: white;
            border-radius: 10px;
            font-weight: 600;
            padding: 0.6rem 1.25rem;
            border: none;
            transition: all 0.2s;
        }
        .btn-approve:hover {
            background-color: #059669;
            transform: scale(1.05);
            color: white;
        }
        .btn-reject {
            background-color: #ef4444;
            color: white;
            border-radius: 10px;
            font-weight: 600;
            padding: 0.6rem 1.25rem;
            border: none;
            transition: all 0.2s;
        }
        .btn-reject:hover {
            background-color: #dc2626;
            transform: scale(1.05);
            color: white;
        }
        .requester-info {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="marketing" />
</jsp:include>

<div class="page-header py-4" style="background: linear-gradient(135deg, #E3000F 0%, #ff4b50 100%); color: white; border: none;">
    <div class="container">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb mb-1">
                <li class="breadcrumb-item"><a href="#" class="text-white-50">Manager</a></li>
                <li class="breadcrumb-item active text-white" aria-current="page">Phê duyệt Voucher</li>
            </ol>
        </nav>
        <h2 class="fw-800 mb-1">Yêu cầu phát hành Voucher</h2>
        <p class="text-white-50 mb-0">Xem xét và phê duyệt các chiến dịch khuyến mãi từ nhân viên.</p>
    </div>
</div>

<div class="container mt-4 pb-5">
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm rounded-4 mb-4 p-3">
            <i class="fas fa-check-circle me-2"></i>
            ${param.msg == 'approved' ? 'Đã phê duyệt voucher thành công! Voucher hiện đã có thể sử dụng.' : 'Đã từ chối yêu cầu voucher.'}
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger border-0 shadow-sm rounded-4 mb-4 p-3">
            <i class="fas fa-exclamation-circle me-2"></i> Thao tác thất bại. Vui lòng thử lại.
        </div>
    </c:if>

    <div class="row">
        <c:forEach items="${voucherRequests}" var="req">
            <div class="col-12">
                <div class="request-card p-4">
                    <div class="row align-items-center">
                        <div class="col-lg-3 text-center text-lg-start mb-3 mb-lg-0 border-end">
                            <div class="voucher-badge mb-2">${req.voucher.voucherCode}</div>
                            <h5 class="fw-bold text-dark mb-1">${req.voucher.voucherName}</h5>
                            <div class="requester-info">
                                <img src="https://ui-avatars.com/api/?name=${req.requesterName}&background=E3000F&color=fff" 
                                     style="width: 24px; height: 24px; border-radius: 50%;">
                                <small class="text-muted">Từ: <span class="fw-600 text-primary">${req.requesterName}</span></small>
                            </div>
                        </div>
                        <div class="col-lg-3 mb-3 mb-lg-0 border-end">
                            <div class="d-flex align-items-center gap-3">
                                <div class="bg-primary-subtle p-3 rounded-4 text-primary">
                                    <i class="fas fa-percentage fs-3"></i>
                                </div>
                                <div>
                                    <div class="text-muted small">Chi tiết ưu đãi</div>
                                    <div class="fw-bold fs-4">
                                        <fmt:formatNumber value="${req.voucher.discountValue}" type="number"/>
                                        ${req.voucher.discountType == 1 ? '%' : 'đ'}
                                    </div>
                                    <div class="small text-muted">HĐ tối thiểu: <fmt:formatNumber value="${req.voucher.minOrderAmount}" type="number"/> đ</div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 mb-3 mb-lg-0">
                            <div class="row g-2">
                                <div class="col-6">
                                    <div class="small text-muted"><i class="fas fa-calendar-check me-1"></i> Bắt đầu</div>
                                    <div class="small fw-bold">${req.voucher.startAt}</div>
                                </div>
                                <div class="col-6">
                                    <div class="small text-muted"><i class="fas fa-calendar-times me-1"></i> Kết thúc</div>
                                    <div class="small fw-bold">${req.voucher.endAt}</div>
                                </div>
                                <div class="col-12 mt-2">
                                    <div class="p-3 bg-light rounded-4 small border">
                                        <i class="fas fa-paper-plane text-primary me-2"></i>
                                        <strong>Staff Note:</strong> ${req.requestNote}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-2 text-center text-lg-end">
                            <div class="d-grid gap-2">
                                <form action="voucher-requests" method="POST" class="m-0">
                                    <input type="hidden" name="requestId" value="${req.voucherRequestId}">
                                    <button type="submit" name="action" value="approve" class="btn btn-approve w-100 mb-2 py-2">
                                        <i class="fas fa-check me-2"></i> Duyệt
                                    </button>
                                    <button type="submit" name="action" value="reject" class="btn btn-reject w-100 py-2" 
                                            onclick="return confirm('Bạn có chắc chắn muốn từ chối yêu cầu này?')">
                                        <i class="fas fa-times me-2"></i> Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </c:forEach>

        <c:if test="${empty voucherRequests}">
            <div class="col-12 text-center py-5">
                <div class="mb-4">
                    <div class="bg-white p-5 d-inline-block rounded-circle shadow-sm">
                        <i class="fas fa-clipboard-check text-success" style="font-size: 4rem;"></i>
                    </div>
                </div>
                <h4 class="fw-bold text-dark">Tuyệt vời!</h4>
                <p class="text-muted">Không có yêu cầu voucher nào đang chờ bạn phê duyệt.</p>
                <a href="${pageContext.request.contextPath}/manager/products" class="btn btn-outline-primary rounded-pill px-4">
                    <i class="fas fa-arrow-left me-2"></i> Về quản lý sản phẩm
                </a>
            </div>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
