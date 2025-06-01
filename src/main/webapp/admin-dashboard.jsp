<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession adminSession = request.getSession(false);
    if (adminSession == null || adminSession.getAttribute("admin") == null) {
        response.sendRedirect("admin-login.jsp");
        return;
    }

    String search = request.getParameter("search");
    if (search == null) {
        search = "";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="d-flex justify-content-between mb-4">
        <h3>Admin Dashboard</h3>
        <div>
            <form class="d-inline-flex me-3" method="get" action="admin-dashboard.jsp">
                <input type="text" name="search" value="<%= search %>" class="form-control me-2" placeholder="Search by title or author">
                <button type="submit" class="btn btn-outline-primary">Search</button>
            </form>
            <a href="add-book.jsp" class="btn btn-success me-2">+ Add Book</a>
            <a href="admin-login.jsp" class="btn btn-danger">Logout</a>
        </div>
    </div>

    <table class="table table-bordered table-striped">
        <thead class="table-dark">
        <tr>
            <th>ID</th><th>Title</th><th>Author</th><th>Genre</th><th>Availability</th><th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259"
                );

                PreparedStatement stmt;
                if (!search.isEmpty()) {
                    stmt = conn.prepareStatement("SELECT * FROM books WHERE title LIKE ? OR author LIKE ?");
                    stmt.setString(1, "%" + search + "%");
                    stmt.setString(2, "%" + search + "%");
                } else {
                    stmt = conn.prepareStatement("SELECT * FROM books");
                }

                ResultSet rs = stmt.executeQuery();

                while (rs.next()) {
                    int id = rs.getInt("id");
                    String title = rs.getString("title");
                    String author = rs.getString("author");
                    String genre = rs.getString("genre");
                    boolean available = rs.getBoolean("availability");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= title %></td>
            <td><%= author %></td>
            <td><%= genre %></td>
            <td><%= available ? "Available" : "Borrowed" %></td>
            <td>
                <a href="edit-book.jsp?id=<%= id %>" class="btn btn-sm btn-primary">Edit</a>
                <% if (available) { %>
                    <a href="delete-book?id=<%= id %>" class="btn btn-sm btn-danger"
                       onclick="return confirm('Are you sure you want to delete this book?')">Delete</a>
                <% } %>
            </td>
        </tr>

        <%
            PreparedStatement ps = conn.prepareStatement(
                "SELECT u.name, bb.borrow_date, bb.return_date " +
                "FROM borrowed_books bb " +
                "JOIN users u ON bb.user_id = u.id " +
                "WHERE bb.book_id = ? " +
                "ORDER BY bb.borrow_date DESC LIMIT 1"
            );
            ps.setInt(1, id);
            ResultSet userRs = ps.executeQuery();

            if (userRs.next()) {
                String borrower = userRs.getString("name");
                Timestamp borrowDate = userRs.getTimestamp("borrow_date");
                Timestamp returnDate = userRs.getTimestamp("return_date");
        %>
        <tr>
            <td colspan="6" class="ps-4 text-muted">
                <strong>Last Borrowed By:</strong> <%= borrower %><br>
                <strong>Borrowed On:</strong> <%= borrowDate %><br>
                <strong>Status:</strong>
                <%= returnDate == null
                        ? "<span class='text-danger'>Not Returned</span>"
                        : "Returned on " + returnDate %>
            </td>
        </tr>
        <%
            } else {
        %>
        <tr>
            <td colspan="6" class="ps-4 text-muted">
                <strong>Not Borrowed</strong>
            </td>
        </tr>
        <%
            }
            userRs.close();
            ps.close();
                }
                conn.close();
            } catch (Exception e) {
                out.println("<tr><td colspan='6'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>
</body>
</html>
