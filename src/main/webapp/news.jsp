<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="org.example.dao.NewsArticleDAO" %>
<%@ page import="org.example.model.content.NewsArticle" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trung tâm Tin tức & Sức khỏe | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .news-hero {
            background: linear-gradient(135deg, #198754 0%, #0c432a 100%);
            padding: 80px 0;
            color: white;
            border-bottom-left-radius: 50% 20px;
            border-bottom-right-radius: 50% 20px;
        }
        .blog-card {
            border: none;
            border-radius: 16px;
            transition: all 0.3s ease;
            overflow: hidden;
        }
        .blog-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 35px rgba(0,0,0,0.1) !important;
        }
        .blog-card img {
            height: 220px;
            object-fit: cover;
        }
        .blog-card .card-body {
            padding: 1.5rem;
        }
        .blog-card .category-tag {
            font-size: 0.75rem;
            text-transform: uppercase;
            font-weight: 700;
            letter-spacing: 1px;
            color: #198754;
            margin-bottom: 0.5rem;
            display: block;
        }
        .blog-title {
            font-size: 1.25rem;
            font-weight: 700;
            line-height: 1.4;
            color: #2c3e50;
            margin-bottom: 0.75rem;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .blog-summary {
            font-size: 0.95rem;
            color: #6c757d;
            margin-bottom: 1.5rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>
<body class="bg-light">

    <jsp:include page="components/header.jsp" />

    <%-- ════ Logic Phân trang trực tiếp trên JSP để tránh lỗi Cache Server ════ --%>
    <%
        org.example.dao.NewsArticleDAO newsDAO = new org.example.dao.NewsArticleDAO();
        int pSize = 4;
        int currPage = 1;
        String pParam = request.getParameter("page");
        if (pParam != null && !pParam.isEmpty()) {
            try { currPage = Integer.parseInt(pParam); } catch (Exception e) { currPage = 1; }
        }
        
        java.util.List<org.example.model.content.NewsArticle> pagedList = newsDAO.getPublishedNewsPaged(currPage, pSize);
        int totalCount = newsDAO.getTotalPublishedCount();
        int totalPagesCount = (int) Math.ceil((double) totalCount / pSize);
        
        // Ghi đè các thuộc tính để JSTL bên dưới sử dụng
        request.setAttribute("newsList", pagedList);
        request.setAttribute("currentPage", currPage);
        request.setAttribute("totalPages", totalPagesCount);
    %>

    <header class="news-hero text-center">
        <div class="container text-center">
            <h1 class="display-4 fw-bold mb-3">Fresh Food Blog</h1>
            <p class="lead opacity-75 mb-4">Nơi chia sẻ kiến thức về thực phẩm sạch, sức khỏe và bí quyết nấu ăn ngon.</p>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light rounded-pill px-4 py-2 fw-bold shadow-sm">
                <i class="fas fa-home me-2"></i> Quay về trang chủ
            </a>
        </div>
    </header>

    <div class="container py-5" style="margin-top: -30px;">
        <c:if test="${not empty param.error}">
            <div class="alert alert-warning alert-dismissible fade show mb-4 rounded-3 border-0 shadow-sm" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>
                <c:choose>
                    <c:when test="${param.error == 'not_found'}">Rất tiếc, chúng tôi không tìm thấy bài viết bạn yêu cầu.</c:when>
                    <c:otherwise>Đã có lỗi xảy ra. Vui lòng thử lại sau.</c:otherwise>
                </c:choose>
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="row g-4">
            <c:forEach var="news" items="${newsList}">
                <div class="col-md-6 col-lg-4">
                    <article class="card h-100 blog-card shadow-sm">
                        <a href="${pageContext.request.contextPath}/news?id=${news.newsId}">
                            <img src="${not empty news.imageUrl ? news.imageUrl : 'https://via.placeholder.com/600x400?text=Fresh+Food+Store'}" 
                                 class="card-img-top" alt="${news.title}">
                        </a>
                        <div class="card-body d-flex flex-column">
                            <span class="category-tag"><i class="fas fa-leaf me-1"></i> Food & Health</span>
                            <a href="${pageContext.request.contextPath}/news?id=${news.newsId}" class="text-decoration-none">
                                <h3 class="blog-title">${news.title}</h3>
                            </a>
                            <p class="blog-summary">${news.summary}</p>
                            
                            <div class="mt-auto d-flex justify-content-between align-items-center">
                                <div class="small text-muted">
                                    <i class="far fa-calendar-alt me-1"></i>
                                    <c:choose>
                                        <c:when test="${not empty news.publishedAt}">
                                            <fmt:parseDate value="${news.publishedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="pDate" type="both" />
                                            <fmt:formatDate value="${pDate}" pattern="dd/MM/yyyy" />
                                        </c:when>
                                        <c:otherwise>Đang cập nhật</c:otherwise>
                                    </c:choose>
                                </div>
                                <a href="${pageContext.request.contextPath}/news?id=${news.newsId}" class="btn btn-sm btn-link text-success fw-bold text-decoration-none p-0">
                                    Đọc tiếp <i class="fas fa-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </article>
                </div>
            </c:forEach>
            
            <c:if test="${empty newsList}">
                <div class="col-12 text-center py-5">
                    <i class="fas fa-newspaper fa-4x text-muted opacity-25 mb-3"></i>
                    <h4 class="text-muted">Hiện chưa có tin tức nào được cập nhật.</h4>
                    <p>Vui lòng quay lại sau ít phút.</p>
                </div>
            </c:if>
        </div>

        <%-- ══ Pagination Bar ════════════════════════════════════════════════ --%>
        <c:if test="${totalPages > 1}">
            <nav aria-label="Page navigation" class="mt-5">
                <ul class="pagination justify-content-center">
                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage - 1}" aria-label="Previous">
                            <span aria-hidden="true">&laquo;</span>
                        </a>
                    </li>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}">${i}</a>
                        </li>
                    </c:forEach>
                    
                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                        <a class="page-link" href="?page=${currentPage + 1}" aria-label="Next">
                            <span aria-hidden="true">&raquo;</span>
                        </a>
                    </li>
                </ul>
            </nav>
        </c:if>
    </div>

    <jsp:include page="components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
