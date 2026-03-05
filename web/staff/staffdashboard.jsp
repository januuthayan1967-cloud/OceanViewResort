<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true"%>

<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>

<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String today = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());

    Integer notiCountObj = (Integer) request.getAttribute("notiCount");
    int notiCount = (notiCountObj == null) ? 0 : notiCountObj;

    List notifications = (List) request.getAttribute("notifications");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard - Ocean View Resort</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        * { font-family: 'Poppins', sans-serif; }
        body { background: #f4f6f9; }

        /* Sidebar */
        .sidebar {
            width: 270px;
            min-height: 100vh;
            background: linear-gradient(180deg, #1e3c72 0%, #2a5298 100%);
            position: fixed;
            top: 0;
            left: 0;
            z-index: 999;
            box-shadow: 4px 0 20px rgba(0,0,0,0.12);
            transition: left .3s ease;
        }

        .sidebar-header {
            padding: 1.6rem 1rem;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.2);
        }

        .staff-avatar {
            width: 78px;
            height: 78px;
            border-radius: 50%;
            margin: 0 auto 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.18);
            border: 3px solid rgba(255,255,255,0.35);
            color: #fff;
            font-size: 2.8rem;
        }

        .sidebar-header h5 { color: #fff; font-weight: 600; margin: 0; }
        .sidebar-header small { color: rgba(255,255,255,0.85); }

        .nav-link-custom {
            color: rgba(255,255,255,0.86);
            padding: 0.95rem 1.4rem;
            display: flex;
            align-items: center;
            gap: 12px;
            text-decoration: none;
            border-left: 4px solid transparent;
            transition: all .25s ease;
            margin: 4px 0;
        }

        .nav-link-custom i { width: 24px; font-size: 1.15rem; }

        .nav-link-custom:hover {
            background: rgba(255,255,255,0.14);
            color: #fff;
            border-left-color: #ffd700;
        }

        .nav-link-custom.active {
            background: rgba(255,255,255,0.18);
            color: #fff;
            border-left-color: #ffd700;
            font-weight: 600;
        }

        /* Main content */
        .main-content {
            margin-left: 270px;
            padding: 2rem;
            min-height: 100vh;
        }

        /* Welcome card */
        .welcome-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            color: #fff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.12);
            position: relative;
            overflow: visible;              /* ✅ Important */
            margin-bottom: 1.8rem;
        }

        .welcome-card .bg-icon {
            position: absolute;
            right: -10px;
            bottom: -20px;
            font-size: 10rem;
            opacity: 0.12;
            transform: rotate(10deg);
            pointer-events: none;           /* ✅ Important */
            z-index: 0;
        }

        .welcome-card .content-layer {
            position: relative;
            z-index: 3;
            width: 100%;
        }

        /* ✅ Notification dropdown always on top */
        .welcome-card .dropdown {
            position: relative;
            z-index: 99999;
        }

        .dropdown-menu {
            z-index: 999999 !important;
            border-radius: 16px;
        }

        /* ✅ Better notification menu UI */
        .noti-menu {
            width: 380px;
            max-width: 92vw;
            padding: 0;
            border: 0;
            overflow: hidden;
        }

        .noti-header {
            position: sticky;
            top: 0;
            background: #fff;
            z-index: 2;
            padding: 12px 14px;
            border-bottom: 1px solid rgba(0,0,0,0.06);
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .noti-list {
            max-height: 320px;             /* ✅ scroll */
            overflow-y: auto;
            padding: 6px 0;
        }

        .noti-item {
            padding: 10px 14px;
            display: flex;
            gap: 10px;
            align-items: flex-start;
            border-bottom: 1px solid rgba(0,0,0,0.05);
            color: #2d3748;
            text-decoration: none;
        }

        .noti-item:hover {
            background: rgba(102,126,234,0.08);
        }

        .noti-icon {
            margin-top: 2px;
            color: #667eea;
            font-size: 1rem;
        }

        .noti-text {
            flex: 1;
            font-size: 0.93rem;
            line-height: 1.25rem;
        }

        .noti-footer {
            padding: 10px 14px;
            border-top: 1px solid rgba(0,0,0,0.06);
            background: #fff;
        }

        /* cards */
        .card-soft {
            background: #fff;
            border-radius: 18px;
            padding: 1.4rem;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            border: 0;
        }

        .stat-box { display: flex; align-items: center; gap: 14px; }

        .stat-icon {
            width: 52px;
            height: 52px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.35rem;
            color: #fff;
        }

        .bg-a { background: linear-gradient(45deg, #667eea, #764ba2); }
        .bg-b { background: linear-gradient(45deg, #38b2ac, #319795); }
        .bg-c { background: linear-gradient(45deg, #ed8936, #dd6b20); }
        .bg-d { background: linear-gradient(45deg, #2a5298, #1e3c72); }

        .stat-title { color: #6c757d; font-size: .85rem; margin: 0; text-transform: uppercase; letter-spacing: .8px; }
        .stat-value { font-size: 1.6rem; font-weight: 700; margin: 0; color: #2d3748; }

        .action-card {
            background: #fff;
            border-radius: 18px;
            padding: 1.6rem;
            box-shadow: 0 8px 20px rgba(0,0,0,0.06);
            border: 0;
            height: 100%;
            transition: transform .2s ease, box-shadow .2s ease;
            text-align: center;
        }

        .action-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 16px 35px rgba(0,0,0,0.10);
        }

        .action-card .icon {
            font-size: 2.6rem;
            margin-bottom: 0.8rem;
            color: #1e3c72;
        }

        .btn-pill {
            border-radius: 30px;
            padding: .55rem 1.2rem;
            font-weight: 600;
        }

        /* Mobile sidebar */
        .sidebar-toggle {
            display: none;
            position: fixed;
            top: 18px;
            left: 18px;
            z-index: 1000;
            background: #1e3c72;
            color: #fff;
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            box-shadow: 0 6px 15px rgba(0,0,0,0.2);
        }

        @media (max-width: 768px) {
            .sidebar { left: -100%; }
            .sidebar.show { left: 0; }
            .main-content { margin-left: 0; padding-top: 70px; }
            .sidebar-toggle { display: block; }
        }
    </style>
</head>

<body>

<button class="sidebar-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<!-- Sidebar -->
<div class="sidebar" id="sidebar">
    <div class="sidebar-header">
        <div class="staff-avatar">
            <i class="fas fa-user-tie"></i>
        </div>
        <h5><%= user.getUsername() %></h5>
        <small>Staff Panel</small>
    </div>

    <nav class="nav flex-column mt-2">
        <a href="<%=request.getContextPath()%>/StaffDashboard" class="nav-link-custom active">
            <i class="fas fa-tachometer-alt"></i> Dashboard
        </a>

        <a href="<%=request.getContextPath()%>/staff/addReservation.jsp" class="nav-link-custom">
            <i class="fas fa-calendar-plus"></i> Add Reservation
        </a>

        <a href="<%=request.getContextPath()%>/ViewReservations" class="nav-link-custom">
            <i class="fas fa-calendar-check"></i> View Reservations
        </a>

        <a href="<%=request.getContextPath()%>/PrintBill" class="nav-link-custom">
            <i class="fas fa-file-invoice-dollar"></i> Print Bills
        </a>

        <a href="<%=request.getContextPath()%>/staff/notifications.jsp" class="nav-link-custom">
            <i class="fas fa-bell"></i> Notifications
        </a>

        <a href="<%=request.getContextPath()%>/staff/help.jsp" class="nav-link-custom">
            <i class="fas fa-bell-concierge"></i> Help
        </a>

        <a href="<%=request.getContextPath()%>/LogoutServlet" class="nav-link-custom">
            <i class="fas fa-sign-out-alt"></i> Logout
        </a>
    </nav>
</div>

<!-- Main -->
<div class="main-content">

    <!-- Welcome -->
    <div class="welcome-card">
        <div class="content-layer d-flex justify-content-between align-items-start flex-wrap gap-3">
            <div>
                <h3 class="mb-1"><i class="fas fa-handshake me-2"></i>Welcome, <%= user.getUsername() %>!</h3>
                <p class="mb-0"><i class="fas fa-calendar-alt me-2"></i><%= today %></p>
            </div>

            <!-- 🔔 Notifications dropdown -->
            <div class="dropdown">
                <button class="btn btn-light position-relative shadow-sm"
                        type="button"
                        data-bs-toggle="dropdown"
                        data-bs-auto-close="outside"
                        aria-expanded="false"
                        style="border-radius: 12px;">
                    <i class="fas fa-bell"></i>

                    <% if (notiCount > 0) { %>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                            <%= (notiCount > 99 ? "99+" : notiCount) %>
                        </span>
                    <% } %>
                </button>

                <div class="dropdown-menu dropdown-menu-end shadow noti-menu">
                    <div class="noti-header">
                        <div class="fw-bold text-primary">Staff Notifications</div>
                        <a class="text-decoration-none" href="<%=request.getContextPath()%>/staff/notifications.jsp">View All</a>
                    </div>

                    <div class="noti-list">
                        <%
                            if (notifications == null || notifications.isEmpty()) {
                        %>
                            <div class="px-3 py-3 text-muted">No new notifications</div>
                        <%
                            } else {
                                int maxShow = Math.min(8, notifications.size());
                                for (int i = 0; i < maxShow; i++) {
                                    Object msg = notifications.get(i);
                        %>
                            <a class="noti-item" href="#">
                                <i class="fas fa-circle-info noti-icon"></i>
                                <div class="noti-text"><%= String.valueOf(msg) %></div>
                            </a>
                        <%
                                }
                            }
                        %>
                    </div>

                    <% if (notifications != null && !notifications.isEmpty()) { %>
                    <div class="noti-footer">
                        <form action="<%=request.getContextPath()%>/ClearStaffNotifications" method="post" class="m-0">
                            <button class="btn btn-sm btn-outline-danger w-100">Clear All</button>
                        </form>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <i class="fas fa-water bg-icon"></i>
    </div>

    <!-- Stats -->
    <div class="row g-4 mb-4">
        <div class="col-md-3 col-sm-6">
            <div class="card-soft">
                <div class="stat-box">
                    <div class="stat-icon bg-a"><i class="fas fa-bed"></i></div>
                    <div>
                        <p class="stat-title">Total Rooms</p>
                        <p class="stat-value">45</p>
                    </div>
                </div>
                <small class="text-success"><i class="fas fa-circle-check me-1"></i>12 available</small>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card-soft">
                <div class="stat-box">
                    <div class="stat-icon bg-b"><i class="fas fa-calendar-check"></i></div>
                    <div>
                        <p class="stat-title">Today Check-ins</p>
                        <p class="stat-value">8</p>
                    </div>
                </div>
                <small class="text-info"><i class="fas fa-arrow-up me-1"></i>+3 vs yesterday</small>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card-soft">
                <div class="stat-box">
                    <div class="stat-icon bg-c"><i class="fas fa-user-friends"></i></div>
                    <div>
                        <p class="stat-title">Current Guests</p>
                        <p class="stat-value">112</p>
                    </div>
                </div>
                <small class="text-warning"><i class="fas fa-chart-pie me-1"></i>78% occupancy</small>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card-soft">
                <div class="stat-box">
                    <div class="stat-icon bg-d"><i class="fas fa-dollar-sign"></i></div>
                    <div>
                        <p class="stat-title">Today Revenue</p>
                        <p class="stat-value">Rs. 4,250</p>
                    </div>
                </div>
                <small class="text-success"><i class="fas fa-arrow-up me-1"></i>12%</small>
            </div>
        </div>
    </div>

    <!-- Quick Actions -->
    <h4 class="mb-3 fw-bold text-dark"><i class="fas fa-bolt me-2"></i>Quick Actions</h4>

    <div class="row g-4">
        <div class="col-md-4">
            <div class="action-card">
                <div class="icon"><i class="fas fa-calendar-plus"></i></div>
                <h5 class="fw-bold mb-2">Add Reservation</h5>
                <p class="text-muted mb-3">Create a new booking for guests</p>
                <a href="<%=request.getContextPath()%>/staff/addReservation.jsp" class="btn btn-primary btn-pill">
                    <i class="fas fa-plus me-2"></i>Create
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="action-card">
                <div class="icon"><i class="fas fa-calendar-check"></i></div>
                <h5 class="fw-bold mb-2">View Reservations</h5>
                <p class="text-muted mb-3">See reservations list</p>
                <a href="<%=request.getContextPath()%>/ViewReservations" class="btn btn-success btn-pill">
                    <i class="fas fa-eye me-2"></i>View
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="action-card">
                <div class="icon"><i class="fas fa-file-invoice-dollar"></i></div>
                <h5 class="fw-bold mb-2">Print Bills</h5>
                <p class="text-muted mb-3">Print reservation bills</p>
                <a href="<%=request.getContextPath()%>/PrintBill" class="btn btn-dark btn-pill">
                    <i class="fas fa-print me-2"></i>Open
                </a>
            </div>
        </div>
    </div>

</div>

<!-- Bootstrap Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function toggleSidebar() {
        document.getElementById('sidebar').classList.toggle('show');
    }

    // Don't interfere with dropdown clicks
    document.addEventListener('click', function(event) {
        const sidebar = document.getElementById('sidebar');
        const toggleButton = document.querySelector('.sidebar-toggle');

        if (event.target.closest('.dropdown')) return;

        if (window.innerWidth <= 768) {
            if (!sidebar.contains(event.target) && !toggleButton.contains(event.target)) {
                sidebar.classList.remove('show');
            }
        }
    });
</script>

</body>
</html>