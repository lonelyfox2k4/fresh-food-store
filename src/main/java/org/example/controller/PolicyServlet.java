package org.example.controller;

import org.example.dao.PolicyDAO;
import org.example.model.catalog.ExpiryPricingPolicy;
import org.example.model.catalog.ExpiryPricingPolicyRule;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class PolicyServlet extends HttpServlet {
    private final PolicyDAO policyDAO = new PolicyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "edit-rules":
                showRulesForm(request, response);
                break;
            default:
                listPolicies(request, response);
                break;
        }
    }

    private void listPolicies(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("policies", policyDAO.getAllPolicies());
        request.getRequestDispatcher("/admin/policies.jsp").forward(request, response);
    }

    private void showRulesForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("policy", policyDAO.getPolicyById(id));
        request.setAttribute("rules", policyDAO.getRulesByPolicyId(id));
        request.getRequestDispatcher("/admin/policy-rules.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if ("save-rules".equals(action)) {
            saveRules(request, response);
        } else {
            savePolicy(request, response);
        }
    }

    private void savePolicy(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String idStr = request.getParameter("id");
        ExpiryPricingPolicy p = new ExpiryPricingPolicy();
        p.setPolicyName(request.getParameter("policyName"));
        p.setNote(request.getParameter("note"));
        p.setStatus(request.getParameter("status") != null);

        if (idStr == null || idStr.isEmpty()) {
            policyDAO.insertPolicy(p);
        } else {
            p.setPolicyId(Integer.parseInt(idStr));
            policyDAO.updatePolicy(p);
        }
        response.sendRedirect("policies");
    }

    private void saveRules(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int policyId = Integer.parseInt(request.getParameter("policyId"));
        String[] days = request.getParameterValues("minDaysRemaining");
        String[] percents = request.getParameterValues("sellPricePercent");
        
        List<ExpiryPricingPolicyRule> rules = new ArrayList<>();
        if (days != null) {
            for (int i = 0; i < days.length; i++) {
                if (!days[i].isEmpty() && !percents[i].isEmpty()) {
                    ExpiryPricingPolicyRule r = new ExpiryPricingPolicyRule();
                    r.setMinDaysRemaining(Integer.parseInt(days[i]));
                    r.setSellPricePercent(new BigDecimal(percents[i]));
                    rules.add(r);
                }
            }
        }
        policyDAO.saveRules(policyId, rules);
        response.sendRedirect("policies");
    }
}
