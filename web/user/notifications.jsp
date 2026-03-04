<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.User" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"USER".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // Comes from Notifications servlet: request.setAttribute("notifications", list)
    List<String> notifications = (List<String>) request.getAttribute("notifications");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Notifications - Ocean View Resort</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body { background: #f4f6f9; font-family: 'Poppins', sans-serif; }

        .page-head{
            background: linear-gradient(135deg, #2c7da0, #3a9bc5);
            color: #fff;
            border-radius: 18px;
            padding: 18px 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.10);
        }

        .noti-card{
            border-radius: 18px;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            border: 0;
            overflow: hidden;
        }

        .noti-item{
            padding: 14px 16px;
            display: flex;
            gap: 12px;
            align-items: flex-start;
        }

        .noti-icon{
            width: 36px;
            height: 36px;
            border-radius: 12px;
            display: flex;
            align-items:center;
            justify-content:center;
            background: rgba(44, 125, 160, 0.12);
            color: #2c7da0;
            flex-shrink: 0;
        }

        .noti-text{
            flex: 1;
        }

        .noti-text .msg{
            margin: 0;
            color: #1f2a37;
            font-weight: 500;
        }

        .noti-text .meta{
            margin: 3px 0 0;
            font-size: 0.82rem;
            color: #6b7280;
        }

        .empty-box{
            border-radius: 14px;
            background: #fff;
            border: 1px dashed rgba(0,0,0,0.15);
            padding: 18px;
            color: #6b7280;
        }
    </style>
</head>

<body>

<div class="container mt-4 mb-5">

    <!-- Header -->
    <div class="page-head d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
        <div>
            <h4 class="m-0"><i class="fas fa-bell me-2"></i>Notifications</h4>
            <small>Ocean View Resort - User</small>
        </div>

        <div class="d-flex gap-2">
            <a class="btn btn-light btn-sm" href="<%=request.getContextPath()%>/UserDashboard">
                <i class="fas fa-arrow-left me-1"></i> Back
            </a>

            <form action="<%=request.getContextPath()%>/ClearNotifications" method="post" class="m-0">
                <button class="btn btn-outline-light btn-sm" type="submit"
                        onclick="return confirm('Clear all notifications?');">
                    <i class="fas fa-trash me-1"></i> Clear All
                </button>
            </form>
        </div>
    </div>

    <!-- List -->
    <div class="card noti-card">
        <div class="card-body p-0">

            <% if (notifications == null || notifications.isEmpty()) { %>
                <div class="p-3">
                    <div class="empty-box">
                        <i class="fas fa-circle-check text-success me-2"></i>
                        No notifications found.
                    </div>
                </div>
            <% } else { %>

                <ul class="list-group list-group-flush">
                    <% for (String msg : notifications) { %>
                        <li class="list-group-item noti-item">
                            <div class="noti-icon">
                                <i class="fas fa-bell"></i>
                            </div>
                            <div class="noti-text">
                                <p class="msg"><%= msg %></p>
                                <p class="meta">New</p>
                            </div>
                        </li>
                    <% } %>
                </ul>

            <% } %>

        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>