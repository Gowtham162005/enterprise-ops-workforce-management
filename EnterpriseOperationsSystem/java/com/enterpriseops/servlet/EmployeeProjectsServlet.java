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
import com.enterpriseops.model.Project;
import com.enterpriseops.model.User;
import com.enterpriseops.service.ProjectService;

@WebServlet("/employee/projects")
public class EmployeeProjectsServlet extends HttpServlet {


private static final long serialVersionUID = 1L;

private ProjectService projectService;

@Override
public void init() throws ServletException {
    projectService = new ProjectService();
}

@Override
protected void doGet(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    if (session == null) {
        response.sendRedirect(
                request.getContextPath() + "/login");
        return;
    }

    Object loggedInObject = session.getAttribute("loggedInUser");

    if (!(loggedInObject instanceof User)) {
        response.sendRedirect(
                request.getContextPath() + "/login");
        return;
    }

    User user = (User) loggedInObject;

    if (user.getRole() == null
            || user.getRole().getName() == null
            || !"EMPLOYEE".equalsIgnoreCase(
                    user.getRole().getName())) {

        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Access denied");
        return;
    }

    if (user.isMustChangePassword()) {
        response.sendRedirect(
                request.getContextPath() + "/change-password");
        return;
    }

    Employee employee = user.getEmployee();

    if (employee == null || employee.getId() == null) {
        response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "No employee profile is linked to this account");
        return;
    }

    try {
        List<Project> projects =
                projectService.getProjectsByEmployee(
                        employee.getId());

        request.setAttribute("projects", projects);
        request.setAttribute("username", user.getUsername());
        request.setAttribute("employee", employee);

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/projects.jsp")
                .forward(request, response);

    } catch (Exception e) {
        throw new ServletException(
                "Unable to load employee projects", e);
    }
}

@Override
protected void doPost(
        HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    response.sendError(
            HttpServletResponse.SC_METHOD_NOT_ALLOWED);
}


}
