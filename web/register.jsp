<%-- 
    Document   : register
    Created on : Feb 26, 2026, 4:19:15 PM
    Author     : User
--%>

<<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register - Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body {
            min-height: 100vh;
            background: url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }

        body::before {
            content: "";
            position: absolute;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.4);
            backdrop-filter: blur(4px);
        }

        .glass-card {
            position: relative;
            z-index: 2;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(12px);
            border-radius: 25px;
            padding: 40px;
            width: 100%;
            max-width: 500px;
            color: white;
            box-shadow: 0 20px 40px rgba(0,0,0,0.4);
        }

        .input-group-custom {
            background: rgba(255,255,255,0.2);
            border-radius: 50px;
            padding: 10px 20px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
        }

        .input-group-custom i {
            margin-right: 10px;
        }

        .input-group-custom input {
            background: transparent;
            border: none;
            outline: none;
            color: white;
            width: 100%;
        }

        .input-group-custom input::placeholder {
            color: rgba(255,255,255,0.7);
        }

        .btn-register {
            background: linear-gradient(45deg,#00b09b,#96c93d);
            border: none;
            border-radius: 50px;
            padding: 12px;
            width: 100%;
            color: white;
            font-size: 18px;
            transition: 0.3s;
        }

        .btn-register:hover {
            transform: scale(1.05);
        }

        .error-alert {
            background: rgba(220,53,69,0.8);
            padding: 10px;
            border-radius: 50px;
            margin-bottom: 20px;
            text-align: center;
        }

        a {
            color: #fff;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

<div class="glass-card">
    <div class="text-center mb-4">
        <h3><i class="fas fa-user-plus"></i> Register</h3>
        <p class="text-light">Create your Ocean View Resort account</p>
    </div>

    <!-- Error Message -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="error-alert">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
    <%
        }
    %>

    <form action="RegisterServlet" method="post">

        <!-- Auto USER role -->
        <input type="hidden" name="role" value="USER">

        <!-- Username -->
        <div class="input-group-custom">
            <i class="fas fa-user"></i>
            <input type="text" name="username" placeholder="Choose Username" required>
        </div>

        <!-- Email -->
        <div class="input-group-custom">
            <i class="fas fa-envelope"></i>
            <input type="email" name="email" placeholder="Enter Email" required>
        </div>

        <!-- Password -->
        <div class="input-group-custom">
            <i class="fas fa-lock"></i>
            <input type="password" name="password" placeholder="Create Password" required>
        </div>

        <button type="submit" class="btn-register">
            <i class="fas fa-user-plus"></i> Register
        </button>
    </form>

    <div class="text-center mt-4">
        <a href="login.jsp">
            <i class="fas fa-sign-in-alt"></i> Already have an account? Login
        </a>
        <br><br>
        <a href="index.jsp">
            <i class="fas fa-arrow-left"></i> Back to Home
        </a>
    </div>
</div>

</body>
</html>