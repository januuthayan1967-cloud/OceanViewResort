<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.dao.NotificationDAO" %>
<%@ page import="java.util.List" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"STAFF".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    NotificationDAO dao = new NotificationDAO();

    int notiCount = dao.countUnreadForRole("STAFF");
    List<String> notifications = dao.getLatestForRole("STAFF", 100);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Notifications</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-success m-0">Staff Notifications</h3>
        <div class="d-flex gap-2">
            <a class="btn btn-secondary" href="<%=request.getContextPath()%>/StaffDashboard">Back</a>
            <a class="btn btn-outline-success" href="<%=request.getContextPath()%>/staff/notifications.jsp">Refresh</a>
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
                            <i class="fa-solid fa-bell text-success me-2"></i>
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