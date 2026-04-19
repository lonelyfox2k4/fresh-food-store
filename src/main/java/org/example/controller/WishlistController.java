package org.example.controller;

import org.example.dao.WishlistDAO;
import org.example.model.auth.Account;
import org.example.model.marketing.WishlistItemView;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/wishlist", "/wishlist/add", "/wishlist/remove"})
public class WishlistController extends HttpServlet {
    private final WishlistDAO wishlistDAO = new WishlistDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        List<WishlistItemView> items = wishlistDAO.getWishlistItemsByAccountIdOrderByName(currentUser.getAccountId());
        req.setAttribute("wishlistItems", items);
        moveFlashToRequest(req, "wishlistSuccessMsg");
        moveFlashToRequest(req, "wishlistErrorMsg");
        moveFlashToRequest(req, "cartSuccessMsg");
        moveFlashToRequest(req, "cartErrorMsg");
        req.getRequestDispatcher("/main/wishlist.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Account currentUser = getSessionUser(req);
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getServletPath();
        if ("/wishlist/add".equals(path)) {
            handleToggle(req, resp, currentUser, true);
            return;
        }
        if ("/wishlist/remove".equals(path)) {
            handleToggle(req, resp, currentUser, false);
            return;
        }
        resp.sendRedirect(req.getContextPath() + "/wishlist");
    }

    private void handleToggle(HttpServletRequest req, HttpServletResponse resp, Account currentUser, boolean addMode) throws IOException {
        long productId = parsePositiveLong(req.getParameter("productId"));
        if (productId <= 0) {
            setFlash(req, "wishlistErrorMsg", "Dữ liệu sản phẩm không hợp lệ.");
            resp.sendRedirect(resolveReturnUrl(req));
            return;
        }

        long accountId = currentUser.getAccountId();
        boolean exists = wishlistDAO.exists(accountId, productId);

        if (addMode) {
            if (exists) {
                boolean removed = wishlistDAO.removeByProductId(accountId, productId);
                if (removed) {
                    setFlash(req, "wishlistSuccessMsg", "Đã bỏ khỏi danh sách yêu thích.");
                } else {
                    setFlash(req, "wishlistErrorMsg", "Không thể cập nhật yêu thích. Vui lòng thử lại.");
                }
            } else {
                boolean added = wishlistDAO.add(accountId, productId);
                if (added) {
                    setFlash(req, "wishlistSuccessMsg", "Đã thêm vào danh sách yêu thích.");
                } else {
                    setFlash(req, "wishlistErrorMsg", "Không thể thêm vào yêu thích. Vui lòng thử lại.");
                }
            }
        } else {
            if (!exists) {
                setFlash(req, "wishlistSuccessMsg", "Sản phẩm không còn trong danh sách yêu thích.");
            } else {
                boolean removed = wishlistDAO.removeByProductId(accountId, productId);
                if (removed) {
                    setFlash(req, "wishlistSuccessMsg", "Đã bỏ khỏi danh sách yêu thích.");
                } else {
                    setFlash(req, "wishlistErrorMsg", "Không thể xóa khỏi yêu thích. Vui lòng thử lại.");
                }
            }
        }

        resp.sendRedirect(resolveReturnUrl(req));
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

    private void setFlash(HttpServletRequest req, String key, String value) {
        req.getSession().setAttribute(key, value);
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

    private long parsePositiveLong(String value) {
        try {
            long num = Long.parseLong(value == null ? "" : value.trim());
            return num > 0 ? num : -1;
        } catch (Exception e) {
            return -1;
        }
    }
}
