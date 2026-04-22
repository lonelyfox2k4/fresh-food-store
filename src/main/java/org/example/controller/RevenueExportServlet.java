package org.example.controller;

import org.example.dao.OrderDAO;
import org.example.model.order.Order;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/admin/export-revenue")
public class RevenueExportServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Lấy tham số khoảng thời gian
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // 2. Lấy dữ liệu từ Database theo khoảng thời gian
        List<Order> orders = orderDAO.getOrdersByDateRange(startDate, endDate);

        // 2. Thiết lập Header cho phản hồi (Download file CSV)
        String fileName = "bao_cao_doanh_thu";
        if (startDate != null && !startDate.isEmpty()) fileName += "_tu_" + startDate;
        if (endDate != null && !endDate.isEmpty()) fileName += "_den_" + endDate;
        
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + fileName + ".csv");

        // 3. Viết nội dung file
        try (PrintWriter writer = response.getWriter()) {
            // Thêm BOM (Byte Order Mark) để Excel nhận diện được UTF-8 (tiếng Việt)
            writer.write('\ufeff');

            // Viết Header của file (Bỏ tiêu đề trong file theo ý anh)
            writer.println("Mã đơn hàng,Người nhận,Ngày đặt,Trạng thái đơn,Trạng thái thanh toán,Tổng tiền (VNĐ)");

            // Viết từng dòng dữ liệu
            for (Order o : orders) {
                StringBuilder sb = new StringBuilder();
                sb.append(o.getOrderCode()).append(",");
                sb.append("\"").append(o.getRecipientNameSnapshot().replace("\"", "\"\"")).append("\",");
                sb.append(o.getPlacedAt()).append(",");
                sb.append(getStatusName(o.getOrderStatus())).append(",");
                sb.append(getPaymentStatusName(o.getPaymentStatus())).append(",");
                sb.append(o.getTotalAmount());
                
                writer.println(sb.toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String getStatusName(byte status) {
        switch (status) {
            case 1: return "Chờ xác nhận";
            case 2: return "Đã xác nhận";
            case 3: return "Đang đóng gói";
            case 4: return "Đang giao";
            case 5: return "Hoàn thành";
            case 6: return "Đã hủy";
            default: return "Không xác định";
        }
    }

    private String getPaymentStatusName(byte status) {
        switch (status) {
            case 1: return "Chưa thanh toán";
            case 2: return "Đã thanh toán";
            case 3: return "Lỗi thanh toán";
            case 4: return "Đã hoàn tiền";
            default: return "Không xác định";
        }
    }
}
