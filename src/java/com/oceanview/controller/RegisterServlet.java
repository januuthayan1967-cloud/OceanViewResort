package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 🔹 Simple validation
        if (username == null || username.isEmpty() ||
            email == null || email.isEmpty() ||
            password == null || password.isEmpty()) {

            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }

        // 🔒 Force role as USER
        User user = new User(username, email, password, "USER");

        UserDAO dao = new UserDAO();
        boolean success = dao.registerUser(user);

        if (success) {
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Registration Successful! Please Login.");
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("error", "Registration Failed! Username or Email may already exist.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}