<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${article.title} - Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .news-header {
            position: relative;
            height: 400px;
            background-size: cover;
            background-position: center;
            border-radius: 20px;
            margin-bottom: -100px;
            z-index: 1;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
        }
        .news-header::after {
            content: '';
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: linear-gradient(to bottom, rgba(0,0,0,0) 0%, rgba(0,0,0,0.7) 100%);
            border-radius: 20px;
        }
        .news-content-card {
            background: white;
            border-radius: 20px;
            padding: 80px 60px 40px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.05);
            position: relative;
            z-index: 2;
        }
        .article-meta {
            color: var(--brand-color);
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-size: 0.9rem;
        }
        .article-title {
            font-size: 2.8rem;
            font-weight: 800;
            line-height: 1.2;
            margin: 15px 0 25px;
            color: #1a1a1a;
        }
        .article-body {
            font-size: 1.15rem;
            line-height: 1.8;
            color: #444;
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
        }
        .article-body p { margin-bottom: 25px; }
        .breadcrumb-item a { color: #6c757d; text-decoration: none; }
        .breadcrumb-item.active { color: var(--brand-color); }
        
        @media (max-width: 768px) {
            .news-header { height: 250px; margin-bottom: -50px; }
            .news-content-card { padding: 50px 20px 30px; }
            .article-title { font-size: 1.8rem; }
        }
    </style>
</head>
<body class="bg-light">

    <jsp:include page="components/header.jsp" />

    <c:set var="headerImg" value="${not empty article.imageUrl ? article.imageUrl : 'https://via.placeholder.com/1200x600?text=Fresh+Food+News'}" />
    
    <div class="container py-4">
        <nav aria-label="breadcrumb" class="mb-4">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="home">Trang chủ</a></li>
                <li class="breadcrumb-item"><a href="home">Tin tức</a></li>
                <li class="breadcrumb-item active" aria-current="page">Chi tiết</li>
            </ol>
        </nav>

        <div class="news-header" style="background-image: url('${headerImg}')">
            <div class="position-absolute bottom-0 start-0 p-4 p-md-5 text-white" style="z-index: 2;">
                <span class="badge bg-success mb-2">🌿 Food & Life</span>
                <h1 class="display-5 fw-bold mb-0 text-shadow"><c:out value="${article.title}" /></h1>
            </div>
        </div>

        <div class="row justify-content-center mb-5">
            <div class="col-lg-10 col-xl-9">
                <div class="news-content-card">
                    <div class="article-meta">
                        <i class="far fa-calendar-alt me-2"></i> 
                        Ngày đăng: 
                        <c:choose>
                            <c:when test="${not empty article.publishedAt}">
                                <fmt:parseDate value="${article.publishedAt}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy" />
                            </c:when>
                            <c:otherwise>
                                <span class="text-muted italic">Đang cập nhật</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    
                    <div class="article-body mt-4">
                        <div class="lead fw-bold text-dark mb-4" style="font-size: 1.4rem;">
                            ${article.summary}
                        </div>
                        <hr class="my-5 opacity-10">
                        <div class="article-text" style="white-space: pre-wrap;">
                            ${article.content}
                        </div>
                    </div>

                    <div class="mt-5 pt-4 border-top">
                        <div class="d-flex justify-content-between align-items-center">
                            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-success rounded-pill px-4">
                                <i class="fas fa-arrow-left me-2"></i> Quay lại trang chủ
                            </a>
                            <div class="share-links">
                                <span class="text-muted me-3">Chia sẻ:</span>
                                <a href="#" class="text-secondary mx-1"><i class="fab fa-facebook-f"></i></a>
                                <a href="#" class="text-secondary mx-1"><i class="fab fa-twitter"></i></a>
                                <a href="#" class="text-secondary mx-1"><i class="fas fa-link"></i></a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
