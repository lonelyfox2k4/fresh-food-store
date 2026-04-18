package org.example;

import org.example.dao.ProductDAO;
import org.example.model.catalog.Product;
import java.util.List;

public class TestDAO {
    public static void main(String[] args) {
        ProductDAO dao = new ProductDAO();
        try {
            List<Product> flash = dao.getFlashSaleProducts();
            List<Product> best = dao.getBestSellerProducts();
            System.out.println("Flash Sale count: " + flash.size());
            System.out.println("Best Seller count: " + best.size());
            for (Product p : flash) System.out.println(" - " + p.getProductName());
            for (Product p : best) System.out.println(" - " + p.getProductName());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
