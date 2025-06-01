package com.library.controller;

import java.io.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/borrow")
public class BorrowServlet extends HttpServlet {
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

            // DEBUG: Print IDs
            System.out.println("Borrow attempt -> User ID: " + userId + ", Book ID: " + bookId);

            // Check if book already borrowed by user
            PreparedStatement check = conn.prepareStatement(
                "SELECT * FROM borrowed_books WHERE user_id=? AND book_id=?");
            check.setInt(1, userId);
            check.setInt(2, bookId);
            ResultSet rs = check.executeQuery();

            if (!rs.next()) {
                // Insert new borrow record
                PreparedStatement insert = conn.prepareStatement(
                    "INSERT INTO borrowed_books (user_id, book_id, borrow_date) VALUES (?, ?, NOW())");
                insert.setInt(1, userId);
                insert.setInt(2, bookId);
                int rowsInserted = insert.executeUpdate();

                System.out.println("Inserted into borrowed_books: " + rowsInserted);

                // Mark book as unavailable
                PreparedStatement update = conn.prepareStatement(
                    "UPDATE books SET availability = FALSE WHERE id = ?");
                update.setInt(1, bookId);
                update.executeUpdate();
            } else {
                System.out.println("Book already borrowed by user.");
            }

            conn.close();
            response.sendRedirect("user-dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("Error: " + e.getMessage());
        }
    }
}
