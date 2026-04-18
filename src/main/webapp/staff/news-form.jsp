<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${news != null ? 'Chỉnh sửa' : 'Tạo mới'} bài viết | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container py-4">
    <div class="mb-3">
        <a href="${pageContext.request.contextPath}/staff/news"
           class="btn btn-sm btn-light border shadow-sm"
           onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card border-0 shadow">
                <div class="card-header bg-primary text-white py-3">
                    <h5 class="mb-0 fw-bold">
                        <i class="bi ${news != null ? 'bi-pencil-square' : 'bi-plus-circle-dotted'} me-2"></i>
                        ${news != null ? 'Chỉnh sửa bài viết' : 'Soạn bài viết mới'}
                    </h5>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/staff/news" method="POST">
                        <input type="hidden" name="action" value="${news != null ? 'update' : 'create'}">
                        <c:if test="${news != null}">
                            <input type="hidden" name="newsId" value="${news.newsId}">
                        </c:if>

                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                Tiêu đề <span class="text-danger">*</span>
                            </label>
                            <input type="text" name="title" class="form-control form-control-lg"
                                   value="<c:out value='${news.title}'/>"
                                   placeholder="Nhập tiêu đề bài viết..." required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                Tóm tắt ngắn <span class="text-danger">*</span>
                            </label>
                            <textarea name="summary" class="form-control" rows="2"
                                      placeholder="Mô tả ngắn hiển thị ở trang danh sách..." required><c:out value='${news.summary}'/></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Link ảnh đại diện</label>
                            <input type="text" name="imageUrl" class="form-control"
                                   value="<c:out value='${news.imageUrl}'/>"
                                   placeholder="https://example.com/image.jpg">
                            <div class="form-text">URL ảnh thumbnail hiển thị kèm bài viết.</div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">
                                Nội dung chi tiết <span class="text-danger">*</span>
                            </label>
                            <textarea name="content" class="form-control" rows="14"
                                      placeholder="Soạn nội dung bài viết..." required><c:out value='${news.content}'/></textarea>
                        </div>

                        <hr class="my-4">

                        <div class="d-flex justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/staff/news"
                               class="btn btn-outline-secondary px-4"
                               onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
                                <i class="bi bi-x me-1"></i>Hủy bỏ
                            </a>
                            <div class="d-flex gap-2">
                                <button type="submit" name="submitBtn" value="draft"
                                        class="btn btn-outline-primary px-4">
                                    <i class="bi bi-bookmark me-1"></i>Lưu nháp
                                </button>
                                <button type="submit" name="submitBtn" value="publish"
                                        class="btn btn-success px-4 fw-bold">
                                    <i class="bi bi-send-check me-1"></i>Đăng ngay
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