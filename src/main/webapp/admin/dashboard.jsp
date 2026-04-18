<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Admin Dashboard - Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --primary-hover: #4338CA;
            --secondary: #10B981;
            --dark: #111827;
            --light-bg: #F3F4F6;
            --card-bg: #FFFFFF;
            --text-main: #1F2937;
            --text-muted: #6B7280;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-bg);
            color: var(--text-main);
            margin: 0;
            overflow-x: hidden;
        }


        .stat-card {
            background: var(--card-bg);
            border-radius: 1rem;
            padding: 1.5rem;
            border: none;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05), 0 4px 6px -2px rgba(0, 0, 0, 0.025);
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
            z-index: 1;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, var(--primary), var(--secondary));
            z-index: 2;
        }

        .stat-icon {
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            margin-bottom: 1rem;
        }

        .icon-users { background: #EEF2FF; color: #4F46E5; }
        .icon-products { background: #ECFDF5; color: #10B981; }
        .icon-orders { background: #FFF7ED; color: #F97316; }
        .icon-revenue { background: #FEF2F2; color: #EF4444; }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--dark);
            line-height: 1.2;
        }

        .stat-label {
            font-size: 0.875rem;
            font-weight: 500;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-top: 0.5rem;
        }

        /* Quick Actions */
        .action-card {
            background: linear-gradient(135deg, var(--primary), var(--primary-hover));
            color: white;
            border-radius: 1rem;
            padding: 2rem;
            box-shadow: 0 10px 15px -3px rgba(79, 70, 229, 0.3);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 25px -5px rgba(79, 70, 229, 0.4);
        }

        .action-card a {
            color: white;
            text-decoration: none;
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .animate-fade-in {
            animation: fadeIn 0.6s cubic-bezier(0.4, 0, 0.2, 1) forwards;
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
            <button class="btn btn-outline-primary shadow-sm rounded-pill px-4" onclick="alert('Tính năng xuất báo cáo doanh thu ra file Excel/CSV đang được phát triển.')">
                <i class="fas fa-download me-1"></i> Xuất báo cáo doanh thu
            </button>
        </div>
    </div>

    <!-- Stats Row -->
    <div class="row g-4 mb-5">
        <div class="col-12 col-md-6 col-lg-3 animate-fade-in">
            <div class="stat-card">
                <div class="stat-icon icon-users">
                    <i class="fas fa-users"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalUsers}" pattern="#,###"/></div>
                <div class="stat-label">Tổng người dùng</div>
            </div>
        </div>
        
        <div class="col-12 col-md-6 col-lg-3 animate-fade-in delay-1">
            <div class="stat-card">
                <div class="stat-icon icon-products">
                    <i class="fas fa-box-open"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalProducts}" pattern="#,###"/></div>
                <div class="stat-label">Sản phẩm hiện có</div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3 animate-fade-in delay-2">
            <div class="stat-card">
                <div class="stat-icon icon-orders">
                    <i class="fas fa-shopping-bag"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalOrders}" pattern="#,###"/></div>
                <div class="stat-label">Tổng đơn hàng</div>
            </div>
        </div>

        <div class="col-12 col-md-6 col-lg-3 animate-fade-in delay-3">
            <div class="stat-card">
                <div class="stat-icon icon-revenue">
                    <i class="fas fa-chart-pie"></i>
                </div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
                <div class="stat-label">Doanh thu ước tính</div>
            </div>
        </div>
    </div>

    <!-- Recent Activity & Quick Links -->
    <div class="row g-4">
        <!-- Quick Link to Users -->
        <div class="col-12 col-lg-6 animate-fade-in delay-3">
            <div class="card border-0 shadow-sm rounded-4 h-100 overflow-hidden">
                <div class="card-header bg-white border-bottom-0 pt-4 pb-0 px-4">
                    <h5 class="fw-bold mb-0">Hành động nhanh</h5>
                </div>
                <div class="card-body p-4">
                    <div class="row g-3">
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/users" class="text-decoration-none">
                                <div class="p-4 bg-light rounded-4 text-center border promo-card transition-all" style="border: 1px solid #E5E7EB; transition: all 0.3s; cursor:pointer;" onmouseover="this.style.borderColor='var(--primary)'; this.style.backgroundColor='#EEF2FF';" onmouseout="this.style.borderColor='#E5E7EB'; this.style.backgroundColor='#F8F9FA';">
                                    <i class="fas fa-user-shield fs-1 text-primary mb-3"></i>
                                    <h6 class="text-dark fw-bold mb-0">Quản lý User</h6>
                                </div>
                            </a>
                        </div>
                        <div class="col-6">
                            <a href="${pageContext.request.contextPath}/admin/assign" class="text-decoration-none">
                                <div class="p-4 bg-light rounded-4 text-center border transition-all" style="border: 1px solid #E5E7EB; transition: all 0.3s; cursor:pointer;" onmouseover="this.style.borderColor='var(--secondary)'; this.style.backgroundColor='#ECFDF5';" onmouseout="this.style.borderColor='#E5E7EB'; this.style.backgroundColor='#F8F9FA';">
                                    <i class="fas fa-user-plus fs-1 text-success mb-3"></i>
                                    <h6 class="text-dark fw-bold mb-0">Cấp tài khoản</h6>
                                </div>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Premium Banner -->
        <div class="col-12 col-lg-6 animate-fade-in delay-3">
            <div class="action-card h-100 d-flex flex-column justify-content-center align-items-center position-relative overflow-hidden">
                <!-- Abstract Background SVG -->
                <svg class="position-absolute opacity-25" style="top: -20px; right: -20px;" width="200" height="200" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                  <path fill="#FFFFFF" d="M44.7,-76.4C58.8,-69.2,71.8,-59.1,81.1,-46.3C90.4,-33.5,96,-18,95.3,-2.9C94.6,12.2,87.6,26.9,78.2,39.6C68.8,52.3,57,63,43.2,71.4C29.4,79.8,13.6,85.9,-1.9,89.1C-17.4,92.3,-32.8,92.6,-45.5,85.8C-58.2,79,-68.2,65.1,-75.4,50.1C-82.6,35.1,-87,19.1,-86,-2C-84.9,-23.1,-78.4,-43,-66.2,-57.4C-54,-71.8,-36.1,-80.7,-20.1,-83.1C-4.1,-85.5,10,-81.4,22.8,-77Z" transform="translate(100 100)" />
                </svg>
                <div class="position-relative z-index-1">
                    <h3 class="fw-bold text-white mb-3">Sẵn sàng để phát triển?</h3>
                    <p class="text-white-50 mb-4 px-4">Hãy kiểm tra các chiến lược giá hạn sử dụng để tránh lãng phí thực phẩm hôm nay.</p>
                    <button class="btn btn-light rounded-pill px-4 py-2 fw-semibold text-primary shadow-sm hover-shadow">
                        Đi tới cấu hình <i class="fas fa-arrow-right ms-2"></i>
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
