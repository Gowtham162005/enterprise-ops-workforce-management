
package com.enterpriseops.servlet;

import java.io.IOException;

import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.dao.impl.EmployeeDAOImpl;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;

@WebServlet("/employee/dashboard")
public class EmployeeDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Object loggedInUser = session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) loggedInUser;

        if (user.getRole() == null
                || !"EMPLOYEE".equalsIgnoreCase(
                        user.getRole().getName())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied");
            return;
        }

        // Require employees to change their temporary password first.
        if (user.isMustChangePassword()) {
            response.sendRedirect(
                    request.getContextPath() + "/change-password");
            return;
        }

        Employee linkedEmployee = user.getEmployee();

        if (linkedEmployee == null || linkedEmployee.getId() == null) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No employee profile is linked to this account");
            return;
        }

        EmployeeDAO employeeDAO = new EmployeeDAOImpl();

        Employee employee = employeeDAO.findById(linkedEmployee.getId());

        if (employee == null) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Employee profile not found");
            return;
        }

        request.setAttribute("username", user.getUsername());
        request.setAttribute("employee", employee);
        request.setAttribute("employeeId", employee.getId());
        request.setAttribute("role", "EMPLOYEE");

        request.getRequestDispatcher(
        	    "/WEB-INF/views/employee/dashboard.jsp"
        	).forward(request, response);
    }
}
