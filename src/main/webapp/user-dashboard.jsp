<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<%
    String userName = (String) session.getAttribute("user_name");
    Integer userId = (Integer) session.getAttribute("user_id");
    if (userName == null || userId == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String search = request.getParameter("search");
    String authorFilter = request.getParameter("author");
    String availabilityFilter = request.getParameter("availability");

    if (search == null) search = "";
    if (authorFilter == null) authorFilter = "";
    if (availabilityFilter == null) availabilityFilter = "";
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Dashboard - Library</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .book-card img { height: 200px; object-fit: cover; }
        .navbar { margin-bottom: 30px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light bg-light px-4">
    <span class="navbar-brand">Welcome, <strong><%= userName %></strong></span>
    <div class="ms-auto">
        <a href="logout" class="btn btn-outline-danger">Logout</a>
    </div>
</nav>

<div class="container">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3>Available Books</h3>
        <form class="d-flex" method="get" action="user-dashboard.jsp">
            <input type="text" name="search" value="<%= search %>" class="form-control me-2" placeholder="Search by title or author">
            <select name="author" class="form-select me-2">
                <option value="">All Authors</option>
                <%
                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259");
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery("SELECT DISTINCT author FROM books");

                        while (rs.next()) {
                            String author = rs.getString("author");
                %>
                            <option value="<%= author %>" <%= author.equals(authorFilter) ? "selected" : "" %>><%= author %></option>
                <%
                        }
                        conn.close();
                    } catch (Exception e) {
                        out.println("<option>Error loading authors</option>");
                    }
                %>
            </select>

            <select name="availability" class="form-select me-2">
                <option value="">All Status</option>
                <option value="available" <%= "available".equals(availabilityFilter) ? "selected" : "" %>>Available</option>
                <option value="borrowed" <%= "borrowed".equals(availabilityFilter) ? "selected" : "" %>>Borrowed</option>
            </select>

            <button type="submit" class="btn btn-outline-primary">Filter</button>
        </form>
    </div>

    <div class="row">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259");

                StringBuilder query = new StringBuilder("SELECT * FROM books WHERE 1=1");
                if (!search.isEmpty()) {
                    query.append(" AND (title LIKE ? OR author LIKE ?)");
                }
                if (!authorFilter.isEmpty()) {
                    query.append(" AND author = ?");
                }
                if ("available".equals(availabilityFilter)) {
                    query.append(" AND availability = true");
                } else if ("borrowed".equals(availabilityFilter)) {
                    query.append(" AND availability = false");
                }

                PreparedStatement ps = conn.prepareStatement(query.toString());

                int paramIndex = 1;
                if (!search.isEmpty()) {
                    ps.setString(paramIndex++, "%" + search + "%");
                    ps.setString(paramIndex++, "%" + search + "%");
                }
                if (!authorFilter.isEmpty()) {
                    ps.setString(paramIndex++, authorFilter);
                }

                ResultSet rs = ps.executeQuery();
                while (rs.next()) {
                    boolean available = rs.getBoolean("availability");
        %>
        <div class="col-md-3 mb-4">
            <div class="card book-card shadow-sm">
                <img src="<%= rs.getString("image_url") != null ? rs.getString("image_url") : "https://via.placeholder.com/200x250?text=No+Image" %>" class="card-img-top" alt="Book Cover">
                <div class="card-body">
                    <h5 class="card-title"><%= rs.getString("title") %></h5>
                    <p class="card-text">Author: <%= rs.getString("author") %></p>
                    <p class="card-text"><strong>Genre:</strong> <%= rs.getString("genre") %></p>
                    <%
                        if (available) {
                    %>
                    <form action="borrow" method="post">
                        <input type="hidden" name="book_id" value="<%= rs.getInt("id") %>">
                        <button type="submit" class="btn btn-primary w-100">Borrow</button>
                    </form>
                    <%
                        } else {
                    %>
                    <button class="btn btn-secondary w-100" disabled>Not Available</button>
                    <%
                        }
                    %>
                </div>
            </div>
        </div>
        <%
                }
                conn.close();
            } catch (Exception e) {
                out.println("<p class='text-danger'>Error loading books: " + e.getMessage() + "</p>");
            }
        %>
    </div>

    <hr>

    <h3 class="mt-5 mb-3">Books You Borrowed</h3>
    <div class="row">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn2 = DriverManager.getConnection("jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259");

                PreparedStatement ps = conn2.prepareStatement(
                    "SELECT b.id AS book_id, b.title, b.author, bb.borrow_date " +
                    "FROM borrowed_books bb JOIN books b ON bb.book_id = b.id WHERE bb.user_id = ? AND bb.return_date IS NULL"
                );
                ps.setInt(1, userId);
                ResultSet rs2 = ps.executeQuery();

                boolean hasBorrowed = false;
                while (rs2.next()) {
                    hasBorrowed = true;
        %>
        <div class="col-md-4 mb-3">
            <div class="card shadow-sm">
                <div class="card-body">
                    <h5 class="card-title"><%= rs2.getString("title") %></h5>
                    <p class="card-text">Author: <%= rs2.getString("author") %></p>
                    <p class="card-text text-muted">Borrowed on: <%= rs2.getDate("borrow_date") %></p>
                    <form action="return" method="post">
                        <input type="hidden" name="book_id" value="<%= rs2.getInt("book_id") %>">
                        <button class="btn btn-success btn-sm mt-2">Return Book</button>
                    </form>
                </div>
            </div>
        </div>
        <%
                }

                if (!hasBorrowed) {
        %>
        <div class="col-12">
            <p class="text-muted">You haven't borrowed any books yet.</p>
        </div>
        <%
                }

                conn2.close();
            } catch (Exception e) {
                out.println("<p class='text-danger'>Error fetching borrowed books: " + e.getMessage() + "</p>");
            }
        %>
    </div>
</div>

</body>
</html>
