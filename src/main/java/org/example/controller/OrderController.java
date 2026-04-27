package org.example.controller;

import org.example.dao.OrderDAO;
import org.example.model.auth.Account;
import org.example.model.order.Order;
import org.example.model.order.OrderItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/orders", "/orders/detail", "/order-success"})
public class OrderController extends HttpServlet {

    private final OrderDAO orderDAO = new OrderDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        
        if (getUser(req) == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        switch (req.getServletPath()) {
            case "/orders":        showOrderHistory(req, resp); break;
            case "/orders/detail": showOrderDetail(req, resp);  break;
            case "/order-success": showOrderSuccess(req, resp); break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
    }

    // ── Order history ─────────────────────────────────────────────────────────

    private void showOrderHistory(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user = getUser(req);
        
        int page = 1;
        int pageSize = 5; // Default items per page
        try {
            if (req.getParameter("page") != null) {
                page = Integer.parseInt(req.getParameter("page"));
            }
        } catch (NumberFormatException ignored) {}

        int offset = (page - 1) * pageSize;
        int totalOrders = orderDAO.countOrdersByAccount(user.getAccountId());
        int totalPages = (int) Math.ceil((double) totalOrders / pageSize);

        List<Order> orders = orderDAO.getOrdersByAccountPaginated(user.getAccountId(), offset, pageSize);
        
        req.setAttribute("orders", orders);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.setAttribute("pageSize", pageSize);
        
        req.getRequestDispatcher("/main/order-history.jsp").forward(req, resp);
    }

    // ── Order detail ──────────────────────────────────────────────────────────

    private void showOrderDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user = getUser(req);
        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/orders"); return; }

        try {
            long orderId = Long.parseLong(idParam);
            Order order  = orderDAO.getOrderById(orderId, user.getAccountId());
            if (order == null) { resp.sendRedirect(req.getContextPath() + "/orders"); return; }

            List<OrderItem> items = orderDAO.getOrderItemsByOrderId(orderId);
            req.setAttribute("order", order);
            req.setAttribute("orderItems", items);
            req.getRequestDispatcher("/main/order-detail.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }

    // ── Order success ─────────────────────────────────────────────────────────

    private void showOrderSuccess(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user = getUser(req);
        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendRedirect(req.getContextPath() + "/orders"); return; }

        try {
            long  orderId = Long.parseLong(idParam);
            Order order   = orderDAO.getOrderById(orderId, user.getAccountId());
            if (order == null) { resp.sendRedirect(req.getContextPath() + "/orders"); return; }

            req.setAttribute("order", order);
            req.getRequestDispatcher("/main/order-success.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/orders");
        }
    }


    private Account getUser(HttpServletRequest req) {
        return (Account) req.getSession().getAttribute("user");
    }
}
