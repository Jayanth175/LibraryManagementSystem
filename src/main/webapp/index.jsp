<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Library Management System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            background-image: url('https://images.unsplash.com/photo-1490332695540-5acc256ec383?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            height: 80vh;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .container {
            text-align: center;
            background-color: rgba(255, 255, 255, 0.85);
            padding: 50px;
            border-radius: 12px;
            box-shadow: 0 0 10px rgba(0,0,0,0.3);
        }

        h1 {
            margin-bottom: 30px;
            font-weight: bold;
        }

        .btn-group .btn {
            margin: 10px;
            min-width: 150px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Welcome to Library Management System</h1>
        <div class="btn-group d-flex justify-content-center">
            <a href="login.jsp" class="btn btn-primary">User Login</a>
            <a href="admin-login.jsp" class="btn btn-dark">Admin Login</a>
        </div>
    </div>
</body>
</html>
