package com.library.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/addBook")
public class AddBookServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String genre = request.getParameter("genre");
        String imageUrl = request.getParameter("image_url");

        int availability = 1; // Default to available

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259"
            );

            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO books (title, author, genre, image_url, availability) VALUES (?, ?, ?, ?, ?)"
            );
            ps.setString(1, title);
            ps.setString(2, author);
            ps.setString(3, genre);
            ps.setString(4, imageUrl);
            ps.setInt(5, availability);

            int result = ps.executeUpdate();
            conn.close();

            if (result > 0) {
                response.sendRedirect("admin-dashboard.jsp");
            } else {
                response.getWriter().println("Failed to add book.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
