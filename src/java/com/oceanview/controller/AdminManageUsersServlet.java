package com.oceanview.controller;

import com.oceanview.dao.UserDAO;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AdminManageUsers")
public class AdminManageUsersServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Admin session check
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ If admin clicked Edit
        String action = request.getParameter("action");
        String idStr = request.getParameter("id");

        if ("edit".equalsIgnoreCase(action) && idStr != null) {
            try {
                int id = Integer.parseInt(idStr);
                User editUser = userDAO.getUserById(id);

                // ✅ Prevent editing ADMIN
                if (editUser != null && "ADMIN".equalsIgnoreCase(editUser.getRole())) {
                    request.setAttribute("error", "You cannot edit ADMIN accounts here.");
                } else {
                    request.setAttribute("editUser", editUser);
                }

            } catch (NumberFormatException ignored) {}
        }

        // ✅ Load list (better: only USER/STAFF)
        List<User> users = userDAO.getAllUsers(); // if you have getAllUsersExceptAdmin() use that
        request.setAttribute("users", users);

        request.getRequestDispatcher("/admin/manageUsers.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Admin session check
        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");

        try {

            // ================= ADD =================
            if ("add".equalsIgnoreCase(action)) {

                String username = request.getParameter("username");
                String email    = request.getParameter("email");
                String password = request.getParameter("password");
                String role     = request.getParameter("role");

                // ✅ Block ADMIN creation from this page
                if ("ADMIN".equalsIgnoreCase(role)) {
                    response.sendRedirect(request.getContextPath() + "/AdminManageUsers");
                    return;
                }

                User u = new User();
                u.setUsername(username);
                u.setEmail(email);
                u.setPassword(password);
                u.setRole(role);

                userDAO.registerUser(u); // uses INSERT

            }

            // ================= UPDATE =================
            else if ("update".equalsIgnoreCase(action)) {

                int id = Integer.parseInt(request.getParameter("id"));
                String username = request.getParameter("username");
                String email    = request.getParameter("email");
                String role     = request.getParameter("role");
                String newPass  = request.getParameter("password"); // optional

                User old = userDAO.getUserById(id);
                if (old != null) {

                    // ✅ Don't allow changing ADMIN here
                    if ("ADMIN".equalsIgnoreCase(old.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/AdminManageUsers");
                        return;
                    }

                    old.setUsername(username);
                    old.setEmail(email);

                    // ✅ Block role ADMIN
                    if ("ADMIN".equalsIgnoreCase(role)) role = old.getRole();
                    old.setRole(role);

                    // ✅ If password entered, change it. If empty, keep old.
                    if (newPass != null && !newPass.trim().isEmpty()) {
                        old.setPassword(newPass.trim());
                        userDAO.updateUser(old); // updates with password
                    } else {
                        userDAO.updateUserWithoutPassword(old); // keep password
                    }
                }
            }

            // ================= DELETE =================
            else if ("delete".equalsIgnoreCase(action)) {

                int id = Integer.parseInt(request.getParameter("id"));

                User target = userDAO.getUserById(id);
                if (target != null) {

                    // ✅ Protect ADMIN from delete
                    if ("ADMIN".equalsIgnoreCase(target.getRole())) {
                        response.sendRedirect(request.getContextPath() + "/AdminManageUsers");
                        return;
                    }

                    userDAO.deleteUser(id);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        // ✅ Back to list
        response.sendRedirect(request.getContextPath() + "/AdminManageUsers");
    }
}