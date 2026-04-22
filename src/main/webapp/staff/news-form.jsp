<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${news != null ? 'Chỉnh sửa' : 'Tạo mới'} bài viết | Fresh Food Store</title>
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
        <jsp:param name="active" value="news" />
    </jsp:include>

    <div class="page-header mt-n2 mb-4">
        <div class="container-fluid px-4">
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Tin tức</a></li>
                    <li class="breadcrumb-item active">${news != null ? 'Chỉnh sửa' : 'Soạn bài'}</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">${news != null ? 'Biên tập Bài viết' : 'Soạn thảo Tin tức Mới'}</h2>
            <p class="text-white-50 small mb-0 mt-1">Nội dung chất lượng giúp khách hàng tin tưởng cửa hàng hơn.</p>
        </div>
    </div>

    <div class="container py-3 pb-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                    <div class="card-header bg-white py-3 border-bottom">
                        <div class="d-flex align-items-center">
                            <div class="bg-primary-subtle p-2 rounded-3 me-3">
                                <i class="bi bi-pencil-square text-primary fs-4"></i>
                            </div>
                            <h5 class="mb-0 fw-bold">Thông tin bài viết</h5>
                        </div>
                    </div>
                    <div class="card-body p-4 p-md-5">
                        <form action="news" method="POST">
                            <input type="hidden" name="action" value="${news != null ? 'update' : 'create'}">

                            <c:if test="${news != null}">
                                <input type="hidden" name="newsId" value="${news.newsId}">
                            </c:if>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small text-uppercase">Tiêu đề bài viết <span class="text-danger">*</span></label>
                                <input type="text" name="title" class="form-control form-control-lg border-2 shadow-none" 
                                       placeholder="VD: Bí quyết chọn rau xanh tươi ngon mỗi ngày"
                                       value="<c:out value='${news.title}'/>" required style="border-radius: 12px;">
                            </div>

                            <div class="row g-4 mb-4">
                                <div class="col-md-7">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Tóm tắt ngắn <span class="text-danger">*</span></label>
                                    <textarea name="summary" class="form-control border-2 shadow-none" rows="3" 
                                              placeholder="Mô tả ngắn hiển thị ở danh sách tin tức..."
                                              required style="border-radius: 12px;"><c:out value='${news.summary}'/></textarea>
                                </div>
                                <div class="col-md-5">
                                    <label class="form-label fw-bold text-secondary small text-uppercase">Link Ảnh đại diện (URL)</label>
                                    <input type="text" name="imageUrl" class="form-control border-2 shadow-none"
                                           value="<c:out value='${news.imageUrl}'/>" placeholder="https://..." style="border-radius: 12px;">
                                    <div class="mt-2 small text-muted"><i class="bi bi-info-circle me-1"></i> Sử dụng ảnh có tỉ lệ 16:9 để hiển thị tốt nhất.</div>
                                </div>
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-bold text-secondary small text-uppercase">Nội dung chi tiết <span class="text-danger">*</span></label>
                                <textarea name="content" class="form-control border-2 shadow-none" rows="15" 
                                          placeholder="Viết nội dung bài viết tại đây..."
                                          required style="border-radius: 12px;"><c:out value='${news.content}'/></textarea>
                            </div>

                            <div class="d-flex justify-content-between mt-5 pt-4 border-top">
                                <a href="news?action=list" class="btn btn-light px-4 py-2 rounded-pill shadow-sm"
                                   onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
                                    <i class="bi bi-arrow-left me-2"></i>Quay lại
                                </a>
                                <div class="btn-group shadow-lg rounded-pill overflow-hidden">
                                    <button type="submit" name="submitBtn" value="draft" class="btn btn-brand-outline bg-white px-4">
                                        <i class="bi bi-bookmark-plus me-2"></i>Lưu nháp
                                    </button>
                                    <button type="submit" name="submitBtn" value="publish" class="btn btn-brand px-5">
                                        <i class="bi bi-send-check me-2"></i>Đăng ngay
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