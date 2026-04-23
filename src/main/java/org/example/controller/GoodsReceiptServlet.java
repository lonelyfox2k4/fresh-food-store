package org.example.controller;

import org.example.dao.InventoryDAO;
import org.example.dao.SupplierDAO;
import org.example.dto.inventory.GoodsReceiptForm;
import org.example.dto.inventory.GoodsReceiptLineForm;
import org.example.model.auth.Account;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class GoodsReceiptServlet extends HttpServlet {
    private final InventoryDAO inventoryDAO = new InventoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.isEmpty()) {
            action = "list";
        }

        switch (action) {
            case "detail":
                showDetail(request, response);
                break;
            case "new":
                showForm(request, response, createBlankForm(resolveLineCount(request)));
                break;
            case "edit":
                showEditForm(request, response);
                break;
            default:
                listReceipts(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String mode = request.getParameter("mode");
        GoodsReceiptForm form = buildFormFromRequest(request);

        if ("add-line".equals(mode)) {
            form.getLines().add(new GoodsReceiptLineForm());
            showForm(request, response, form);
            return;
        }

        try {
            Account user = (Account) request.getSession().getAttribute("user");
            long accountId = user != null ? user.getAccountId() : 1L;
            if (form.getReceiptId() == null) {
                long receiptId = inventoryDAO.createReceipt(form, accountId);
                response.sendRedirect(request.getContextPath() + "/manager/goods-receipts?action=detail&id=" + receiptId);
            } else {
                inventoryDAO.updateReceipt(form, accountId);
                response.sendRedirect(request.getContextPath() + "/manager/goods-receipts?action=detail&id=" + form.getReceiptId());
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            showForm(request, response, form);
        }
    }

    private void listReceipts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("receipts", inventoryDAO.getGoodsReceiptList());
        request.getRequestDispatcher("/manager/goods-receipts.jsp").forward(request, response);
    }

    private void showDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long id = Long.parseLong(request.getParameter("id"));
        request.setAttribute("receipt", inventoryDAO.getGoodsReceiptDetail(id));
        request.getRequestDispatcher("/manager/goods-receipt-detail.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long id = Long.parseLong(request.getParameter("id"));
        org.example.dto.inventory.GoodsReceiptView detail = inventoryDAO.getGoodsReceiptDetail(id);
        if (detail == null) {
            response.sendRedirect(request.getContextPath() + "/manager/goods-receipts");
            return;
        }
        if (!detail.isEditable()) {
            request.setAttribute("error", "Phiếu nhập này đã có phát sinh nên không thể chỉnh sửa.");
            request.setAttribute("receipt", detail);
            request.getRequestDispatcher("/manager/goods-receipt-detail.jsp").forward(request, response);
            return;
        }
        GoodsReceiptForm form = inventoryDAO.getReceiptForm(id);
        if (form == null) {
            response.sendRedirect(request.getContextPath() + "/manager/goods-receipts");
            return;
        }
        if (form.getLines().isEmpty()) {
            form.getLines().add(new GoodsReceiptLineForm());
        }
        showForm(request, response, form);
    }

    private void showForm(HttpServletRequest request, HttpServletResponse response, GoodsReceiptForm form) throws ServletException, IOException {
        request.setAttribute("form", form);
        request.setAttribute("suppliers", supplierDAO.getActiveSuppliers());
        request.setAttribute("productPacks", inventoryDAO.getActiveProductPackOptions());
        request.getRequestDispatcher("/manager/goods-receipt-form.jsp").forward(request, response);
    }

    private GoodsReceiptForm createBlankForm(int lineCount) {
        GoodsReceiptForm form = new GoodsReceiptForm();
        form.setReceivedAt(LocalDateTime.now().withSecond(0).withNano(0));
        form.setReceiptCode("GR-" + System.currentTimeMillis());
        for (int i = 0; i < lineCount; i++) {
            form.getLines().add(new GoodsReceiptLineForm());
        }
        return form;
    }

    private int resolveLineCount(HttpServletRequest request) {
        String count = request.getParameter("lineCount");
        if (count == null || count.isEmpty()) {
            return 2;
        }
        try {
            int parsed = Integer.parseInt(count);
            return Math.max(parsed, 1);
        } catch (NumberFormatException e) {
            return 2;
        }
    }

    private GoodsReceiptForm buildFormFromRequest(HttpServletRequest request) {
        GoodsReceiptForm form = new GoodsReceiptForm();
        String receiptId = request.getParameter("receiptId");
        if (receiptId != null && !receiptId.isEmpty()) {
            form.setReceiptId(Long.parseLong(receiptId));
        }
        form.setReceiptCode(request.getParameter("receiptCode"));
        String supplierId = request.getParameter("supplierId");
        if (supplierId != null && !supplierId.isEmpty()) {
            form.setSupplierId(Long.parseLong(supplierId));
        }
        String receivedAt = request.getParameter("receivedAt");
        if (receivedAt != null && !receivedAt.isEmpty()) {
            form.setReceivedAt(LocalDateTime.parse(receivedAt));
        }
        form.setNote(request.getParameter("note"));

        String[] receiptItemIds = request.getParameterValues("receiptItemId");
        String[] productPackIds = request.getParameterValues("productPackId");
        String[] batchCodes = request.getParameterValues("batchCode");
        String[] manufactureDates = request.getParameterValues("manufactureDate");
        String[] expiryDates = request.getParameterValues("expiryDate");
        String[] quantities = request.getParameterValues("quantityReceived");
        String[] unitCosts = request.getParameterValues("unitCost");
        String[] notes = request.getParameterValues("lineNote");

        int count = productPackIds == null ? 0 : productPackIds.length;
        List<GoodsReceiptLineForm> lines = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            GoodsReceiptLineForm line = new GoodsReceiptLineForm();
            if (receiptItemIds != null && receiptItemIds.length > i && receiptItemIds[i] != null && !receiptItemIds[i].isEmpty()) {
                line.setReceiptItemId(Long.parseLong(receiptItemIds[i]));
            }
            if (productPackIds[i] != null && !productPackIds[i].isEmpty()) {
                line.setProductPackId(Long.parseLong(productPackIds[i]));
            }
            line.setBatchCode(batchCodes != null && batchCodes.length > i ? batchCodes[i] : null);
            if (manufactureDates != null && manufactureDates.length > i && manufactureDates[i] != null && !manufactureDates[i].isEmpty()) {
                line.setManufactureDate(LocalDate.parse(manufactureDates[i]));
            }
            if (expiryDates != null && expiryDates.length > i && expiryDates[i] != null && !expiryDates[i].isEmpty()) {
                line.setExpiryDate(LocalDate.parse(expiryDates[i]));
            }
            if (quantities != null && quantities.length > i && quantities[i] != null && !quantities[i].isEmpty()) {
                line.setQuantityReceived(Integer.parseInt(quantities[i]));
            }
            if (unitCosts != null && unitCosts.length > i && unitCosts[i] != null && !unitCosts[i].isEmpty()) {
                line.setUnitCost(new BigDecimal(unitCosts[i]));
            }
            if (notes != null && notes.length > i) {
                line.setNote(notes[i]);
            }

            boolean hasAnyValue = line.getReceiptItemId() != null
                    || line.getProductPackId() != null
                    || (line.getBatchCode() != null && !line.getBatchCode().trim().isEmpty())
                    || line.getExpiryDate() != null
                    || line.getQuantityReceived() != null
                    || line.getUnitCost() != null;
            if (hasAnyValue) {
                lines.add(line);
            }
        }
        form.setLines(lines);
        return form;
    }
}
