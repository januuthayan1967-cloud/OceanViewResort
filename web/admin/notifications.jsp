<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.dao.NotificationDAO" %>
<%@ page import="java.util.List" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    NotificationDAO dao = new NotificationDAO();

    int notiCount = dao.countUnreadForRole("ADMIN");
    List<String> notifications = dao.getLatestForRole("ADMIN", 100); // load more
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-primary m-0">Admin Notifications</h3>
        <div class="d-flex gap-2">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/AdminDashboard">Back</a>
            <a class="btn btn-outline-primary" href="<%=request.getContextPath()%>/admin/notifications.jsp">Refresh</a>
        </div>
    </div>

    <div class="card shadow-sm">
        <div class="card-header d-flex justify-content-between align-items-center">
            <span>Unread: <b><%= notiCount %></b></span>
        </div>

        <div class="card-body p-0">
            <%
                if (notifications == null || notifications.isEmpty()) {
            %>
                <div class="p-4 text-center text-muted">No notifications available.</div>
            <%
                } else {
            %>
                <ul class="list-group list-group-flush">
                    <%
                        for (String msg : notifications) {
                    %>
                        <li class="list-group-item">
                            <i class="fa-solid fa-bell text-primary me-2"></i>
                            <%= msg %>
                        </li>
                    <%
                        }
                    %>
                </ul>
            <%
                }
            %>
        </div>
    </div>

</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/js/all.min.js"></script>
</body>
</html>