package org.example.controller;

import org.example.dao.CategoryDAO;
import org.example.dao.ProductDAO;
import org.example.dao.SupplierDAO;
import org.example.dao.PolicyDAO;
import org.example.model.catalog.Product;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.nio.file.Paths;
import java.util.UUID;

@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final SupplierDAO supplierDAO = new SupplierDAO();
    private final PolicyDAO policyDAO = new PolicyDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "new":
                showNewForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteProduct(request, response);
                break;
            default:
                listProducts(request, response);
                break;
        }
    }

    private void listProducts(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("products", productDAO.getAllProducts());
        request.getRequestDispatcher("/manager/products.jsp").forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("categories", categoryDAO.getAllActiveCategories());
        request.setAttribute("suppliers", supplierDAO.getActiveSuppliers());
        request.setAttribute("policies", policyDAO.getAllPolicies());
        request.getRequestDispatcher("/manager/product-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        long id = Long.parseLong(request.getParameter("id"));
        Product existingProduct = productDAO.getProductById(id);
        request.setAttribute("product", existingProduct);
        request.setAttribute("categories", categoryDAO.getAllActiveCategories());
        request.setAttribute("suppliers", supplierDAO.getActiveSuppliers());
        request.setAttribute("policies", policyDAO.getAllPolicies());
        request.getRequestDispatcher("/manager/product-form.jsp").forward(request, response);
    }

    private void deleteProduct(HttpServletRequest request, HttpServletResponse response) throws IOException {
        long id = Long.parseLong(request.getParameter("id"));
        productDAO.updateStatus(id, false);
        response.sendRedirect("products");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String idStr = request.getParameter("id");
        
        String productName = request.getParameter("productName");
        String basePriceStr = request.getParameter("basePriceAmount");
        String supIdStr = request.getParameter("supplierId");
        String catIdStr = request.getParameter("categoryId");

        // Basic Server-side Validation
        if (productName == null || productName.trim().isEmpty() || 
            basePriceStr == null || basePriceStr.isEmpty() ||
            catIdStr == null || catIdStr.isEmpty()) {
            
            request.setAttribute("error", "Vui lòng điền đầy đủ các thông tin bắt buộc (*)");
            if (idStr == null || idStr.isEmpty()) showNewForm(request, response);
            else showEditForm(request, response);
            return;
        }

        BigDecimal basePrice = new BigDecimal(basePriceStr);
        if (basePrice.compareTo(BigDecimal.ZERO) <= 0) {
            request.setAttribute("error", "Giá niêm yết phải lớn hơn 0");
            if (idStr == null || idStr.isEmpty()) showNewForm(request, response);
            else showEditForm(request, response);
            return;
        }

        Product p = new Product();
        p.setProductName(productName);
        p.setCategoryId(Integer.parseInt(catIdStr));
        p.setDescription(request.getParameter("description"));

        // Xử lý upload ảnh
        String imageUrl = request.getParameter("existingImageUrl");
        try {
            Part filePart = request.getPart("imageFile");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = extractFileName(filePart);
                String ext = "";
                if (fileName.contains(".")) {
                    ext = fileName.substring(fileName.lastIndexOf("."));
                }
                String newFileName = UUID.randomUUID().toString() + ext;
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                
                String filePath = uploadPath + File.separator + newFileName;
                filePart.write(filePath);
                
                // Lưu web path (ví dụ: /uploads/abc.png hoặc uploads/abc.png)
                imageUrl = "uploads/" + newFileName;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        p.setImageUrl(imageUrl);

        p.setBasePriceAmount(basePrice);
        p.setPriceBaseWeightGram(Integer.parseInt(request.getParameter("priceBaseWeightGram")));
        
        String policyId = request.getParameter("expiryPricingPolicyId");
        if (policyId != null && !policyId.isEmpty() && !policyId.equals("0")) {
            p.setExpiryPricingPolicyId(Integer.parseInt(policyId));
        }
        
        p.setStatus(request.getParameter("status") != null);

        if (idStr == null || idStr.isEmpty()) {
            productDAO.insertProduct(p);
        } else {
            p.setProductId(Long.parseLong(idStr));
            productDAO.updateProduct(p);
        }
        response.sendRedirect("products");
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                String clientFileName = s.substring(s.indexOf("=") + 2, s.length() - 1);
                clientFileName = clientFileName.replace("\\", "/");
                int i = clientFileName.lastIndexOf('/');
                return i != -1 ? clientFileName.substring(i + 1) : clientFileName;
            }
        }
        return "";
    }
}
