package com.enterpriseops.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.dao.impl.EmployeeDAOImpl;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;

@WebServlet("/profile")
public class EmployeeProfileServlet extends HttpServlet {


private static final long serialVersionUID = 1L;

private EmployeeDAO employeeDAO;

@Override
public void init() throws ServletException {
    employeeDAO = new EmployeeDAOImpl();
}

@Override
protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    // Check that the user is logged in.
    if (session == null) {
        response.sendRedirect(
                request.getContextPath() + "/login");
        return;
    }

    Object loggedInUser =
            session.getAttribute("loggedInUser");

    if (!(loggedInUser instanceof User)) {
        response.sendRedirect(
                request.getContextPath() + "/login");
        return;
    }

    User user = (User) loggedInUser;

    // Only employees can use this employee profile page.
    if (user.getRole() == null
            || user.getRole().getName() == null
            || !"EMPLOYEE".equalsIgnoreCase(
                    user.getRole().getName())) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Access denied");
        return;
    }

    // Require a password change when applicable.
    if (user.isMustChangePassword()) {
        response.sendRedirect(
                request.getContextPath()
                        + "/change-password");
        return;
    }

    Employee linkedEmployee = user.getEmployee();

    if (linkedEmployee == null
            || linkedEmployee.getId() == null) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "No employee profile is linked to this account");
        return;
    }

    try {
        // Load only the employee linked to the logged-in user.
        Employee employee =
                employeeDAO.findById(linkedEmployee.getId());

        if (employee == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Employee profile not found");
            return;
        }

        request.setAttribute("employee", employee);
        request.setAttribute(
                "username", user.getUsername());

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/profile.jsp")
                .forward(request, response);

    } catch (Exception e) {
        getServletContext().log(
                "Unable to load employee profile.", e);

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load your profile");
    }
}

}
