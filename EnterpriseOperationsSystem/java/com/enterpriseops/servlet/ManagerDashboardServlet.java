package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.dto.ManagerDashboardDTO;
import com.enterpriseops.model.Task;
import com.enterpriseops.model.User;
import com.enterpriseops.service.ManagerDashboardService;
import com.enterpriseops.service.TaskService;

@WebServlet("/manager/dashboard")
public class ManagerDashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ManagerDashboardService managerDashboardService;
    private TaskService taskService;

    @Override
    public void init() throws ServletException {
        managerDashboardService = new ManagerDashboardService();
        taskService = new TaskService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        User user =
                (User) session.getAttribute("loggedInUser");

        if (user.getRole() == null ||
            !"MANAGER".equalsIgnoreCase(
                    user.getRole().getName())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager access required");

            return;
        }

        if (user.getEmployee() == null ||
            user.getEmployee().getId() == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager employee profile is not configured");

            return;
        }

        Integer managerEmployeeId =
                user.getEmployee().getId();

        // Load manager's tasks
        List<Task> managerTasks =
                taskService.getTasksByManager(
                        managerEmployeeId);

        request.setAttribute(
                "managerTasks",
                managerTasks);

        // Load dashboard data
        ManagerDashboardDTO dashboard =
                managerDashboardService
                        .getDashboardData(managerEmployeeId);

        request.setAttribute(
                "dashboard",
                dashboard);

        request.setAttribute(
                "username",
                user.getUsername());

        request.setAttribute(
                "role",
                user.getRole().getName());

        request.getRequestDispatcher(
                "/WEB-INF/views/manager/dashboard.jsp")
                .forward(request, response);
    }
}