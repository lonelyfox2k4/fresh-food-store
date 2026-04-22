<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container-fluid py-3 px-4">
    <div class="mb-4">
        <h3 class="fw-bold"><i class="bi bi-chat-dots me-2"></i>Phản hồi khách hàng</h3>
        <p class="text-muted small">Xem và trả lời đánh giá từ người mua hàng.</p>
    </div>
    <div class="card border-0 shadow-sm">
        <table class="table table-striped align-middle mb-0">
            <thead class="table-dark">
            <tr>
                <th class="ps-4">Khách hàng</th>
                <th>Đơn hàng</th>
                <th>Nội dung</th>
                <th>Đánh giá</th>
                <th>Trạng thái</th>
                <th class="text-center">Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${feedbackList}" var="f">
                <tr>
                    <td class="ps-4">
                        <div class="fw-bold fs-6">${f.customerName}</div>
                        <small class="text-muted"><i class="bi bi-clock"></i> ${f.createdAt.toString().replace('T', ' ').substring(0, 16)}</small>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${not empty f.orderCode}">
                                <a href="orders?action=detail&id=${f.orderId}&from=feedback" class="text-decoration-none fw-bold">
                                    <i class="bi bi-receipt"></i> #${f.orderCode}
                                </a>
                            </c:when>
                            <c:otherwise><span class="text-muted small">N/A</span></c:otherwise>
                        </c:choose>
                    </td>
                    <td style="max-width: 300px;">
                        <div class="text-truncate" title="${f.content}">${f.content}</div>
                    </td>
                    <td class="text-warning">
                        <c:forEach begin="1" end="${f.rating}"><i class="bi bi-star-fill"></i></c:forEach>
                        <c:forEach begin="${f.rating + 1}" end="5"><i class="bi bi-star text-muted"></i></c:forEach>
                    </td>
                    <td>
                        <c:if test="${f.status == 0}">
                            <span class="badge bg-warning text-dark"><i class="bi bi-hourglass-split"></i> Chờ trả lời</span>
                        </c:if>
                        <c:if test="${f.status == 1}">
                            <span class="badge bg-success"><i class="bi bi-check-all"></i> Đã phản hồi</span>
                        </c:if>
                    </td>
                    <td class="text-center">
                        <button class="btn btn-primary btn-sm rounded-pill px-3 shadow-sm" data-bs-toggle="modal" data-bs-target="#replyModal${f.feedbackId}">
                            <i class="bi bi-reply"></i> Phản hồi
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<c:forEach items="${feedbackList}" var="f">
    <div class="modal fade" id="replyModal${f.feedbackId}" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="feedback" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title">Trả lời #${f.feedbackId}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="feedbackId" value="${f.feedbackId}">
                        <div class="alert alert-light border small py-2 mb-3">
                            <strong>Khách viết:</strong> <br>
                            <i class="text-muted">"${f.content}"</i>
                        </div>
                        
                        <c:if test="${not empty f.itemList}">
                            <div class="mb-3">
                                <label class="form-label small text-uppercase text-muted fw-bold">Sản phẩm đã mua:</label>
                                <div class="list-group list-group-flush border rounded overflow-hidden">
                                    <c:forEach items="${f.itemList}" var="item">
                                        <div class="list-group-item list-group-item-light d-flex justify-content-between align-items-center py-1 small">
                                            <span>${item.productNameSnapshot} <small class="text-muted">(${item.packWeightGramSnapshot}g)</small></span>
                                            <span class="badge bg-secondary rounded-pill">x${item.orderedQuantity}</span>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>
                        
                        <div class="mb-3">
                            <label class="form-label fw-bold">Nội dung phản hồi:</label>
                            <textarea name="responseText" class="form-control" rows="4" placeholder="Nhập lời cảm ơn hoặc giải đáp thắc mắc..." required>${f.response}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">Gửi phản hồi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>