package com.oceanview.controller;

import com.oceanview.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/ResetPasswordServlet")
public class ResetPasswordServlet extends HttpServlet {

    // optional: allow GET to redirect to JSP (prevents 405)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        if (token == null || token.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");
            return;
        }
        response.sendRedirect(request.getContextPath() + "/resetPassword.jsp?token=" + token);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String token = request.getParameter("token");
        String password = request.getParameter("password");
        String confirm = request.getParameter("confirm");

        if (token == null || token.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");
            return;
        }

        if (password == null || password.isBlank() || confirm == null || confirm.isBlank()) {
            request.setAttribute("error", "Please enter password and confirm password!");
            request.getRequestDispatcher("/resetPassword.jsp?token=" + token).forward(request, response);
            return;
        }

        if (!password.equals(confirm)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("/resetPassword.jsp?token=" + token).forward(request, response);
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            Integer userId = null;

            // validate token
            try (PreparedStatement ps = con.prepareStatement(
                    "SELECT user_id FROM password_reset_tokens WHERE token=? AND used=0 AND expires_at > NOW()")) {
                ps.setString(1, token);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) userId = rs.getInt("user_id");
                }
            }

            if (userId == null) {
                request.setAttribute("error", "Token is invalid or expired!");
                request.getRequestDispatcher("/resetPassword.jsp?token=" + token).forward(request, response);
                return;
            }

            // update password
            try (PreparedStatement ps = con.prepareStatement("UPDATE users SET password=? WHERE id=?")) {
                ps.setString(1, password); // (for real life use hashing)
                ps.setInt(2, userId);
                ps.executeUpdate();
            }

            // mark token used
            try (PreparedStatement ps = con.prepareStatement("UPDATE password_reset_tokens SET used=1 WHERE token=?")) {
                ps.setString(1, token);
                ps.executeUpdate();
            }

            HttpSession session = request.getSession();
            session.setAttribute("successMessage", "Password updated successfully! Please login.");
            response.sendRedirect(request.getContextPath() + "/login.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Server error: " + e.getMessage());
            request.getRequestDispatcher("/resetPassword.jsp?token=" + token).forward(request, response);
        }
    }
}