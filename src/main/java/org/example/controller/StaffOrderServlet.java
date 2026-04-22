package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.dao.OrderDAO;
import org.example.dao.OrderItemDAO;
import org.example.model.auth.Account;
import org.example.model.order.Order;
import org.example.model.order.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffOrderServlet", urlPatterns = {"/staff/orders"})
public class StaffOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private AccountDAO accountDAO;
    private OrderItemDAO orderItemDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        accountDAO = new AccountDAO();
        orderItemDAO = new OrderItemDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    List<Order> orders = orderDAO.getAllOrders();
                    // Lấy danh sách Shippers (roleId = 4 giả định)
                    List<Account> shippers = accountDAO.getAccountsByRole(4);
                    
                    request.setAttribute("orderList", orders);
                    request.setAttribute("shipperList", shippers);
                    request.getRequestDispatcher("/staff/order-list.jsp").forward(request, response);
                    break;
                    
                case "detail":
                    long orderId = Long.parseLong(request.getParameter("id"));
                    Order order = orderDAO.getOrderById(orderId);
                    if (order == null) {
                        response.sendRedirect("orders?action=list&error=not_found");
                        return;
                    }
                    List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);
                    request.setAttribute("order", order);
                    request.setAttribute("itemList", items);
                    request.getRequestDispatcher("/staff/order-detail.jsp").forward(request, response);
                    break;
                default:
                    response.sendRedirect("orders?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orders?error=system_error");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        if (action == null) {
            response.sendRedirect("orders?action=list");
            return;
        }

        try {
            long orderId = Long.parseLong(request.getParameter("orderId"));
            
            switch (action) {
                case "confirm":
                    // Chuyển orderStatus = 2 (Đã xác nhận / Chờ đóng gói)
                    orderDAO.updateOrderStatus(orderId, (byte) 2);
                    response.sendRedirect("orders?action=list&msg=confirmed");
                    break;
                    
                case "ready":
                    // Chuyển orderStatus = 3 (Processing / Đóng gói xong) 
                    // and Set shippingStatus = 1 (Ready for Pickup)
                    orderDAO.updateOrderStatus(orderId, (byte) 3);
                    orderDAO.updateShippingStatus(orderId, (byte) 1);
                    response.sendRedirect("orders?action=list&msg=packed");
                    break;
                    
                case "assignShipper":
                    // Gán shipper
                    String shipperIdStr = request.getParameter("shipperId");
                    if (shipperIdStr != null && !shipperIdStr.trim().isEmpty()) {
                        long shipperId = Long.parseLong(shipperIdStr);
                        Order order = orderDAO.getOrderById(orderId);
                        
                        // Chỉ gán được khi đơn chưa hoàn thành/hủy (Tránh gán vào đơn Status 5 hoặc 6)
                        if (order != null && order.getOrderStatus() < 5) {
                            orderDAO.assignShipper(orderId, shipperId);
                            response.sendRedirect("orders?action=list&msg=shipper_assigned");
                        } else {
                            response.sendRedirect("orders?action=list&error=invalid_status");
                        }
                    } else {
                        response.sendRedirect("orders?action=list&error=missing_shipper");
                    }
                    break;
                    
                case "updatePayment":
                    // Cập nhật paymentStatus (VD: 2 = Đã thanh toán trong scale mới)
                    byte paymentStatus = Byte.parseByte(request.getParameter("paymentStatus"));
                    orderDAO.updatePaymentStatus(orderId, paymentStatus);
                    response.sendRedirect("orders?action=list&msg=payment_updated");
                    break;
                    
                case "complete":
                    // Chuyển orderStatus = 5 (Hoàn thành)
                    orderDAO.updateOrderStatus(orderId, (byte) 5);
                    response.sendRedirect("orders?action=list&msg=completed");
                    break;
                    
                case "cancel":
                    // Chuyển orderStatus = 6 (Đã hủy) với lý do
                    String cancelReason = request.getParameter("reason");
                    if (cancelReason == null || cancelReason.trim().isEmpty()) {
                        cancelReason = "Nh\u00e2n vi\u00ean h\u1ee7y \u0111\u01a1n";
                    }
                    orderDAO.updateOrderCancelReason(orderId, cancelReason);
                    response.sendRedirect("orders?action=list&msg=cancelled");
                    break;

                case "refund":
                    // Chuyển paymentStatus = 4 (Refunded)
                    orderDAO.refundOrder(orderId);
                    response.sendRedirect("orders?action=list&msg=refunded");
                    break;

                case "redeliver":
                    // Chuyển orderStatus = 2, shippingStatus = 0
                    orderDAO.redeliverOrder(orderId);
                    response.sendRedirect("orders?action=list&msg=redelivered");
                    break;

                default:
                    response.sendRedirect("orders?action=list");
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("orders?error=action_failed");
        }
    }
}
