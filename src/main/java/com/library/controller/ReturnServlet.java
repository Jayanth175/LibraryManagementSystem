package com.library.controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/return")
public class ReturnServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        int bookId = Integer.parseInt(request.getParameter("book_id"));
        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("user_id");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/library_db", "root", "Jayanth@7259");

            // Delete from borrowed_books
            PreparedStatement delete = conn.prepareStatement(
                "DELETE FROM borrowed_books WHERE user_id=? AND book_id=?");
            delete.setInt(1, userId);
            delete.setInt(2, bookId);
            delete.executeUpdate();

            // Update availability
            PreparedStatement update = conn.prepareStatement(
                "UPDATE books SET availability = TRUE WHERE id=?");
            update.setInt(1, bookId);
            update.executeUpdate();

            conn.close();
            response.sendRedirect("user-dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Error: " + e.getMessage());
        }
    }
}
