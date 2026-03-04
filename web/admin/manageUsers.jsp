<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.User" %>

<%
    // ✅ Admin session check
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Data from servlet
    List<User> users = (List<User>) request.getAttribute("users");
    User editUser = (User) request.getAttribute("editUser");

    // Optional messages from servlet
    String success = (String) request.getAttribute("success");
    String error   = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- FontAwesome (icons) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        .card { border-radius: 14px; }
        .table thead th { vertical-align: middle; }
        .actions { min-width: 220px; }
        .badge-role { font-size: .85rem; }
    </style>
</head>

<body class="bg-light">

<div class="container py-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Manage Users</h3>
        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/AdminDashboard">
            <i class="fa fa-arrow-left me-1"></i> Back
        </a>
    </div>

    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <!-- ✅ ADD USER / STAFF (NO ADMIN) -->
    <div class="card mb-4">
        <div class="card-header fw-bold">
            <i class="fa fa-user-plus me-1"></i> Add New User / Staff
        </div>
        <div class="card-body">
            <form method="post" action="<%=request.getContextPath()%>/AdminManageUsers">
                <input type="hidden" name="action" value="add">

                <div class="row g-3">
                    <div class="col-md-3">
                        <label class="form-label">Username</label>
                        <input class="form-control" name="username" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>

                    <div class="col-md-2">
                        <label class="form-label">Role</label>
                        <select class="form-select" name="role" required>
                            <option value="USER">USER</option>
                            <option value="STAFF">STAFF</option>
                        </select>
                    </div>
                </div>

                <div class="mt-3">
                    <button class="btn btn-success">
                        <i class="fa fa-plus me-1"></i> Add
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ✅ EDIT FORM (Only USER/STAFF allowed) -->
    <% if (editUser != null) {
        boolean isAdminTarget = "ADMIN".equalsIgnoreCase(editUser.getRole());
    %>

        <% if (isAdminTarget) { %>
            <div class="alert alert-warning">
                <b>Warning:</b> You cannot edit ADMIN accounts here.
                <a class="btn btn-sm btn-outline-secondary ms-2" href="<%=request.getContextPath()%>/AdminManageUsers">Close</a>
            </div>
        <% } else { %>

            <div class="card mb-4">
                <div class="card-header fw-bold">
                    <i class="fa fa-pen me-1"></i> Edit User (ID: <%= editUser.getId() %>)
                </div>
                <div class="card-body">

                    <form method="post" action="<%=request.getContextPath()%>/AdminManageUsers">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= editUser.getId() %>">

                        <div class="row g-3">
                            <div class="col-md-4">
                                <label class="form-label">Username</label>
                                <input class="form-control" name="username" value="<%= editUser.getUsername() %>" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Email</label>
                                <input type="email" class="form-control" name="email" value="<%= editUser.getEmail() %>" required>
                            </div>

                            <div class="col-md-4">
                                <label class="form-label">Role</label>
                                <!-- ✅ Only USER/STAFF -->
                                <select class="form-select" name="role" required>
                                    <option value="USER"  <%= "USER".equalsIgnoreCase(editUser.getRole()) ? "selected" : "" %>>USER</option>
                                    <option value="STAFF" <%= "STAFF".equalsIgnoreCase(editUser.getRole()) ? "selected" : "" %>>STAFF</option>
                                </select>
                            </div>

                            <!-- ✅ Optional password -->
                            <div class="col-md-12">
                                <label class="form-label">New Password (optional)</label>
                                <input type="password" class="form-control" name="password"
                                       placeholder="Leave empty to keep old password">
                                <small class="text-muted">
                                    Leave empty to keep the current password (handle in servlet).
                                </small>
                            </div>
                        </div>

                        <div class="mt-3 d-flex gap-2">
                            <button class="btn btn-primary">
                                <i class="fa fa-save me-1"></i> Save
                            </button>
                            <a class="btn btn-outline-secondary" href="<%=request.getContextPath()%>/AdminManageUsers">
                                Cancel
                            </a>
                        </div>
                    </form>
                </div>
            </div>

        <% } %>
    <% } %>

    <!-- ✅ USERS TABLE -->
    <div class="card">
        <div class="card-header fw-bold">
            <i class="fa fa-users me-1"></i> All Users (USER / STAFF)
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-striped table-hover mb-0 align-middle">
                    <thead class="table-dark">
                    <tr>
                        <th style="width: 70px;">ID</th>
                        <th>Username</th>
                        <th>Email</th>
                        <th style="width: 120px;">Role</th>
                        <th class="actions">Actions</th>
                    </tr>
                    </thead>
                    <tbody>

                    <% if (users == null || users.isEmpty()) { %>
                        <tr>
                            <td colspan="5" class="text-center p-4 text-muted">No users found</td>
                        </tr>
                    <% } else {
                        for (User u : users) {
                            boolean isAdminRow = "ADMIN".equalsIgnoreCase(u.getRole()); // safety
                    %>
                        <tr>
                            <td><%= u.getId() %></td>
                            <td><%= u.getUsername() %></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <span class="badge badge-role
                                    <%= "STAFF".equalsIgnoreCase(u.getRole()) ? "bg-warning text-dark" : "bg-primary" %>">
                                    <%= u.getRole() %>
                                </span>
                            </td>

                            <td class="d-flex gap-2">
                                <% if (!isAdminRow) { %>
                                    <a class="btn btn-sm btn-warning"
                                       href="<%=request.getContextPath()%>/AdminManageUsers?action=edit&id=<%=u.getId()%>">
                                        <i class="fa fa-pen me-1"></i> Edit
                                    </a>

                                    <form method="post" action="<%=request.getContextPath()%>/AdminManageUsers"
                                          onsubmit="return confirm('Delete this user?');" class="m-0">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= u.getId() %>">
                                        <button class="btn btn-sm btn-danger">
                                            <i class="fa fa-trash me-1"></i> Delete
                                        </button>
                                    </form>
                                <% } else { %>
                                    <span class="text-muted small">Admin protected</span>
                                <% } %>
                            </td>
                        </tr>
                    <% } } %>

                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

</body>
</html>