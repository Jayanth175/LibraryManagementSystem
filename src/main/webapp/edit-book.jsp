<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int bookId = Integer.parseInt(request.getParameter("id"));

    String title = "", author = "", genre = "";
    int availability = 1;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259"
        );

        PreparedStatement ps = conn.prepareStatement("SELECT * FROM books WHERE id = ?");
        ps.setInt(1, bookId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            author = rs.getString("author");
            genre = rs.getString("genre");
            availability = rs.getInt("availability");
        }

        conn.close();
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Book - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <h3 class="mb-4">Edit Book</h3>
    <form action="updateBook" method="post">
        <input type="hidden" name="id" value="<%= bookId %>" />
        <div class="mb-3">
            <label>Title</label>
            <input type="text" name="title" class="form-control" value="<%= title %>" required/>
        </div>
        <div class="mb-3">
            <label>Author</label>
            <input type="text" name="author" class="form-control" value="<%= author %>" required/>
        </div>
        <div class="mb-3">
            <label>Genre</label>
            <input type="text" name="genre" class="form-control" value="<%= genre %>" required/>
        </div>
        <div class="mb-3">
            <label>Availability</label>
            <select name="availability" class="form-control">
                <option value="1" <%= availability == 1 ? "selected" : "" %>>Available</option>
                <option value="0" <%= availability == 0 ? "selected" : "" %>>Borrowed</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Update Book</button>
        <a href="admin-dashboard.jsp" class="btn btn-secondary">Cancel</a>
    </form>
</div>
</body>
</html>
