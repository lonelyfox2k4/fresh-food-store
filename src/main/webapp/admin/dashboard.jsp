<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Admin Dashboard - Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        :root {
            --primary: #E3000F;
            --primary-hover: #b5000c;
            --secondary: #ffc107;
            --dark: #1a1a2e;
            --light-bg: #f0f2f5;
            --card-bg: rgba(255, 255, 255, 0.9);
            --text-main: #1a1a2e;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: radial-gradient(circle at top right, #fff5f5, #f0f2f5);
            color: var(--text-main);
            margin: 0;
            overflow-x: hidden;
            min-height: 100vh;
        }

        .stat-card {
            background: var(--card-bg);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.05);
            transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-8px) scale(1.02);
            box-shadow: 0 20px 40px -10px rgba(227, 0, 15, 0.15);
        }

        .stat-card::after {
            content: '';
            position: absolute;
            bottom: -50px;
            right: -50px;
            width: 100px;
            height: 100px;
            background: var(--primary);
            opacity: 0.03;
            border-radius: 50%;
            transition: all 0.4s ease;
        }

        .stat-card:hover::after {
            transform: scale(3);
            opacity: 0.05;
        }

        .stat-icon {
            width: 56px;
            height: 56px;
            border-radius: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-bottom: 1.2rem;
            box-shadow: 0 8px 16px -4px rgba(0,0,0,0.1);
        }

        .icon-users { background: linear-gradient(135deg, #fff0f0, #fee2e2); color: #E3000F; }
        .icon-products { background: linear-gradient(135deg, #fff9e6, #fef3c7); color: #d97706; }
        .icon-orders { background: linear-gradient(135deg, #f0f9ff, #e0f2fe); color: #0284c7; }
        .icon-revenue { background: linear-gradient(135deg, #f0fdf4, #dcfce7); color: #16a34a; }

        .stat-value {
            font-size: 2.2rem;
            font-weight: 800;
            color: var(--dark);
            line-height: 1;
            letter-spacing: -1px;
        }

        .stat-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-top: 0.6rem;
        }

        /* Quick Actions */
        .action-card-premium {
            background: linear-gradient(135deg, #E3000F 0%, #b5000c 100%);
            color: white;
            border-radius: 20px;
            padding: 2.5rem;
            box-shadow: 0 15px 35px -10px rgba(227, 0, 15, 0.4);
            position: relative;
            overflow: hidden;
            border: none;
        }

        .action-card-premium::before {
            content: '';
            position: absolute;
            top: 0;
            right: 0;
            width: 100%;
            height: 100%;
            background: url("data:image/svg+xml,%3Csvg width='100' height='100' viewBox='0 0 100 100' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M11 18c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm48 25c3.866 0 7-3.134 7-7s-3.134-7-7-7-7 3.134-7 7 3.134 7 7 7zm-43-7c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm63 31c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM34 90c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zm56-76c1.657 0 3-1.343 3-3s-1.343-3-3-3-3 1.343-3 3 1.343 3 3 3zM12 86c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm28-65c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm23-11c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-6 60c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm29 22c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zM32 57c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm57-13c2.76 0 5-2.24 5-5s-2.24-5-5-5-5 2.24-5 5 2.24 5 5 5zm-9-21c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM60 91c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM35 41c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2zM12 60c1.105 0 2-.895 2-2s-.895-2-2-2-2 .895-2 2 .895 2 2 2z' fill='%23ffffff' fill-opacity='0.05' fill-rule='evenodd'/%3E%3C/svg%3E");
            opacity: 0.4;
        }

        .action-card-premium:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 45px -10px rgba(227, 0, 15, 0.5);
        }

        /* Animations */
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-slide-up {
            animation: slideUp 0.8s cubic-bezier(0.22, 1, 0.36, 1) forwards;
        }
        .delay-1 { animation-delay: 0.1s; }
        .delay-2 { animation-delay: 0.2s; }
        .delay-3 { animation-delay: 0.3s; }
    </style>
</head>
<body>

<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<!-- Main Content -->
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-5 animate-fade-in">
        <div>
            <h1 class="fw-bold mb-1">Tổng quan cửa hàng</h1>
            <p class="text-muted mb-0">Theo dõi các chỉ số quan trọng của Fresh Food Store hôm nay.</p>
        </div>
        <div>
            <button class="btn btn-outline-danger shadow-sm rounded-pill px-4" onclick="alert('Tính năng xuất báo cáo doanh thu ra file Excel/CSV đang được phát triển.')">
                <i class="fas fa-download me-1"></i> Xuất báo cáo doanh thu
            </button>
        </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-4 mb-5">
        <div class="col-12 col-md-6 col-lg-3 animate-slide-up">
            <div class="stat-card">
                <div class="stat-icon icon-users">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalUsers}" pattern="#,###"/></div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
        </div>
        
        <div class="col-12 col-md-6 col-lg-3 animate-slide-up delay-1">
            <div class="stat-card">
                <div class="stat-icon icon-products">
                    <i class="fas fa-box-open"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalProducts}" pattern="#,###"/></div>
                <div class="stat-label">Sản phẩm hiện có</div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3 animate-slide-up delay-2">
            <div class="stat-card">
                <div class="stat-icon icon-orders">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalOrders}" pattern="#,###"/></div>
                <div class="stat-label">Tổng đơn hàng</div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3 animate-slide-up delay-3">
            <div class="stat-card">
                <div class="stat-icon icon-revenue">
                    <i class="fas fa-wallet"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                <div class="stat-label">Doanh thu ước tính</div>
            </div>
        </div>
    </div>

    <!-- Recent Activity & Quick Links -->
    <div class="row g-4">
        <!-- Quick Link to Users -->
        <div class="col-12 col-lg-6 animate-slide-up delay-2">
            <div class="card border-0 shadow-sm rounded-5 h-100 overflow-hidden" style="background: rgba(255,255,255,0.7); backdrop-filter: blur(10px);">
                <div class="card-header bg-transparent border-0 pt-4 pb-0 px-4">
                    <h5 class="fw-800 mb-0">Hành động nhanh</h5>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/users" class="text-decoration-none group">
                                <div class="p-4 rounded-4 text-center border promo-card transition-all h-100 d-flex flex-column align-items-center justify-content-center" style="border: 1px solid rgba(0,0,0,0.05); background: white; transition: all 0.4s ease;">
                                    <div class="mb-3 p-3 rounded-circle bg-brand-light">
                                        <i class="fas fa-user-shield fs-2 text-brand"></i>
                                    </div>
                                    <h6 class="text-dark fw-700 mb-0">Quản lý User</h6>
                                </div>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/assign" class="text-decoration-none group">
                                <div class="p-4 rounded-4 text-center border transition-all h-100 d-flex flex-column align-items-center justify-content-center" style="border: 1px solid rgba(0,0,0,0.05); background: white; transition: all 0.4s ease;">
                                    <div class="mb-3 p-3 rounded-circle" style="background: #fff9e6;">
                                        <i class="fas fa-user-plus fs-2 text-warning"></i>
                                    </div>
                                    <h6 class="text-dark fw-700 mb-0">Cấp tài khoản</h6>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Premium Banner -->
        <div class="col-12 col-lg-6 animate-slide-up delay-3">
            <div class="action-card-premium h-100 d-flex flex-column justify-content-center align-items-center">
                <div class="position-relative z-index-1 text-center">
                    <h2 class="fw-800 text-white mb-3">Tăng Trưởng Cùng Fresh Food!</h2>
                    <p class="text-white-50 mb-4 px-lg-5 fs-6">Hệ thống quản trị thông minh giúp bạn tối ưu hóa doanh thu và giảm thiểu lãng phí thực phẩm hàng ngày.</p>
                    <button class="btn btn-warning rounded-pill px-5 py-3 fw-bold shadow-lg border-0 transformTransition" style="transition: all 0.3s ease;">
                        Khám Phá Widget Mới <i class="fas fa-magic ms-2"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
