package org.example.controller;

import org.example.dao.VoucherDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.VoucherRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ManagerVoucherServlet", urlPatterns = {"/manager/voucher-requests"})
public class ManagerVoucherServlet extends HttpServlet {

    private VoucherDAO voucherDAO;

    @Override
    public void init() throws ServletException {
        voucherDAO = new VoucherDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Account user = (Account) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        List<VoucherRequest> list = voucherDAO.getPendingVoucherRequests();
        request.setAttribute("voucherRequests", list);
        request.getRequestDispatcher("/manager/voucher-requests.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            long requestId = Long.parseLong(request.getParameter("requestId"));
            Account manager = (Account) request.getSession().getAttribute("user");
            
            if (manager == null || manager.getRoleId() != 2) {
                response.sendRedirect(request.getContextPath() + "/home");
                return;
            }

            int newStatus = 0;
            String msg = "";
            
            if ("approve".equals(action)) {
                newStatus = 1; // Approved
                msg = "approved";
            } else if ("reject".equals(action)) {
                newStatus = 2; // Rejected
                msg = "rejected";
            }

            if (newStatus > 0) {
                boolean success = voucherDAO.handleVoucherRequest(requestId, newStatus, manager.getAccountId());
                if (success) {
                    response.sendRedirect("voucher-requests?msg=" + msg);
                } else {
                    response.sendRedirect("voucher-requests?error=failed");
                }
            } else {
                response.sendRedirect("voucher-requests");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("voucher-requests?error=invalid");
        }
    }
}
