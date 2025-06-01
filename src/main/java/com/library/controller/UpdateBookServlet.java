package com.library.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;


public class UpdateBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int id = Integer.parseInt(request.getParameter("id"));
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String genre = request.getParameter("genre");
        int availability = Integer.parseInt(request.getParameter("availability"));

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259"
            );

            PreparedStatement ps = conn.prepareStatement(
                "UPDATE books SET title=?, author=?, genre=?, availability=? WHERE id=?"
            );
            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, genre);
            ps.setInt(4, availability);
            ps.setInt(5, id);

            int result = ps.executeUpdate();
            conn.close();

            if (result > 0) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.getWriter().println("Failed to update book.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
