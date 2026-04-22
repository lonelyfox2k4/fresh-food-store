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
        
        // Mock fallback cho test nếu không đăng nhập (shipperId = 2)
        long shipperId = (user != null) ? user.getAccountId() : 2L;

        try {
            if ("list".equals(action)) {
                List<Order> orders = orderDAO.getOrdersByShipper(shipperId);
                List<Order> availableOrders = orderDAO.getAvailableOrders();
                request.setAttribute("orderList", orders);
                request.setAttribute("availableList", availableOrders);
                request.getRequestDispatcher("/shipper/order-list.jsp").forward(request, response);
            } else if ("detail".equals(action)) {
                long orderId = Long.parseLong(request.getParameter("id"));
                Order order = orderDAO.getOrderById(orderId);
                // Security check: Only assigned shipper can view
                if (order == null || order.getShipperId() == null || order.getShipperId() != shipperId) {
                    response.sendRedirect("orders?action=list&error=unauthorized");
                    return;
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
        long currentShipperId = (user != null) ? user.getAccountId() : 2L; // Mock fallback for test

        try {
            long orderId = Long.parseLong(request.getParameter("orderId"));
            Order order = orderDAO.getOrderById(orderId);

            // Handle CLAIM action separately (it doesn't require an assigned shipper yet)
            if ("claim".equals(action)) {
                boolean success = orderDAO.claimOrder(orderId, currentShipperId);
                if (success) {
                    response.sendRedirect("orders?action=list&msg=claimed");
                } else {
                    response.sendRedirect("orders?action=list&error=claim_failed");
                }
                return;
            }

            // Security check: Only assigned shipper can update delivery status
            if (order == null || order.getShipperId() == null || order.getShipperId() != currentShipperId) {
                response.sendRedirect("orders?action=list&error=unauthorized");
                return;
            }

            switch (action) {
                case "startShipping":
                    // Atomic start: updates shippingStatus=2 and orderStatus=4
                    orderDAO.updateStartShipping(orderId);
                    response.sendRedirect("orders?action=list&msg=started");
                    break;
                    
                case "delivered":
                    // Atomic success: updates shipping=3, order=5, payment=2
                    orderDAO.updateDeliverySuccess(orderId);
                    response.sendRedirect("orders?action=list&msg=delivered");
                    break;
                    
                case "failed":
                    // Atomic failure: updates shippingStatus=4 and cancels (orderStatus=6)
                    String failReason = request.getParameter("reason");
                    if (failReason != null && !failReason.isEmpty()) {
                        orderDAO.updateDeliveryFailure(orderId, failReason);
                    }
                    response.sendRedirect("orders?action=list&msg=failed");
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
