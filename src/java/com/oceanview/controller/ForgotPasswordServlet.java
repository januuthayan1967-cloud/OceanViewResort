package com.oceanview.controller;

import com.oceanview.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.UUID;

@WebServlet("/ForgotPasswordServlet")
public class ForgotPasswordServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");

        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Please enter your email address!");
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            Integer userId = null;

            // 1. check user email
            String findUserSql = "SELECT id FROM users WHERE email = ?";
            try (PreparedStatement ps = con.prepareStatement(findUserSql)) {
                ps.setString(1, email.trim());

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        userId = rs.getInt("id");
                    }
                }
            }

            if (userId == null) {
                request.setAttribute("error", "No account found with that email!");
                request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
                return;
            }

            // 2. delete old tokens for same user
            String deleteOldSql = "DELETE FROM password_reset_tokens WHERE user_id = ?";
            try (PreparedStatement ps = con.prepareStatement(deleteOldSql)) {
                ps.setInt(1, userId);
                ps.executeUpdate();
            }

            // 3. generate token
            String token = UUID.randomUUID().toString();

            // 4. insert new token
            String insertSql = "INSERT INTO password_reset_tokens (user_id, token, expires_at, used) "
                    + "VALUES (?, ?, DATE_ADD(NOW(), INTERVAL 15 MINUTE), 0)";
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, userId);
                ps.setString(2, token);
                ps.executeUpdate();
            }

            // 5. build reset link
            String resetLink = request.getScheme() + "://"
                    + request.getServerName() + ":"
                    + request.getServerPort()
                    + request.getContextPath()
                    + "/ResetPasswordServlet?token=" + token;

            // 6. send message to JSP using session
            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Reset link generated successfully!");
            session.setAttribute("resetLink", resetLink);

            response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("/forgotPassword.jsp").forward(request, response);
        }
    }
}