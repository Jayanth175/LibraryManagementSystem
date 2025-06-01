package com.library.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/delete-book")
public class DeleteBookServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");

        if (idParam != null && !idParam.isEmpty()) {
            int bookId = Integer.parseInt(idParam);

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection conn = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259"
                );

                PreparedStatement ps = conn.prepareStatement("DELETE FROM books WHERE id = ?");
                ps.setInt(1, bookId);
                int result = ps.executeUpdate();
                conn.close();

                response.sendRedirect("admin-dashboard.jsp");

            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("Error while deleting book: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Invalid or missing book ID.");
        }
    }
}
