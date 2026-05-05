<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Admin Dashboard - Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root {
            --primary: #E3000F;
            --dark: #1a1a2e;
            --text-muted: #64748b;
        }

        body {
            font-family: 'Be Vietnam Pro', sans-serif;
            background: #f8f9fa;
            color: var(--dark);
        }

        .stat-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            text-align: center;
            border: none;
        }

        .stat-value {
            font-size: 3rem;
            font-weight: 800;
            color: var(--primary);
        }

        .stat-label {
            font-size: 1rem;
            font-weight: 600;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .chart-container {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
            margin-top: 2rem;
        }
    </style>
</head>
<body>

<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="dashboard" />
</jsp:include>

<div class="container py-5">
    <!-- Header -->
    <div class="mb-5">
        <h1 class="fw-bold mb-0">Hệ thống Quản trị</h1>
        <p class="text-muted">Tổng quan dữ liệu Fresh Food Store</p>
    </div>

    <!-- Stats Cards -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <div class="stat-label">Tổng số tài khoản</div>
                <div class="stat-value"><fmt:formatNumber value="${stats.totalUsers}" pattern="#,###"/></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card border-start border-success border-4">
                <div class="stat-label">Đang hoạt động</div>
                <div class="stat-value text-success"><fmt:formatNumber value="${stats.activeUsers}" pattern="#,###"/></div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card border-start border-danger border-4">
                <div class="stat-label">Đang bị khóa</div>
                <div class="stat-value text-danger"><fmt:formatNumber value="${stats.lockedUsers}" pattern="#,###"/></div>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <!-- Chart (Smaller) -->
        <div class="col-lg-4">
            <div class="chart-container h-100">
                <h6 class="fw-bold mb-4">Phân bổ Vai trò</h6>
                <div style="position: relative; height: 250px;">
                    <canvas id="roleChart"></canvas>
                </div>
            </div>
        </div>

        <!-- Recent Users Table -->
        <div class="col-lg-8">
            <div class="chart-container h-100">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h6 class="fw-bold mb-0">Thành viên mới gia nhập</h6>
                    <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-sm btn-link text-decoration-none">Xem tất cả</a>
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="table-light">
                            <tr>
                                <th>Họ tên</th>
                                <th>Email</th>
                                <th>Ngày tạo</th>
                                <th>Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${stats.recentUsers}">
                                <tr>
                                    <td>
                                        <div class="fw-bold">${u.fullName}</div>
                                    </td>
                                    <td><span class="text-muted small">${u.email}</span></td>
                                    <td><fmt:formatDate value="${u.createdAt}" pattern="dd/MM/yyyy"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status}">
                                                <span class="badge bg-success-subtle text-success rounded-pill px-3">Active</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-danger-subtle text-danger rounded-pill px-3">Locked</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = document.getElementById('roleChart').getContext('2d');
    const roleData = {
        <c:forEach var="entry" items="${stats.roleDistribution}" varStatus="loop">
            "${entry.key}": ${entry.value}${!loop.last ? ',' : ''}
        </c:forEach>
    };

    new Chart(ctx, {
        type: 'doughnut',
        data: {
            labels: Object.keys(roleData),
            datasets: [{
                data: Object.values(roleData),
                backgroundColor: [
                    '#E3000F', '#0D6EFD', '#FFC107', '#198754', '#6F42C1', '#FD7E14'
                ],
                borderWidth: 0,
                hoverOffset: 10
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: {
                    position: 'bottom',
                    labels: {
                        usePointStyle: true,
                        padding: 20,
                        font: { size: 11 }
                    }
                }
            },
            cutout: '70%'
        }
    });
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
