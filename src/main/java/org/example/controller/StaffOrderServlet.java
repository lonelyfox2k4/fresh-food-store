package org.example.controller;

import org.example.dao.AccountDAO;
import org.example.dao.OrderDAO;
import org.example.dao.OrderItemDAO;
import org.example.model.auth.Account;
import org.example.utils.RoleConstant;
import org.example.model.order.Order;
import org.example.model.order.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "StaffOrderServlet", urlPatterns = { "/staff/orders" })
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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "list":
                    String query = request.getParameter("query");
                    int page = 1;
                    int pageSize = 10; // Default items per page
                    
                    try {
                        String pageStr = request.getParameter("page");
                        if (pageStr != null && !pageStr.isEmpty()) {
                            page = Integer.parseInt(pageStr);
                        }
                    } catch (NumberFormatException ignored) {}

                    int offset = (page - 1) * pageSize;
                    List<Order> orders;
                    int totalOrders;

                    if (query != null && !query.trim().isEmpty()) {
                        String trimmedQuery = query.trim();
                        orders = orderDAO.searchOrdersPaginated(trimmedQuery, offset, pageSize);
                        totalOrders = orderDAO.countSearchOrders(trimmedQuery);
                        request.setAttribute("searchQuery", trimmedQuery);
                    } else {
                        orders = orderDAO.getAllOrdersPaginated(offset, pageSize);
                        totalOrders = orderDAO.countAllOrders();
                    }

                    int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

                    // Lấy danh sách Shippers sử dụng RoleConstant mới
                    List<Account> shippers = accountDAO.getAccountsByRole(RoleConstant.SHIPPER);
                    
                    request.setAttribute("orderList", orders);
                    request.setAttribute("shipperList", shippers);
                    request.setAttribute("currentPage", page);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("pageSize", pageSize);

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
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
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
                    // Chuyển orderStatus = 3 (Đóng gói xong)
                    orderDAO.updateOrderStatus(orderId, (byte) 3);
                    response.sendRedirect("orders?action=list&msg=packed");
                    break;

                case "assignShipper":
                    // Gán shipper
                    String shipperIdStr = request.getParameter("shipperId");
                    if (shipperIdStr != null && !shipperIdStr.trim().isEmpty()) {
                        long shipperId = Long.parseLong(shipperIdStr);
                        Order order = orderDAO.getOrderById(orderId);

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
                    byte paymentStatus = Byte.parseByte(request.getParameter("paymentStatus"));
                    orderDAO.updatePaymentStatus(orderId, paymentStatus);
                    response.sendRedirect("orders?action=list&msg=payment_updated");
                    break;

                case "complete":
                    orderDAO.updateOrderStatus(orderId, (byte) 5);
                    response.sendRedirect("orders?action=list&msg=completed");
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
