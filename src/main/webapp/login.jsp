<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Library System</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
   
        body {
            background-image: url('https://images.unsplash.com/photo-1587811798408-e7200ed808d0?q=80&w=1453&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D');
            background-size: cover;
            background-position: center;
            height: 10%;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
        }
    </style>
</head>
<body class="bg-light">

<div class="container mt-5">
<div class="d-flex justify-content-end">
        <a href="index.jsp" class="btn btn-secondary mb-3">← Home</a>
    </div>
    <h2 class="text-center">User Login</h2>
 
    
    <form action="login" method="post" class="w-50 mx-auto border p-4 bg-white shadow-sm">
        <div class="mb-3">
            <label>Email:</label>
            <input type="text" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Password:</label>
            <input type="password" name="password" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary w-100">Login</button>
        <p class="mt-3 text-center">Don't have an account? <a href="register.jsp">Register</a></p>
    </form>
      
</div>
</body>
</html>
