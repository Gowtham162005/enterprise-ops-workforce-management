package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;
import com.enterpriseops.service.EmployeeService;

@WebServlet("/manager/team")
public class ManagerTeamServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        employeeService = new EmployeeService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Login check
        if (session == null ||
            session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // 2. Get logged-in user
        User user = (User) session.getAttribute("loggedInUser");

        // 3. Manager-only access
        if (user.getRole() == null ||
            !"MANAGER".equalsIgnoreCase(user.getRole().getName())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager access required"
            );
            return;
        }

        // 4. Manager must be linked to an employee
        if (user.getEmployee() == null ||
            user.getEmployee().getId() == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager employee profile is not configured"
            );
            return;
        }

        // Logged-in manager's employee ID
        Integer managerEmployeeId = user.getEmployee().getId();

        // 5. Load ONLY employees assigned to this manager
        List<Employee> employees =
                employeeService.getEmployeesByManager(managerEmployeeId);

        // 6. Send data to JSP
        request.setAttribute("employees", employees);
        request.setAttribute("managerEmployeeId", managerEmployeeId);
        request.setAttribute("username", user.getUsername());
        request.setAttribute("role", user.getRole().getName());

        // 7. Open manager team page
        request.getRequestDispatcher(
                "/WEB-INF/views/manager/my-team.jsp"
        ).forward(request, response);
    }
}