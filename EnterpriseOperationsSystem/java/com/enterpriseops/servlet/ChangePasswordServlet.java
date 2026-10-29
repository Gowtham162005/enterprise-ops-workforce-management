
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

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

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

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("loggedInUser") instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/change-password.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null
                || !(session.getAttribute("loggedInUser") instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User sessionUser = (User) session.getAttribute("loggedInUser");

        String newUsername = request.getParameter("newUsername");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (newUsername == null || newUsername.trim().isEmpty()
                || currentPassword == null || currentPassword.isEmpty()
                || newPassword == null || newPassword.isEmpty()
                || confirmPassword == null || confirmPassword.isEmpty()) {

            request.setAttribute("error", "Please fill in all fields.");
            showPage(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "The new passwords do not match.");
            showPage(request, response);
            return;
        }

        if (newPassword.length() < 8) {
            request.setAttribute(
                    "error",
                    "Your new password must be at least 8 characters long.");
            showPage(request, response);
            return;
        }

        if (newPassword.equals(currentPassword)) {
            request.setAttribute(
                    "error",
                    "Your new password must differ from your current password.");
            showPage(request, response);
            return;
        }

        try {
            // Validate and save both changes to the existing user account.
            userService.changeOwnCredentials(
                    sessionUser.getId(),
                    newUsername,
                    currentPassword,
                    newPassword);

            // Reload the user so the session contains the updated username.
            User updatedUser =
                    userService.getUserById(sessionUser.getId());

            if (updatedUser == null) {
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            session.setAttribute("loggedInUser", updatedUser);
            session.setAttribute("userId", updatedUser.getId());
            session.setAttribute("username", updatedUser.getUsername());

            String role = updatedUser.getRole() != null
                    ? updatedUser.getRole().getName()
                    : null;

            session.setAttribute("role", role);

            if (updatedUser.getEmployee() != null) {
                session.setAttribute(
                        "employeeId",
                        updatedUser.getEmployee().getId());
            }

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
                session.invalidate();
                response.sendRedirect(request.getContextPath() + "/login");
            }

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            showPage(request, response);

        } catch (Exception e) {
            getServletContext().log("Account credential update failed", e);
            request.setAttribute(
                    "error",
                    "Unable to update your account. Please try again.");
            showPage(request, response);
        }
    }

    private void showPage(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/change-password.jsp")
                .forward(request, response);
    }
}
