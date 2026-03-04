<%-- 
    Document   : login
    Created on : Feb 26, 2026, 11:43:01 AM
    Author     : User
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.4);
            backdrop-filter: blur(4px);
            z-index: 1;
        }

        .container {
            position: relative;
            z-index: 2;
            width: 100%;
            padding: 1rem;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            padding: 2.8rem 2.5rem;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 480px;
            width: 100%;
            margin: auto;
        }

        .glass-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }

        .glass-card h3 {
            font-weight: 600;
            font-size: 2.2rem;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
            letter-spacing: 1px;
        }

        .glass-card hr {
            border-top: 2px solid rgba(255, 255, 255, 0.3);
            opacity: 0.8;
            width: 60px;
            margin: 1rem auto;
        }

        .form-label {
            font-weight: 400;
            font-size: 1rem;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.3);
            display: block;
            text-align: left;
            margin-bottom: 0.3rem;
        }

        .input-group-custom {
            background: rgba(255, 255, 255, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            display: flex;
            align-items: center;
            padding: 0.3rem 1rem;
            margin-bottom: 1.5rem;
            transition: background 0.3s, border-color 0.3s;
        }

        .input-group-custom i {
            color: white;
            font-size: 1.2rem;
            margin-right: 0.8rem;
            text-shadow: 1px 1px 4px rgba(0,0,0,0.3);
        }

        .input-group-custom input {
            background: transparent;
            border: none;
            outline: none;
            color: white;
            font-size: 1rem;
            width: 100%;
        }

        .input-group-custom input::placeholder {
            color: rgba(255, 255, 255, 0.7);
            font-weight: 300;
        }

        .input-group-custom:focus-within {
            background: rgba(255, 255, 255, 0.25);
            border-color: rgba(255, 255, 255, 0.7);
        }

        .btn-login {
            background: linear-gradient(45deg, #0099ff, #005bea);
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-weight: 500;
            font-size: 1.2rem;
            color: white;
            width: 100%;
            transition: all 0.3s;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.3);
            margin-top: 1rem;
        }

        .btn-login:hover {
            background: linear-gradient(45deg, #0088ee, #0046c0);
            transform: scale(1.02);
            box-shadow: 0 8px 25px rgba(0, 100, 255, 0.5);
        }

        .error-alert {
            background: rgba(220, 53, 69, 0.8);
            backdrop-filter: blur(4px);
            border: none;
            border-radius: 50px;
            color: white;
            padding: 0.8rem 1.5rem;
            font-size: 0.95rem;
            text-align: center;
            margin-top: 1.5rem;
            box-shadow: 0 4px 10px rgba(0,0,0,0.2);
        }

        .back-link {
            display: inline-block;
            margin-top: 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 1rem;
            transition: color 0.3s;
        }

        .back-link i { margin-right: 5px; }

        .back-link:hover {
            color: white;
            text-decoration: underline;
        }

        .forgot-link{
            color: rgba(255,255,255,0.9);
            font-size: 0.9rem;
            text-decoration: none;
        }

        .forgot-link:hover{
            text-decoration: underline;
            color:#ffffff;
        }

    </style>
</head>

<body>
<div class="container d-flex justify-content-center align-items-center">
    <div class="glass-card">
        <div class="text-center">
            <h3><i class="fas fa-lock me-2"></i>Login</h3>
            <hr>
        </div>

        <%
            String successMessage = (String) session.getAttribute("successMessage");
            if (successMessage != null) {
        %>
        <div class="alert alert-success text-center mb-3" style="border-radius:50px;">
            <i class="fas fa-check-circle me-2"></i><%= successMessage %>
        </div>
        <%
                session.removeAttribute("successMessage");
            }
        %>

        <form action="<%=request.getContextPath()%>/LoginServlet" method="post">

            <div class="mb-2">
                <label class="form-label"><i class="fas fa-user me-1"></i>Username / Email</label>
                <div class="input-group-custom">
                    <i class="fas fa-user-circle"></i>
                    <input type="text" name="username" placeholder="Enter your username or email" required>
                </div>
            </div>

            <div class="mb-2">
                <label class="form-label"><i class="fas fa-key me-1"></i>Password</label>
                <div class="input-group-custom">
                    <i class="fas fa-lock"></i>
                    <input type="password" name="password" placeholder="Enter your password" required>
                </div>
            </div>

            <!-- ✅ Added Forgot Password -->
            <div class="text-end mb-2">
                <a href="<%=request.getContextPath()%>/forgotPassword.jsp" class="forgot-link">
                    Forgot Password?
                </a>
            </div>

            <button type="submit" class="btn btn-login">
                <i class="fas fa-sign-in-alt me-2"></i>Login
            </button>

            <%
                Object err = request.getAttribute("error");
                if (err != null) {
            %>
            <div class="error-alert">
                <i class="fas fa-exclamation-circle me-2"></i><%= err %>
            </div>
            <% } %>

        </form>

        <div class="text-center">
            <a href="<%=request.getContextPath()%>/index.jsp" class="back-link">
                <i class="fas fa-arrow-left"></i> Back to Home
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>