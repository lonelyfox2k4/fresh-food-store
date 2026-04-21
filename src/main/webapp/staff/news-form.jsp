<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${news != null ? 'Chỉnh sửa' : 'Tạo mới'} bài viết | Fresh Food</title>
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
    <jsp:param name="active" value="news" />
</jsp:include>

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
            <div class="main-card p-4 p-md-5">
                <div class="mb-5 text-center">
                    <div class="bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center rounded-4 p-3 mb-3">
                        <i class="fas ${news != null ? 'fa-edit' : 'fa-plus-circle'} fs-3"></i>
                    </div>
                    <h2 class="fw-bold fs-3 text-dark mb-1">${news != null ? 'Chỉnh sửa bài viết' : 'Soạn bài viết mới'}</h2>
                    <p class="text-secondary small">Quản lý nội dung truyền thông của hệ thống.</p>
                </div>
                <div>
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

                        <div class="d-flex justify-content-between align-items-center mt-4">
                            <a href="${pageContext.request.contextPath}/staff/news"
                               class="btn btn-light btn-premium border-0 px-4"
                               onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
                                <i class="fas fa-times me-1"></i>Hủy bỏ
                            </a>
                            <div class="d-flex gap-2">
                                <button type="submit" name="submitBtn" value="draft"
                                        class="btn btn-outline-brand btn-premium px-4">
                                    <i class="fas fa-bookmark me-1"></i>Lưu nháp
                                </button>
                                <button type="submit" name="submitBtn" value="publish"
                                        class="btn btn-brand btn-premium shadow-lg px-4">
                                    <i class="fas fa-paper-plane me-1"></i>Đăng ngay
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