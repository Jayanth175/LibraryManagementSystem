<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Login - Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  
    
</head>
<body class="bg-light">
<div class="container mt-5">
     <a href="index.jsp" class="btn btn-secondary mb-3">← Home</a>
    <h3 class="text-center mb-4">Admin Login</h3>
    <div class="row justify-content-center">
        <div class="col-md-4">
   
            <form action="adminLogin" method="post">
                <div class="mb-3">
                    <label>Email</label>
                    <input type="email" name="email" class="form-control" required/>
                </div>
                <div class="mb-3">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required/>
                </div>
                <button class="btn btn-primary w-100" type="submit">Login</button>
            </form>
        </div>
    </div>
</div>
</body>
</html>
