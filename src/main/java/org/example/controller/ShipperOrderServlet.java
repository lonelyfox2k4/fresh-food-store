package org.example.controller;

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

@WebServlet(name = "ShipperOrderServlet", urlPatterns = {"/shipper/orders"})
public class ShipperOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        Account user = (Account) request.getSession().getAttribute("user");
        long shipperId = (user != null) ? user.getAccountId() : 0L;

        try {
            if ("list".equals(action)) {
                List<Order> availableOrders = orderDAO.getAvailableOrders();
                List<Order> myTasks = orderDAO.getShipperTasks(shipperId);
                java.util.Map<String, Object> stats = orderDAO.getShipperStats(shipperId);
                boolean isBusy = orderDAO.isShipperBusy(shipperId);
                
                request.setAttribute("availableList", availableOrders);
                request.setAttribute("myTasks", myTasks);
                request.setAttribute("stats", stats);
                request.setAttribute("isBusy", isBusy);
                request.getRequestDispatcher("/shipper/order-list.jsp").forward(request, response);
            } else if ("claim".equals(action)) {
                long orderId = Long.parseLong(request.getParameter("id"));
                if (orderDAO.isShipperBusy(shipperId)) {
                    response.sendRedirect("orders?action=list&error=busy");
                    return;
                }
                if (orderDAO.assignShipper(orderId, shipperId)) {
                    request.getSession().setAttribute("orderMsg", "success:Nhận đơn hàng thành công!");
                    response.sendRedirect("orders?action=list");
                } else {
                    request.getSession().setAttribute("orderMsg", "danger:Không thể nhận đơn hàng này!");
                    response.sendRedirect("orders?action=list");
                }
            } else if ("detail".equals(action) || "available-detail".equals(action)) {
                long orderId = Long.parseLong(request.getParameter("id"));
                Order order = orderDAO.getOrderById(orderId);
                
                // Security check for assigned orders
                if ("detail".equals(action)) {
                    if (order == null || order.getShipperId() == null || order.getShipperId() != shipperId) {
                        response.sendRedirect("orders?action=list&error=unauthorized");
                        return;
                    }
                } else {
                    // Check for available orders
                    if (order == null || order.getOrderStatus() != 3 || order.getShipperId() != null) {
                        response.sendRedirect("orders?action=list&error=invalid_order");
                        return;
                    }
                }
                
                List<OrderItem> items = new OrderItemDAO().getOrderItemsByOrderId(orderId);
                request.setAttribute("order", order);
                request.setAttribute("itemList", items);
                request.getRequestDispatcher("/shipper/order-detail.jsp").forward(request, response);
            } else {
                response.sendRedirect("orders?action=list");
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

        Account user = (Account) request.getSession().getAttribute("user");
        long currentShipperId = (user != null) ? user.getAccountId() : 0L;

        try {
            String idStr = request.getParameter("id");
            if (idStr == null) idStr = request.getParameter("orderId");
            
            if ("claim".equals(action)) {
                if (idStr == null) {
                    response.sendRedirect("orders?action=list&error=no_id");
                    return;
                }
                long orderId = Long.parseLong(idStr);
                if (orderDAO.isShipperBusy(currentShipperId)) {
                    response.sendRedirect("orders?action=list&error=busy");
                    return;
                }
                if (orderDAO.assignShipper(orderId, currentShipperId)) {
                    request.getSession().setAttribute("orderMsg", "success:Nhận đơn hàng thành công!");
                    response.sendRedirect("orders?action=list");
                } else {
                    request.getSession().setAttribute("orderMsg", "danger:Không thể nhận đơn hàng này!");
                    response.sendRedirect("orders?action=list");
                }
                return;
            }

            if ("remit".equals(action)) {
                orderDAO.remitCOD(currentShipperId);
                request.getSession().setAttribute("orderMsg", "success:Đã nộp tiền COD thành công!");
                response.sendRedirect("orders?action=list");
                return;
            }

            if (idStr == null) {
                response.sendRedirect("orders?action=list&error=no_id");
                return;
            }
            long orderId = Long.parseLong(idStr);
            Order order = orderDAO.getOrderById(orderId);

            if (order == null || order.getShipperId() == null || order.getShipperId() != currentShipperId) {
                response.sendRedirect("orders?action=list&error=unauthorized");
                return;
            }

            switch (action) {
                case "startShipping":
                    orderDAO.updateStartShipping(orderId);
                    request.getSession().setAttribute("orderMsg", "success:Bắt đầu giao hàng!");
                    response.sendRedirect("orders?action=list");
                    break;
                case "delivered":
                    orderDAO.updateDeliverySuccess(orderId);
                    request.getSession().setAttribute("orderMsg", "success:Giao hàng thành công! Đã ghi nhận thanh toán.");
                    response.sendRedirect("orders?action=list");
                    break;
                case "failed":
                    String failReason = request.getParameter("reason");
                    if (failReason != null && !failReason.isEmpty()) {
                        orderDAO.updateDeliveryFailure(orderId, failReason);
                        request.getSession().setAttribute("orderMsg", "danger:Đã báo cáo giao hàng thất bại.");
                    }
                    response.sendRedirect("orders?action=list");
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
