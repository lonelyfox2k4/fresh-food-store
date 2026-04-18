package org.example.controller;

import org.example.dao.PricingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class PricingServlet extends HttpServlet {
    private final PricingDAO pricingDAO = new PricingDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("pricingList", pricingDAO.getInventoryWithPricing());
        request.getRequestDispatcher("/manager/pricing.jsp").forward(request, response);
    }
}
