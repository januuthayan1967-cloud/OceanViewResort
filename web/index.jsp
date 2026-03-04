<%-- 
    Document   : index
    Created on : Feb 25, 2026, 11:03:33 PM
    Author     : User
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View Resort - Welcome</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <!-- Google Fonts for elegant typography -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Poppins', sans-serif;
        }

        body {
            height: 100vh;
            background: url('https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-4.0.3&auto=format&fit=crop&w=1950&q=80') no-repeat center center/cover;
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        /* Dark overlay for better text contrast */
        body::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.3);
            backdrop-filter: blur(3px);
            z-index: 1;
        }

        .container {
            position: relative;
            z-index: 2;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border-radius: 30px;
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 20px 50px rgba(0, 0, 0, 0.3);
            padding: 3rem 2.5rem;
            color: white;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            max-width: 550px;
            width: 90%;
            margin: auto;
        }

        .glass-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 30px 60px rgba(0, 0, 0, 0.4);
        }

        .glass-card h1 {
            font-weight: 600;
            font-size: 2.7rem;
            text-shadow: 2px 2px 8px rgba(0,0,0,0.5);
            letter-spacing: 1px;
        }

        .glass-card p {
            font-size: 1.3rem;
            font-weight: 300;
            text-shadow: 1px 1px 5px rgba(0,0,0,0.5);
            margin-bottom: 2rem;
        }

        .btn-custom {
            padding: 12px 30px;
            border-radius: 50px;
            font-weight: 500;
            font-size: 1.1rem;
            transition: all 0.3s;
            border: none;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
            margin: 0.5rem;
            min-width: 140px;
        }

        .btn-primary-custom {
            background: linear-gradient(45deg, #0099ff, #005bea);
            color: white;
        }

        .btn-primary-custom:hover {
            background: linear-gradient(45deg, #0088ee, #0046c0);
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0, 100, 255, 0.4);
            color: white;
        }

        .btn-success-custom {
            background: linear-gradient(45deg, #00b09b, #96c93d);
            color: white;
        }

        .btn-success-custom:hover {
            background: linear-gradient(45deg, #009688, #7cb342);
            transform: scale(1.05);
            box-shadow: 0 8px 20px rgba(0, 200, 150, 0.4);
            color: white;
        }

        .btn-secondary-custom {
            background: rgba(255, 255, 255, 0.3);
            backdrop-filter: blur(5px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            color: white;
        }

        .btn-secondary-custom:hover {
            background: rgba(255, 255, 255, 0.5);
            transform: scale(1.05);
            color: #333;
        }

        .icon-spacing i {
            margin-right: 8px;
        }

        /* Responsive adjustments */
        @media (max-width: 576px) {
            .glass-card {
                padding: 2rem 1.5rem;
            }
            .glass-card h1 {
                font-size: 2rem;
            }
            .glass-card p {
                font-size: 1rem;
            }
            .btn-custom {
                display: block;
                width: 80%;
                margin: 0.8rem auto;
            }
        }
    </style>
</head>
<body>
    <div class="container d-flex justify-content-center align-items-center">
        <div class="glass-card text-center">
            <h1 class="mb-3"><i class="fas fa-umbrella-beach me-3"></i>Ocean View Resort</h1>
            <p class="mb-4"><i class="fas fa-water me-2"></i>Your gateway to paradise</p>
            <div class="d-flex flex-wrap justify-content-center">
                <a href="login.jsp" class="btn btn-custom btn-primary-custom icon-spacing">
                    <i class="fas fa-sign-in-alt"></i> Login
                </a>
                <a href="register.jsp" class="btn btn-custom btn-success-custom icon-spacing">
                    <i class="fas fa-user-plus"></i> Register
                </a>
                <a href="help.jsp" class="btn btn-custom btn-secondary-custom icon-spacing">
                    <i class="fas fa-question-circle"></i> Help
                </a>
            </div>
            <!-- Optional small wave decoration -->
            <div class="mt-5">
                <i class="fas fa-wave-square text-white-50 fa-2x"></i>
                <i class="fas fa-wave-square text-white-50 fa-2x mx-2"></i>
                <i class="fas fa-wave-square text-white-50 fa-2x"></i>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS (optional, only if you need components) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
