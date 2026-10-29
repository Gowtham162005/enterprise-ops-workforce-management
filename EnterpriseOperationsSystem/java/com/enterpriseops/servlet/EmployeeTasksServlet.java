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
import com.enterpriseops.model.Task;
import com.enterpriseops.model.User;
import com.enterpriseops.service.TaskService;

@WebServlet("/employee/tasks")
public class EmployeeTasksServlet extends HttpServlet {


private static final long serialVersionUID = 1L;

private TaskService taskService;

@Override
public void init() throws ServletException {
    taskService = new TaskService();
}

@Override
protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    // The employee must already be logged in.
    if (session == null ||
            session.getAttribute("loggedInUser") == null) {

        response.sendRedirect(
                request.getContextPath() + "/login");
        return;
    }

    Object loggedInObject =
            session.getAttribute("loggedInUser");

    if (!(loggedInObject instanceof User)) {
        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Invalid login session.");
        return;
    }

    User loggedInUser = (User) loggedInObject;
    Employee employee = loggedInUser.getEmployee();

    // The logged-in account must be linked to an employee.
    if (employee == null ||
            employee.getId() == null ||
            employee.getId() <= 0) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "No employee profile is linked to this account.");
        return;
    }

    try {
        // Retrieve only tasks assigned to this employee.
        List<Task> tasks =
                taskService.getTasksByEmployee(employee.getId());

        request.setAttribute("tasks", tasks);
        request.setAttribute("employee", employee);

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/tasks.jsp")
                .forward(request, response);

    } catch (Exception e) {
        getServletContext().log(
                "Unable to load employee tasks.", e);

        response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load your tasks right now.");
    }
}

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    // Employees cannot create, delete, or reassign tasks
    // through this employee-only endpoint.
    response.sendError(
            HttpServletResponse.SC_METHOD_NOT_ALLOWED,
            "Task changes are not available on this page.");
}


}
