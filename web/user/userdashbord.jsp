<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>

<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"USER".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String today = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());

    // ===== DB Notifications (From Servlet: /UserDashboard) =====
    Integer notiCountObj = (Integer) request.getAttribute("notiCount");
    int notifCount = (notiCountObj == null) ? 0 : notiCountObj;

    List<String> notifications = (List<String>) request.getAttribute("notifications");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Dashboard - Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background: #f4f6f9;
        }

        .sidebar {
            width: 260px;
            min-height: 100vh;
            background: linear-gradient(180deg, #0b4f6c, #1e7a9c);
            color: white;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 100;
        }

        .sidebar-header {
            padding: 1.8rem 1rem;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .profile-image {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.2);
            font-size: 3rem;
        }

        .nav-link-custom {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 0.9rem 1.5rem;
            color: rgba(255,255,255,0.85);
            text-decoration: none;
            border-left: 4px solid transparent;
            transition: 0.2s;
        }

        .nav-link-custom:hover,
        .nav-link-custom.active {
            background: rgba(255,255,255,0.15);
            color: white;
            border-left-color: gold;
        }

        .main-content {
            margin-left: 260px;
            padding: 2rem;
        }

        .welcome-card {
            background: linear-gradient(135deg, #2c7da0, #3a9bc5);
            color: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 10px 25px rgba(0,0,0,0.12);
            position: relative;
            overflow: hidden;
        }

        .welcome-card .wave {
            position: absolute;
            right: -20px;
            bottom: -30px;
            font-size: 7rem;
            opacity: 0.12;
        }

        .stat-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            box-shadow: 0 6px 15px rgba(0,0,0,0.06);
            text-align: center;
            transition: 0.2s;
        }
        .stat-card:hover { transform: translateY(-3px); }

        .action-card {
            background: white;
            border-radius: 20px;
            padding: 1.5rem;
            text-align: center;
            box-shadow: 0 6px 15px rgba(0,0,0,0.06);
            transition: 0.2s;
        }
        .action-card:hover { transform: translateY(-3px); }

        .action-card i {
            font-size: 2.5rem;
            color: #0b4f6c;
            margin-bottom: 1rem;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 1rem;
        }

        .dropdown-menu {
            border-radius: 16px;
        }

        /* ✅ Notification list improvements */
        .noti-list {
            max-height: 260px;
            overflow-y: auto;
            padding: 6px 8px;
        }
        .noti-item {
            border-radius: 12px;
            margin: 6px 0;
            background: #f8f9fa;
            padding: 10px 10px;
        }
        .noti-time {
            font-size: 0.78rem;
            color: #6c757d;
            display: block;
            margin-left: 28px;
            margin-top: -6px;
        }
    </style>
</head>

<body>

<!-- SIDEBAR -->
<div class="sidebar">
    <div class="sidebar-header">
        <div class="profile-image">
            <i class="fas fa-user-circle"></i>
        </div>
        <h5 class="mt-2"><%= user.getUsername() %></h5>
        <small>User Account</small>
    </div>

    <nav class="nav flex-column mt-2">
        <!-- ✅ IMPORTANT: open dashboard through servlet -->
        <a href="<%=request.getContextPath()%>/UserDashboard" class="nav-link-custom active">
            <i class="fas fa-home"></i> Dashboard
        </a>

        <a href="<%=request.getContextPath()%>/ViewReservations" class="nav-link-custom">
            <i class="fas fa-calendar-check"></i> View Reservations
        </a>

        <a href="<%=request.getContextPath()%>/PrintBill" class="nav-link-custom">
            <i class="fas fa-file-invoice-dollar"></i> Print Bill
        </a>

        <a href="<%=request.getContextPath()%>/user/help.jsp" class="nav-link-custom">
            <i class="fas fa-circle-question"></i> Help
        </a>

        <a href="<%=request.getContextPath()%>/LogoutServlet" class="nav-link-custom">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<!-- MAIN -->
<div class="main-content">

    <!-- TOP BAR WITH NOTIFICATION -->
    <div class="topbar">
        <h4 class="m-0 text-dark">Dashboard</h4>

        <div class="dropdown">
            <button class="btn btn-light position-relative shadow-sm dropdown-toggle"
                    type="button" data-bs-toggle="dropdown" aria-expanded="false"
                    style="border-radius: 12px;">
                <i class="fas fa-bell"></i>

                <% if (notifCount > 0) { %>
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        <%= (notifCount > 99 ? "99+" : notifCount) %>
                    </span>
                <% } %>
            </button>

            <ul class="dropdown-menu dropdown-menu-end shadow" style="width: 360px;">
                <li class="dropdown-header fw-bold text-primary d-flex justify-content-between align-items-center">
                    <span>Notifications</span>
                    <a class="text-decoration-none" href="<%=request.getContextPath()%>/Notifications">View All</a>
                </li>

                <% if (notifications == null || notifications.isEmpty()) { %>
                    <li class="px-3 py-3 text-muted">No new notifications</li>
                <% } else { %>

                    <li>
                        <div class="noti-list">
                            <%
                                int maxShow = Math.min(5, notifications.size());
                                for (int i = 0; i < maxShow; i++) {
                                    String msg = notifications.get(i);

                                    String icon = "fa-circle-info";
                                    String color = "text-primary";

                                    String up = msg.toUpperCase();
                                    if (up.contains("CONFIRM")) { icon = "fa-circle-check"; color = "text-success"; }
                                    else if (up.contains("CANCEL")) { icon = "fa-circle-xmark"; color = "text-danger"; }
                                    else if (up.contains("PENDING")) { icon = "fa-clock"; color = "text-warning"; }
                            %>
                                <div class="noti-item">
                                    <i class="fas <%=icon%> <%=color%> me-2"></i>
                                    <%= msg %>
                                    <span class="noti-time">Just now</span>
                                </div>
                            <%
                                }
                            %>
                        </div>
                    </li>

                    <li><hr class="dropdown-divider"></li>
                    <li class="text-center">
                        <form action="<%=request.getContextPath()%>/ClearNotifications" method="post" class="m-0">
                            <button class="btn btn-sm btn-outline-danger mb-2">Clear All</button>
                        </form>
                    </li>

                <% } %>
            </ul>
        </div>
    </div>

    <!-- WELCOME CARD -->
    <div class="welcome-card">
        <h3 class="mb-1">Welcome, <%= user.getUsername() %> 👋</h3>
        <p class="mb-0"><i class="fas fa-calendar"></i> <%= today %></p>
        <i class="fas fa-water wave"></i>
    </div>

    <!-- STATS -->
    <div class="row g-4 mb-4">
        <div class="col-md-4">
            <div class="stat-card">
                <i class="fas fa-calendar-check fa-2x text-primary"></i>
                <h5 class="mt-2 mb-1">Reservations</h5>
                <p class="text-muted m-0">View your bookings</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="fas fa-history fa-2x text-success"></i>
                <h5 class="mt-2 mb-1">History</h5>
                <p class="text-muted m-0">Past stays</p>
            </div>
        </div>

        <div class="col-md-4">
            <div class="stat-card">
                <i class="fas fa-star fa-2x text-warning"></i>
                <h5 class="mt-2 mb-1">Loyalty</h5>
                <p class="text-muted m-0">Reward points</p>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS -->
    <h5 class="mb-3">Quick Actions</h5>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="action-card">
                <i class="fas fa-calendar-plus"></i>
                <h6>New Reservation</h6>
                <a href="<%=request.getContextPath()%>/user/addReservation.jsp" class="btn btn-primary mt-2">Book Now</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="action-card">
                <i class="fas fa-file-invoice-dollar"></i>
                <h6>View Bills</h6>
                <a href="<%=request.getContextPath()%>/PrintBill" class="btn btn-primary mt-2">View</a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="action-card">
                <i class="fas fa-headset"></i>
                <h6>Support</h6>
                <a href="<%=request.getContextPath()%>/user/help.jsp" class="btn btn-primary mt-2">Contact</a>
            </div>
        </div>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>