package com.library.controller;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    private final String ADMIN_EMAIL = "admin123@gmail.com";
    private final String ADMIN_PASS = "Admin@7259";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email.equals(ADMIN_EMAIL) && password.equals(ADMIN_PASS)) {
            HttpSession session = request.getSession();
            session.setAttribute("admin", email);
            response.sendRedirect("admin-dashboard.jsp");
        } else {
            response.getWriter().println("Invalid admin credentials.");
        }
    }
}
