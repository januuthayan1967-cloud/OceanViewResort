<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width:520px;">
    <div class="card p-4 shadow">
        <h4 class="text-primary mb-3">Forgot Password</h4>

        <%
            String error = (String) request.getAttribute("error");
            String msg = (String) session.getAttribute("successMessage");
            String resetLink = (String) session.getAttribute("resetLink");
        %>

        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <% if (msg != null) { %>
            <div class="alert alert-success"><%= msg %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/ForgotPasswordServlet" method="post">
            <label class="form-label">Enter your email</label>
            <input type="email" name="email" class="form-control" required>
            <button type="submit" class="btn btn-primary w-100 mt-3">Generate Reset Link</button>
        </form>

        <% if (resetLink != null) { %>
            <div class="mt-3">
                <a class="btn btn-success w-100" href="<%= resetLink %>">
                    Open Reset Password Page
                </a>

                <div class="small text-muted mt-2">
                    Or copy this link:
                    <div class="p-2 bg-white border rounded mt-1" style="word-break:break-all;">
                        <%= resetLink %>
                    </div>
                </div>
            </div>
        <% } %>

        <a class="btn btn-link w-100 mt-3" href="<%=request.getContextPath()%>/login.jsp">
            Back to Login
        </a>
    </div>
</div>
</body>
</html>

<%
    session.removeAttribute("successMessage");
    session.removeAttribute("resetLink");
%>