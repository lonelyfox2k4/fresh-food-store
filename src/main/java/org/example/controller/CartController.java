package org.example.controller;

import org.example.dao.CartDAO;
import org.example.model.auth.Account;
import org.example.model.order.CartItemView;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(urlPatterns = {"/cart", "/cart/add", "/cart/update", "/cart/remove"})
public class CartController extends HttpServlet {
    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        long accountId = currentUser.getAccountId();
        cartDAO.findOrCreateCartIdByAccountId(accountId);

        List<CartItemView> cartItems = cartDAO.getCartItemsByAccountId(accountId);
        BigDecimal cartTotal = cartDAO.getCartTotalAmount(accountId);

        req.setAttribute("cartItems", cartItems);
        req.setAttribute("cartTotal", cartTotal);
        moveFlashToRequest(req, "cartSuccessMsg");
        moveFlashToRequest(req, "cartErrorMsg");
        req.getRequestDispatcher("/main/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String servletPath = req.getServletPath();
        if ("/cart/add".equals(servletPath)) {
            handleAdd(req, resp, currentUser);
            return;
        }
        if ("/cart/update".equals(servletPath)) {
            handleUpdate(req, resp, currentUser);
            return;
        }
        if ("/cart/remove".equals(servletPath)) {
            handleRemove(req, resp, currentUser);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        long accountId = currentUser.getAccountId();
        String packIdRaw = req.getParameter("productPackId");
        String productIdRaw = req.getParameter("productId");
        String quantityRaw = req.getParameter("quantity");

        int quantity = parsePositiveInt(quantityRaw);
        if (quantity <= 0) {
            setFlash(req, "cartErrorMsg", "Số lượng sản phẩm không hợp lệ.");
            resp.sendRedirect(resolveReturnUrl(req));
            return;
        }

        Long productPackId = parsePositiveLong(packIdRaw);
        if (productPackId <= 0) {
            // Fallback to productId (e.g. from Home page quick-add)
            long productId = parsePositiveLong(productIdRaw);
            if (productId > 0) {
                productPackId = cartDAO.getDefaultPackIdByProductId(productId);
            }
        }

        if (productPackId == null || productPackId <= 0) {
            setFlash(req, "cartErrorMsg", "Dữ liệu sản phẩm không hợp lệ hoặc chưa có quy cách bán.");
            resp.sendRedirect(resolveReturnUrl(req));
            return;
        }

        boolean ok = cartDAO.addOrIncreaseItem(accountId, productPackId, quantity);
        if (ok) {
            refreshCartCount(req, accountId);
            setFlash(req, "cartSuccessMsg", "Đã thêm sản phẩm vào giỏ hàng.");
        } else {
            setFlash(req, "cartErrorMsg", "Không thể thêm vào giỏ hàng. Vui lòng thử lại.");
        }
        resp.sendRedirect(resolveReturnUrl(req));
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        long accountId = currentUser.getAccountId();
        long cartItemId = parsePositiveLong(req.getParameter("cartItemId"));
        String quantityRaw = req.getParameter("quantity");
        int quantity = parseInt(quantityRaw);

        if (cartItemId <= 0) {
            setFlash(req, "cartErrorMsg", "Không tìm thấy item cần cập nhật.");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        boolean ok;
        if (quantity <= 0) {
            ok = cartDAO.removeItem(accountId, cartItemId);
            if (ok) {
                setFlash(req, "cartSuccessMsg", "Đã xóa sản phẩm khỏi giỏ hàng.");
            } else {
                setFlash(req, "cartErrorMsg", "Xóa sản phẩm thất bại.");
            }
        } else {
            ok = cartDAO.updateItemQuantity(accountId, cartItemId, quantity);
            if (ok) {
                setFlash(req, "cartSuccessMsg", "Cập nhật số lượng thành công.");
            } else {
                setFlash(req, "cartErrorMsg", "Cập nhật số lượng thất bại.");
            }
        }
        refreshCartCount(req, accountId);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp, Account currentUser) throws IOException {
        long accountId = currentUser.getAccountId();
        long cartItemId = parsePositiveLong(req.getParameter("cartItemId"));
        if (cartItemId <= 0) {
            setFlash(req, "cartErrorMsg", "Không tìm thấy item cần xóa.");
            resp.sendRedirect(req.getContextPath() + "/cart");
            return;
        }

        boolean ok = cartDAO.removeItem(accountId, cartItemId);
        if (ok) {
            setFlash(req, "cartSuccessMsg", "Đã xóa sản phẩm khỏi giỏ hàng.");
        } else {
            setFlash(req, "cartErrorMsg", "Xóa sản phẩm thất bại.");
        }
        refreshCartCount(req, accountId);
        resp.sendRedirect(req.getContextPath() + "/cart");
    }

    private Account getSessionUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        Object user = session.getAttribute("user");
        if (!(user instanceof Account)) {
            return null;
        }
        return (Account) user;
    }

    private void refreshCartCount(HttpServletRequest req, long accountId) {
        int cartLines = cartDAO.countCartLines(accountId);
        req.getSession().setAttribute("cartCount", cartLines);
    }

    private void setFlash(HttpServletRequest req, String key, String message) {
        req.getSession().setAttribute(key, message);
    }

    private void moveFlashToRequest(HttpServletRequest req, String key) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return;
        }
        Object value = session.getAttribute(key);
        if (value != null) {
            req.setAttribute(key, value);
            session.removeAttribute(key);
        }
    }

    private String resolveReturnUrl(HttpServletRequest req) {
        String returnUrl = req.getParameter("returnUrl");
        if (returnUrl != null && returnUrl.startsWith(req.getContextPath() + "/")) {
            return returnUrl;
        }
        String referer = req.getHeader("Referer");
        if (referer != null && !referer.trim().isEmpty()) {
            return referer;
        }
        return req.getContextPath() + "/home";
    }

    private int parsePositiveInt(String value) {
        int num = parseInt(value);
        return num > 0 ? num : -1;
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value == null ? "" : value.trim());
        } catch (Exception e) {
            return -1;
        }
    }

    private long parsePositiveLong(String value) {
        try {
            long num = Long.parseLong(value == null ? "" : value.trim());
            return num > 0 ? num : -1;
        } catch (Exception e) {
            return -1;
        }
    }
}
