<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Đổi mật khẩu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="/components/header.jsp" />

<main class="container py-5 flex-grow-1">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <h2 class="mb-4">Đổi mật khẩu</h2>

            <c:choose>
                <c:when test="${passwordChanged}">
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4 text-center">
                            <div class="text-success mb-3">
                                <i class="fa-solid fa-circle-check fa-3x"></i>
                            </div>
                            <h5 class="mb-2">Đổi mật khẩu thành công</h5>
                            <p class="text-muted mb-4">Mật khẩu của bạn đã được cập nhật.</p>
                            <a href="${pageContext.request.contextPath}/profile" class="btn btn-primary px-4">OK</a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card shadow-sm border-0">
                        <div class="card-body p-4">
                            <form method="post" action="${pageContext.request.contextPath}/change-password">
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu hiện tại</label>
                                    <input type="password" name="currentPassword"
                                           class="form-control ${not empty currentPasswordError ? 'is-invalid' : ''}" required>
                                    <c:if test="${not empty currentPasswordError}">
                                        <div class="invalid-feedback d-block">${currentPasswordError}</div>
                                    </c:if>
                                </div>

                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <input type="password" name="newPassword"
                                           class="form-control ${not empty newPasswordError ? 'is-invalid' : ''}" required>
                                    <c:if test="${not empty newPasswordError}">
                                        <div class="invalid-feedback d-block">${newPasswordError}</div>
                                    </c:if>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Xác nhận mật khẩu mới</label>
                                    <input type="password" name="confirmPassword"
                                           class="form-control ${not empty confirmPasswordError ? 'is-invalid' : ''}" required>
                                    <c:if test="${not empty confirmPasswordError}">
                                        <div class="invalid-feedback d-block">${confirmPasswordError}</div>
                                    </c:if>
                                </div>

                                <c:if test="${not empty passwordGeneralError}">
                                    <div class="text-danger small mb-3">${passwordGeneralError}</div>
                                </c:if>

                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-warning">
                                        <i class="fa-solid fa-key me-1"></i> Đổi mật khẩu
                                    </button>
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary">Quay lại profile</a>
                                </div>
                            </form>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</main>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
