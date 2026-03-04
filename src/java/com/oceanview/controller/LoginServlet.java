package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get form values
        String loginInput = request.getParameter("username"); // username OR email
        String password   = request.getParameter("password");

        // Basic validation
        if (loginInput == null || loginInput.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {

            request.setAttribute("error", "Username/Email and Password are required!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate user
        UserDAO userDao = new UserDAO();
        User user = userDao.login(loginInput.trim(), password.trim());

        // Invalid login
        if (user == null) {
            request.setAttribute("error", "Invalid Username/Email or Password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Create session
        HttpSession session = request.getSession(true);
        session.setAttribute("loggedUser", user);
        session.setMaxInactiveInterval(30 * 60); // 30 minutes

        // Role-based redirect
        String role = user.getRole().toUpperCase();

        if ("ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/admindashboard.jsp");
        } 
        else if ("STAFF".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/staff/staffdashboard.jsp");
        } 
        else if ("USER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/user/userdashbord.jsp");
        } 
        else {
            // Unknown role
            session.invalidate();
            request.setAttribute("error", "Unauthorized role access!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}