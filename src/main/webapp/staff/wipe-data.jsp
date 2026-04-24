<%@ page import="java.sql.*" %>
<%@ page import="org.example.utils.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Wipe Orders Data</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow border-0">
        <div class="card-body text-center p-5">
            <h2 class="fw-bold text-danger mb-4">Dọn dẹp Dữ liệu Đơn hàng</h2>
            
            <%
                String action = request.getParameter("confirm");
                String fix = request.getParameter("fix");
                
                if ("true".equals(action)) {
                    try (Connection conn = DBConnection.getConnection()) {
                        conn.setAutoCommit(false);
                        try (Statement stmt = conn.createStatement()) {
                            stmt.executeUpdate("DELETE FROM dbo.Feedbacks");
                            stmt.executeUpdate("DELETE FROM dbo.OrderVouchers");
                            stmt.executeUpdate("DELETE FROM dbo.OrderItemAllocations");
                            stmt.executeUpdate("DELETE FROM dbo.OrderItems");
                            stmt.executeUpdate("DELETE FROM dbo.Payments");
                            stmt.executeUpdate("DELETE FROM dbo.Orders");
                            
                            stmt.executeUpdate("DBCC CHECKIDENT ('dbo.Orders', RESEED, 0)");
                            stmt.executeUpdate("DBCC CHECKIDENT ('dbo.Payments', RESEED, 0)");
                            stmt.executeUpdate("DBCC CHECKIDENT ('dbo.OrderItems', RESEED, 0)");
                            
                            conn.commit();
                            out.println("<div class='alert alert-success fw-bold'>ĐÃ XÓA SẠCH DỮ LIỆU ĐƠN HÀNG THÀNH CÔNG!</div>");
                        } catch (Exception e) {
                            conn.rollback();
                            out.println("<div class='alert alert-danger'>Lỗi: " + e.getMessage() + "</div>");
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Lỗi kết nối: " + e.getMessage() + "</div>");
                    }
                } else if ("true".equals(fix)) {
                    try (Connection conn = DBConnection.getConnection()) {
                        try (Statement stmt = conn.createStatement()) {
                            int rows = stmt.executeUpdate("UPDATE dbo.Orders SET shipperId = 12, shippingStatus = 1 WHERE orderStatus = 3");
                            out.println("<div class='alert alert-info fw-bold'>ĐÃ ÉP GÁN SHIPPER 12 CHO " + rows + " ĐƠN HÀNG.</div>");
                        }
                    } catch (Exception e) {
                        out.println("<div class='alert alert-danger'>Lỗi: " + e.getMessage() + "</div>");
                    }
                } else {
            %>
                <p class="text-muted">Dọn dẹp hoặc sửa lỗi gán Shipper cho các đơn hiện tại.</p>
                <div class="d-grid gap-3 d-md-block">
                    <a href="?confirm=true" class="btn btn-danger btn-lg px-4 fw-bold rounded-pill">XÓA TẤT CẢ ĐƠN</a>
                    <a href="?fix=true" class="btn btn-warning btn-lg px-4 fw-bold rounded-pill">SỬA LỖI GÁN SHIPPER</a>
                </div>
            <%
                }
            %>
            <br><br>
            <a href="orders" class="btn btn-outline-secondary">Quay lại trang Quản lý</a>
        </div>
    </div>
</div>
</body>
</html>
