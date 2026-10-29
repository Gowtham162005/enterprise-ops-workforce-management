
package com.enterpriseops.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.User;
import com.enterpriseops.service.UserService;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession existingSession = request.getSession(false);

        if (existingSession != null
                && existingSession.getAttribute("loggedInUser") != null) {

            User user = (User) existingSession.getAttribute("loggedInUser");

            if (user.isMustChangePassword()) {
                response.sendRedirect(
                        request.getContextPath() + "/change-password");
                return;
            }

            redirectByRole(
                    request,
                    response,
                    user.getRole() != null
                            ? user.getRole().getName()
                            : null);
            return;
        }

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userService.authenticate(username, password);

        if (user == null) {
            request.setAttribute(
                    "error",
                    "Invalid username or password.");

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
            return;
        }

        // Prevent session fixation by creating a fresh session.
        HttpSession oldSession = request.getSession(false);
        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);

        session.setAttribute("loggedInUser", user);
        session.setAttribute("userId", user.getId());
        session.setAttribute("username", user.getUsername());

        String role = null;
        if (user.getRole() != null) {
            role = user.getRole().getName();
        }

        session.setAttribute("role", role);

        if (user.getEmployee() != null) {
            session.setAttribute(
                    "employeeId",
                    user.getEmployee().getId());
        }

        // Temporary-password accounts must change their password first.
        if (user.isMustChangePassword()) {
            response.sendRedirect(
                    request.getContextPath() + "/change-password");
            return;
        }

        redirectByRole(request, response, role);
    }

    private void redirectByRole(
            HttpServletRequest request,
            HttpServletResponse response,
            String role)
            throws IOException, ServletException {

        if ("ADMIN".equalsIgnoreCase(role)) {
            response.sendRedirect(
                    request.getContextPath() + "/dashboard");

        } else if ("MANAGER".equalsIgnoreCase(role)) {
            response.sendRedirect(
                    request.getContextPath() + "/manager/dashboard");

        } else if ("EMPLOYEE".equalsIgnoreCase(role)) {
            response.sendRedirect(
                    request.getContextPath() + "/employee/dashboard");

        } else {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }

            request.setAttribute(
                    "error",
                    "Your account has an invalid role.");

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);
        }
    }
}
