<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.List" %>

<%
    // ✅ ADMIN SESSION CHECK
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String username = loggedUser.getUsername();
    String today = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());

    // ✅ Notifications from servlet
    Integer notiCountObj = (Integer) request.getAttribute("notiCount");
    int notiCount = (notiCountObj == null) ? 0 : notiCountObj;

    List notifications = (List) request.getAttribute("notifications");

    String active = "dashboard";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Ocean View Resort</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <style>
        * { font-family: 'Poppins', sans-serif; }

        body{
            background:#0b0f17;
            color:#e6eef7;
            min-height:100vh;
            overflow-x:hidden;
        }

        body::before{
            content:'';
            position:fixed; inset:0;
            background:
                radial-gradient(circle at 15% 20%, rgba(0, 180, 216, 0.16) 0%, transparent 35%),
                radial-gradient(circle at 85% 70%, rgba(255, 107, 107, 0.12) 0%, transparent 40%),
                linear-gradient(145deg, #070b12 0%, #122036 100%);
            z-index:0;
        }

        .app{ position:relative; z-index:1; }

        .sidebar{
            background: linear-gradient(145deg, #0e1a2b, #1b2f44);
            min-height:100vh;
            border-right: 1px solid rgba(255,255,255,0.06);
            box-shadow: 12px 0 40px rgba(0,0,0,0.55);
            position: sticky;
            top:0;
            padding: 18px 14px;
        }

        .brand{
            display:flex;
            align-items:center;
            gap:10px;
            padding: 14px 12px;
            margin-bottom: 12px;
            border-radius: 16px;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.05);
        }

        .brand i{
            font-size: 1.5rem;
            color:#4ecdc4;
            filter: drop-shadow(0 0 10px rgba(78,205,196,0.45));
        }

        .brand .title{ font-weight:700; letter-spacing:0.6px; }
        .brand small{ color: rgba(255,255,255,0.65); display:block; margin-top:-2px; }

        .nav-linkx{
            display:flex;
            align-items:center;
            gap:12px;
            color: rgba(255,255,255,0.78);
            text-decoration:none;
            padding: 12px 14px;
            margin: 6px 0;
            border-radius: 16px;
            border: 1px solid rgba(255,255,255,0.05);
            background: rgba(255,255,255,0.02);
            transition: all 0.25s ease;
        }

        .nav-linkx i{ width:22px; color:#4ecdc4; }

        .nav-linkx:hover{
            transform: translateX(6px);
            background: linear-gradient(90deg, rgba(78,205,196,0.12), rgba(255,209,102,0.10));
            color:#fff;
            border-color: rgba(255,209,102,0.25);
        }

        .nav-linkx.active{
            background: linear-gradient(90deg, rgba(0, 180, 216, 0.18), rgba(78,205,196,0.14));
            border-color: rgba(78,205,196,0.35);
            color:#fff;
            position:relative;
        }

        .nav-linkx.active::after{
            content:'';
            position:absolute;
            right:12px; top:50%;
            width:8px; height:8px;
            transform: translateY(-50%);
            border-radius:50%;
            background:#ffd166;
            box-shadow: 0 0 14px rgba(255,209,102,0.9);
        }

        .topbar{
            position: sticky;
            top: 12px;
            z-index: 1200;
            background: rgba(255,255,255,0.03);
            border: 1px solid rgba(255,255,255,0.06);
            border-radius: 18px;
            padding: 14px 16px;
            margin-bottom: 0;
            display:flex;
            align-items:center;
            justify-content:space-between;
            gap: 12px;
            backdrop-filter: blur(8px);
        }

        .content-wrap{ padding-top: 10px; }
        .topbar-spacer{ height: 14px; }
        .dropdown-menu{ z-index: 2000 !important; }

        .pill{
            display:inline-flex;
            align-items:center;
            gap:10px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,0.05);
            border: 1px solid rgba(255,255,255,0.07);
            color: rgba(255,255,255,0.85);
            font-size: 0.92rem;
        }
        .pill i{ color:#4ecdc4; }

        .bell-btn{
            border: 1px solid rgba(255,255,255,0.10);
            background: rgba(255,255,255,0.05);
            color: #fff;
            border-radius: 14px;
            padding: 10px 12px;
            position: relative;
        }
        .bell-btn:hover{ background: rgba(255,255,255,0.08); }

        .bell-badge{
            position:absolute;
            top: -6px;
            right: -6px;
            background: #ff4d6d;
            color: #fff;
            font-size: 0.75rem;
            padding: 3px 7px;
            border-radius: 999px;
            border: 2px solid #0b0f17;
            min-width: 22px;
            text-align:center;
        }

        .dropdown-menu-darkish{
            background: rgba(15, 25, 40, 0.98);
            border: 1px solid rgba(255,255,255,0.10);
            border-radius: 16px;
            min-width: 340px;
            overflow: hidden;
        }
        .dropdown-header{ color: rgba(255,255,255,0.85); }

        .noti-item{
            padding: 10px 14px;
            border-top: 1px solid rgba(255,255,255,0.06);
            color: rgba(255,255,255,0.85);
        }
        .noti-item small{
            display:block;
            color: rgba(255,255,255,0.60);
        }

        /* ✅ NEW: notification scroll view */
        .noti-scroll{
            max-height: 320px;       /* change height if you want */
            overflow-y: auto;
            overflow-x: hidden;
        }

        /* Optional scrollbar style */
        .noti-scroll::-webkit-scrollbar{ width: 6px; }
        .noti-scroll::-webkit-scrollbar-thumb{
            background: rgba(255,255,255,0.25);
            border-radius: 10px;
        }
        .noti-scroll::-webkit-scrollbar-thumb:hover{
            background: rgba(255,255,255,0.40);
        }

        .welcome{
            margin-top: 0;
            background: linear-gradient(145deg, rgba(31,74,92,0.95), rgba(44,110,143,0.95), rgba(59,158,179,0.95));
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 26px;
            padding: 22px 22px;
            box-shadow: 0 22px 48px rgba(0, 150, 200, 0.26);
            position: relative;
            overflow:hidden;
        }
        .welcome::after{
            content:'';
            position:absolute;
            right:-30px; bottom:-35px;
            width:200px; height:200px;
            background: radial-gradient(circle, rgba(255,255,255,0.18), transparent 60%);
            border-radius:50%;
        }
        .welcome h2{ font-weight: 800; margin-bottom: 4px; }
        .welcome p{ margin: 0; color: rgba(255,255,255,0.92); display:flex; gap:10px; align-items:center; }

        .glass-card{
            background: rgba(20,30,45,0.78);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 22px;
            padding: 18px 16px;
            box-shadow: 0 14px 30px rgba(0,0,0,0.35);
            transition: 0.25s ease;
            overflow:hidden;
            position:relative;
            backdrop-filter: blur(8px);
        }
        .glass-card:hover{
            transform: translateY(-6px);
            border-color: rgba(78,205,196,0.35);
            box-shadow: 0 22px 45px rgba(0, 180, 216, 0.20);
        }
        .glass-card .icon{
            font-size: 2.2rem;
            color:#4ecdc4;
            margin-bottom: 10px;
            filter: drop-shadow(0 0 10px rgba(78,205,196,0.35));
        }
        .big{ font-size: 1.9rem; font-weight: 800; line-height: 1.1; }
        .muted{ color: rgba(255,255,255,0.65); font-size: 0.92rem; }

        .btn-round{
            border-radius: 999px;
            padding: 10px 16px;
            font-weight: 600;
            border: none;
        }
        .btn-cyan{ background: linear-gradient(45deg, #4ecdc4, #2f9e95); color:#071019; }
        .btn-gold{ background: linear-gradient(45deg, #ffd166, #e6b800); color:#101018; }
        .btn-blue{ background: linear-gradient(45deg, #2a4e6b, #1d4e6f); color:#fff; }

        .sidebar-toggle{
            display:none;
            position:fixed;
            top:16px; left:16px;
            z-index: 2000;
            border:none;
            border-radius: 14px;
            padding: 10px 12px;
            background: rgba(14,26,43,0.9);
            color:#fff;
            box-shadow: 0 10px 25px rgba(0,0,0,0.4);
        }
        @media(max-width: 992px){
            .sidebar{
                position:fixed;
                left:-110%;
                width: 270px;
                transition: left 0.3s ease;
                z-index: 1500;
            }
            .sidebar.show{ left:0; }
            .sidebar-toggle{ display:block; }
            .content-wrap{ padding-top: 70px; }
            .topbar{ top: 8px; }
        }
    </style>
</head>

<body>
<button class="sidebar-toggle" onclick="toggleSidebar()">
    <i class="fas fa-bars"></i>
</button>

<div class="container-fluid app">
    <div class="row">

        <!-- SIDEBAR -->
        <div class="col-lg-2 sidebar" id="sidebar">
            <div class="brand">
                <i class="fas fa-crown"></i>
                <div>
                    <div class="title">Admin Panel</div>
                    <small>Ocean View Resort</small>
                </div>
            </div>

            <a class="nav-linkx <%= "dashboard".equals(active) ? "active" : "" %>"
               href="<%=request.getContextPath()%>/AdminDashboard">
                <i class="fas fa-tachometer-alt"></i> Dashboard
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/AdminManageUsers">
                <i class="fas fa-users"></i> Manage Users
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/AdminManageUsers">
                <i class="fas fa-user-tie"></i> Manage Staff
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/admin/addReservation.jsp">
                <i class="fas fa-calendar-plus"></i> Add Reservation
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/ViewReservations">
                <i class="fas fa-calendar-check"></i> Reservations
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/PrintBill">
                <i class="fas fa-file-invoice-dollar"></i> Print Bill
            </a>

            <a class="nav-linkx" href="<%=request.getContextPath()%>/LogoutServlet">
                <i class="fas fa-sign-out-alt"></i> Logout
            </a>
        </div>

        <!-- MAIN CONTENT -->
        <div class="col-lg-10 p-4 content-wrap">

            <!-- TOP BAR -->
            <div class="topbar">
                <div class="d-flex align-items-center gap-2 flex-wrap">
                    <div class="pill">
                        <i class="fas fa-user-shield"></i>
                        <span>Logged in as <b><%= username %></b></span>
                    </div>
                    <div class="pill">
                        <i class="fas fa-calendar-alt"></i>
                        <span><%= today %></span>
                    </div>
                </div>

                <!-- 🔔 Notification Bell -->
                <div class="dropdown">
                    <button class="bell-btn" type="button" data-bs-toggle="dropdown" aria-expanded="false" title="Notifications">
                        <i class="fas fa-bell"></i>
                        <% if (notiCount > 0) { %>
                            <span class="bell-badge"><%= (notiCount > 99 ? "99+" : notiCount) %></span>
                        <% } %>
                    </button>

                    <div class="dropdown-menu dropdown-menu-end dropdown-menu-darkish p-0">

                        <!-- Header -->
                        <div class="p-3 d-flex justify-content-between align-items-center">
                            <div class="dropdown-header p-0"><b>Notifications</b></div>
                            <a href="<%=request.getContextPath()%>/admin/notifications.jsp"
                               class="text-decoration-none" style="color:#4ecdc4;">
                                View All
                            </a>
                        </div>

                        <!-- ✅ Scrollable list -->
                        <div class="noti-scroll">
                            <%
                                if (notifications == null || notifications.isEmpty()) {
                            %>
                                <div class="noti-item">
                                    No notifications
                                    <small>You're all caught up ✅</small>
                                </div>
                            <%
                                } else {
                                    int maxShow = Math.min(20, notifications.size()); // show more with scroll
                                    for (int i = 0; i < maxShow; i++) {
                                        Object n = notifications.get(i);
                            %>
                                <div class="noti-item">
                                    <i class="fas fa-circle-info me-2" style="color:#ffd166;"></i>
                                    <%= String.valueOf(n) %>
                                    <small></small>
                                </div>
                            <%
                                    }
                                }
                            %>
                        </div>

                        <!-- Footer -->
                        <div class="p-2 text-center" style="border-top:1px solid rgba(255,255,255,0.08);">
                            <a class="btn btn-sm btn-blue w-100" href="<%=request.getContextPath()%>/admin/notifications.jsp">
                                Open Notifications
                            </a>
                        </div>

                    </div>
                </div>
            </div>

            <div class="topbar-spacer"></div>

            <!-- WELCOME -->
            <div class="welcome mb-4">
                <h2>Welcome, <%= username %> 👋</h2>
                <p><i class="fas fa-sparkles"></i> Manage users, staff, reservations and billing from one place.</p>
            </div>

            <!-- Cards -->
            <div class="row g-4 mb-2">
                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-users"></i></div>
                        <div class="big">150</div>
                        <div class="muted">Total Users</div>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-user-tie"></i></div>
                        <div class="big">10</div>
                        <div class="muted">Total Staff</div>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-bed"></i></div>
                        <div class="big">50</div>
                        <div class="muted">Total Rooms</div>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-calendar-check"></i></div>
                        <div class="big">20</div>
                        <div class="muted">Reservations Today</div>
                    </div>
                </div>
            </div>

            <div class="d-flex align-items-center justify-content-between mt-4 mb-3">
                <h4 class="m-0" style="font-weight:800;color:#f3fbff;">
                    <i class="fas fa-bolt me-2" style="color:#4ecdc4;"></i>Quick Actions
                </h4>
            </div>

            <div class="row g-4">
                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-users"></i></div>
                        <h5 class="mb-2" style="font-weight:700;">Manage Users</h5>
                        <div class="muted mb-3">View / Edit / Delete users</div>
                        <a class="btn btn-round btn-blue w-100" href="<%=request.getContextPath()%>/AdminManageUsers">Open</a>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-user-tie"></i></div>
                        <h5 class="mb-2" style="font-weight:700;">Manage Staff</h5>
                        <div class="muted mb-3">Create & manage staff accounts</div>
                        <a class="btn btn-round btn-cyan w-100" href="<%=request.getContextPath()%>/AdminManageUsers">Open</a>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-calendar-plus"></i></div>
                        <h5 class="mb-2" style="font-weight:700;">Add Reservation</h5>
                        <div class="muted mb-3">Create new booking</div>
                        <a class="btn btn-round btn-gold w-100" href="<%=request.getContextPath()%>/admin/addReservation.jsp">Create</a>
                    </div>
                </div>

                <div class="col-md-6 col-xl-3">
                    <div class="glass-card text-center">
                        <div class="icon"><i class="fas fa-calendar-check"></i></div>
                        <h5 class="mb-2" style="font-weight:700;">View Reservations</h5>
                        <div class="muted mb-3">See all bookings</div>
                        <a class="btn btn-round btn-blue w-100" href="<%=request.getContextPath()%>/ViewReservations">View</a>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleSidebar(){
        document.getElementById('sidebar').classList.toggle('show');
    }

    document.addEventListener('click', function(e){
        const sidebar = document.getElementById('sidebar');
        const toggleBtn = document.querySelector('.sidebar-toggle');

        if(window.innerWidth <= 992){
            if(!sidebar.contains(e.target) && !toggleBtn.contains(e.target)){
                sidebar.classList.remove('show');
            }
        }
    });
</script>
</body>
</html>