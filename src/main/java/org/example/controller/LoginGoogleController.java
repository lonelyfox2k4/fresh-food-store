package org.example.controller;

import com.google.gson.JsonObject;
import org.example.dao.AccountDAO;
import org.example.model.auth.Account;
import org.example.utils.GoogleUtils;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login-google")
public class LoginGoogleController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String code = req.getParameter("code");

        if (code == null || code.isEmpty()) {
            resp.sendRedirect("login");
        } else {

            String accessToken = GoogleUtils.getToken(code);
            JsonObject googleUser = GoogleUtils.getUserInfo(accessToken);

            String email = googleUser.get("email").getAsString();
            String name = googleUser.get("name").getAsString();

            AccountDAO dao = new AccountDAO();
            Account acc = dao.getAccountByEmail(email);

            if (acc == null) {
                dao.insertAccount(5, email, "google_login_no_pass", name, "");
                acc = dao.getAccountByEmail(email);
            }

            req.getSession().setAttribute("user", acc);
            resp.sendRedirect("home.jsp");
        }
    }
}