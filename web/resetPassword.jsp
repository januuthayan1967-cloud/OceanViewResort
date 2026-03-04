<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String token = request.getParameter("token");
    if (token == null || token.isBlank()) {
        response.sendRedirect(request.getContextPath() + "/forgotPassword.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width:520px;">
    <div class="card p-4 shadow">
        <h4 class="text-success mb-3">Reset Password</h4>

        <% String error = (String) request.getAttribute("error"); %>
        <% if (error != null) { %>
            <div class="alert alert-danger"><%= error %></div>
        <% } %>

        <form action="<%=request.getContextPath()%>/ResetPasswordServlet" method="post">
            <input type="hidden" name="token" value="<%= token %>">

            <label class="form-label">New Password</label>
            <input type="password" name="password" class="form-control" required>

            <label class="form-label mt-3">Confirm Password</label>
            <input type="password" name="confirm" class="form-control" required>

            <button class="btn btn-success w-100 mt-3">Update Password</button>
        </form>

        <a class="btn btn-link w-100 mt-2" href="<%=request.getContextPath()%>/login.jsp">Back to Login</a>
    </div>
</div>
</body>
</html>