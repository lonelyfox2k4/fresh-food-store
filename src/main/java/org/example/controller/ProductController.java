package org.example.controller;

import org.example.dao.CategoryDAO;
import org.example.dao.ProductDAO;
import org.example.dao.ProductPackDAO;
import org.example.dao.WishlistDAO;
import org.example.model.auth.Account;
import org.example.model.catalog.Category;
import org.example.model.catalog.Product;
import org.example.model.catalog.ProductPack;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/products", "/product-detail"})
public class ProductController extends HttpServlet {

    private final ProductDAO     productDAO  = new ProductDAO();
    private final CategoryDAO    categoryDAO = new CategoryDAO();
    private final ProductPackDAO packDAO     = new ProductPackDAO();
    private final WishlistDAO    wishlistDAO = new WishlistDAO();

    private static final int PAGE_SIZE = 12;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getServletPath();

        if ("/products".equals(path)) {
            handleProductList(req, resp);
        } else if ("/product-detail".equals(path)) {
            handleProductDetail(req, resp);
        }
    }

    // ── Product Listing ──────────────────────────────────────────────────────

    private void handleProductList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String keyword    = req.getParameter("keyword");
        String catParam   = req.getParameter("category");
        String pageParam  = req.getParameter("page");

        Integer categoryId = null;
        try { if (catParam != null) categoryId = Integer.parseInt(catParam); }
        catch (NumberFormatException ignored) {}

        int page = 1;
        try { if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam)); }
        catch (NumberFormatException ignored) {}

        int offset     = (page - 1) * PAGE_SIZE;
        int totalCount = productDAO.countProducts(keyword, categoryId);
        int totalPages = (int) Math.ceil((double) totalCount / PAGE_SIZE);

        List<Product>  products   = productDAO.searchProducts(keyword, categoryId, offset, PAGE_SIZE);
        List<Category> categories = categoryDAO.getAllActiveCategories();

        req.setAttribute("products",       products);
        req.setAttribute("categories",     categories);
        req.setAttribute("keyword",        keyword);
        req.setAttribute("selectedCatId",  categoryId);
        req.setAttribute("currentPage",    page);
        req.setAttribute("totalPages",     totalPages);
        req.setAttribute("totalCount",     totalCount);

        req.getRequestDispatcher("/products.jsp").forward(req, resp);
    }

    // ── Product Detail ───────────────────────────────────────────────────────

    private void handleProductDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        if (idParam == null) { resp.sendRedirect("products"); return; }

        long productId;
        try { productId = Long.parseLong(idParam); }
        catch (NumberFormatException e) { resp.sendRedirect("products"); return; }

        Product product = productDAO.getActiveProductById(productId);
        if (product == null) { resp.sendRedirect("products"); return; }

        List<ProductPack> packs    = packDAO.getPacksByProductId(productId);

        req.setAttribute("product",     product);
        req.setAttribute("packs",       packs);

        // Check wishlist status
        boolean inWishlist = false;
        HttpSession session = req.getSession(false);
        if (session != null) {
            Account user = (Account) session.getAttribute("user");
            if (user != null) {
                inWishlist = wishlistDAO.exists(user.getAccountId(), productId);
            }
        }
        req.setAttribute("inWishlist", inWishlist);

        req.getRequestDispatcher("/product-detail.jsp").forward(req, resp);
    }
}
