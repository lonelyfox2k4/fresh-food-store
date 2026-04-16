<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Thông tin cá nhân</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/style.css">
</head>
<body class="bg-light">
<jsp:include page="/components/header.jsp" />

<main class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <h2 class="mb-4">Thông tin cá nhân</h2>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success" role="alert">
                        ${successMsg}
                </div>
            </c:if>

            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <form id="profileForm" method="post" action="${pageContext.request.contextPath}/profile/update">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email</label>
                            <input type="email" class="form-control" value="${profile.email}" disabled>
                            <div class="form-text">Email không thể chỉnh sửa.</div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Họ tên</label>
                            <input id="fullNameInput" type="text" name="fullName"
                                   class="form-control ${not empty fullNameError ? 'is-invalid' : ''}"
                                   value="${not empty profileFullNameInput ? profileFullNameInput : profile.fullName}" required ${openEditMode ? '' : 'disabled'}>
                            <c:if test="${not empty fullNameError}">
                                <div class="invalid-feedback d-block">${fullNameError}</div>
                            </c:if>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Số điện thoại</label>
                            <input id="phoneInput" type="text" name="phone"
                                   class="form-control ${not empty phoneError ? 'is-invalid' : ''}"
                                   value="${not empty profilePhoneInput ? profilePhoneInput : profile.phone}" ${openEditMode ? '' : 'disabled'}>
                            <c:if test="${not empty phoneError}">
                                <div class="invalid-feedback d-block">${phoneError}</div>
                            </c:if>
                        </div>

                        <c:if test="${not empty profileGeneralError}">
                            <div class="text-danger small mb-3">${profileGeneralError}</div>
                        </c:if>

                        <div class="d-flex flex-wrap gap-2">
                            <c:choose>
                                <c:when test="${openEditMode}">
                                    <button id="saveBtn" type="submit" class="btn btn-success">
                                        <i class="fa-solid fa-floppy-disk me-1"></i> Lưu thay đổi
                                    </button>
                                    <a href="${pageContext.request.contextPath}/profile" class="btn btn-outline-secondary">Hủy</a>
                                </c:when>
                                <c:otherwise>
                                    <a id="editBtn" href="${pageContext.request.contextPath}/profile?edit=1" class="btn btn-primary">
                                        <i class="fa-solid fa-pen-to-square me-1"></i> Chỉnh sửa
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/change-password" class="btn btn-warning ms-auto">
                                <i class="fa-solid fa-key me-1"></i> Đổi mật khẩu
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/components/footer.jsp" />

</body>
</html>
