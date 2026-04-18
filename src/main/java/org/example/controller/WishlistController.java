package org.example.controller;

import org.example.dao.WishlistDAO;
import org.example.model.auth.Account;
import org.example.model.catalog.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/wishlist", "/wishlist/toggle"})
public class WishlistController extends HttpServlet {

    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/wishlist".equals(req.getServletPath())) {
            Account user = (Account) req.getSession().getAttribute("user");
            List<Product> wishlist = wishlistDAO.getWishlist(user.getAccountId());
            req.setAttribute("wishlist", wishlist);
            req.getRequestDispatcher("/wishlist.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        if ("/wishlist/toggle".equals(req.getServletPath())) {
            Account user = (Account) req.getSession().getAttribute("user");
            String productIdParam = req.getParameter("productId");
            if (productIdParam == null) { resp.sendRedirect(req.getContextPath() + "/wishlist"); return; }

            try {
                long productId = Long.parseLong(productIdParam);
                boolean isIn = wishlistDAO.isInWishlist(user.getAccountId(), productId);
                if (isIn) {
                    wishlistDAO.removeFromWishlist(user.getAccountId(), productId);
                } else {
                    wishlistDAO.addToWishlist(user.getAccountId(), productId);
                }
            } catch (NumberFormatException ignored) {}

            // Redirect back to product detail or referer
            String redirect = req.getParameter("redirect");
            String referer  = req.getHeader("Referer");
            resp.sendRedirect(redirect != null ? redirect
                    : (referer != null ? referer : req.getContextPath() + "/wishlist"));
        }
    }
}
