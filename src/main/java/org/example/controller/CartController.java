package org.example.controller;

import org.example.dao.CartDAO;
import org.example.dao.ProductPackDAO;
import org.example.dto.CartItemDTO;
import org.example.model.auth.Account;
import org.example.model.catalog.ProductPack;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartController extends HttpServlet {

    private final CartDAO        cartDAO = new CartDAO();
    private final ProductPackDAO packDAO = new ProductPackDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/cart".equals(req.getServletPath())) {
            showCart(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        switch (req.getServletPath()) {
            case "/cart/add":    handleAdd(req, resp);    break;
            case "/cart/update": handleUpdate(req, resp); break;
            case "/cart/remove": handleRemove(req, resp); break;
        }
    }

    // ── View cart ────────────────────────────────────────────────────────────

    private void showCart(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        Account user   = getUser(req);
        long    cartId = cartDAO.getOrCreateCart(user.getAccountId());
        List<CartItemDTO> items = cartDAO.getCartItems(cartId);

        // Compute subtotal server-side (EL 2.x does not support stream API)
        java.math.BigDecimal cartSubtotal = items.stream()
                .map(org.example.dto.CartItemDTO::getLineTotal)
                .reduce(java.math.BigDecimal.ZERO, java.math.BigDecimal::add);

        req.setAttribute("cartItems",    items);
        req.setAttribute("cartId",       cartId);
        req.setAttribute("cartSubtotal", cartSubtotal);
        req.getRequestDispatcher("/cart.jsp").forward(req, resp);
    }

    // ── Add item ─────────────────────────────────────────────────────────────

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String packIdParam = req.getParameter("productPackId");
        String qtyParam    = req.getParameter("quantity");

        if (packIdParam == null) { resp.sendRedirect(req.getContextPath() + "/products"); return; }

        long packId; int qty = 1;
        try { packId = Long.parseLong(packIdParam); }
        catch (NumberFormatException e) { resp.sendRedirect(req.getContextPath() + "/products"); return; }
        try { if (qtyParam != null) qty = Math.max(1, Integer.parseInt(qtyParam)); }
        catch (NumberFormatException ignored) {}

        // Validate pack exists
        ProductPack pack = packDAO.getPackById(packId);
        if (pack == null) { resp.sendRedirect(req.getContextPath() + "/products"); return; }

        Account user   = getUser(req);
        long    cartId = cartDAO.getOrCreateCart(user.getAccountId());
        cartDAO.addItem(cartId, packId, qty);
        updateCartCountInSession(req, user.getAccountId());

        // Redirect back to product detail or referer
        String referer = req.getHeader("Referer");
        resp.sendRedirect(referer != null ? referer : req.getContextPath() + "/cart");
    }

    // ── Update quantity ───────────────────────────────────────────────────────

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            long   cartItemId = Long.parseLong(req.getParameter("cartItemId"));
            int    quantity   = Integer.parseInt(req.getParameter("quantity"));
            Account user      = getUser(req);
            cartDAO.updateQuantity(cartItemId, quantity);
            updateCartCountInSession(req, user.getAccountId());
        } catch (NumberFormatException ignored) {}
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    // ── Remove item ───────────────────────────────────────────────────────────

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            long    cartItemId = Long.parseLong(req.getParameter("cartItemId"));
            Account user       = getUser(req);
            cartDAO.removeItem(cartItemId);
            updateCartCountInSession(req, user.getAccountId());
        } catch (NumberFormatException ignored) {}
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private Account getUser(HttpServletRequest req) {
        return (Account) req.getSession().getAttribute("user");
    }

    private void updateCartCountInSession(HttpServletRequest req, long accountId) {
        int count = cartDAO.countItems(accountId);
        req.getSession().setAttribute("cartCount", count);
    }
}
