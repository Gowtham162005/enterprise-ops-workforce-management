
package com.enterpriseops.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.dao.ProjectDAO;
import com.enterpriseops.dao.impl.EmployeeDAOImpl;
import com.enterpriseops.dao.impl.ProjectDAOImpl;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Project;
import com.enterpriseops.model.Task;
import com.enterpriseops.model.User;
import com.enterpriseops.service.TaskService;

@WebServlet("/manager/tasks")
public class ManagerTaskServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskService taskService;
    private EmployeeDAO employeeDAO;
    private ProjectDAO projectDAO;

    @Override
    public void init() throws ServletException {
        taskService = new TaskService();
        employeeDAO = new EmployeeDAOImpl();
        projectDAO = new ProjectDAOImpl();
    }

    // =========================================================
    // GET: LOAD MANAGER DASHBOARD DATA
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getAuthorizedManager(request, response);

        if (user == null) {
            return;
        }

        Integer managerId = user.getEmployee().getId();

        try {
            // Reload the manager employee and department from the DAO.
            Employee manager = employeeDAO.findById(managerId);

            if (manager == null ||
                manager.getDepartment() == null ||
                manager.getDepartment().getId() == null) {

                response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager department is not configured"
                );
                return;
            }

            Integer departmentId =
                    manager.getDepartment().getId();

            // Only projects assigned to this manager.
            List<Project> projects =
                    projectDAO.findByManager(managerId);

            // Employees in the same department as the manager.
            List<Employee> employees =
                    employeeDAO.findByDepartment(departmentId);

            // Tasks belonging to this manager's projects.
            List<Task> tasks = taskService.getTasksByManager(managerId)
            	    .stream()
            	    .filter(task -> !"PRRC06".equalsIgnoreCase(task.getTaskCode()))
            	    .collect(java.util.stream.Collectors.toList());
            request.setAttribute("tasks", tasks);
            request.setAttribute("projects", projects);
            request.setAttribute("employees", employees);

            request.setAttribute(
                    "managerEmployeeId", managerId);

            request.setAttribute(
                    "username", user.getUsername());

            request.setAttribute(
                    "role", user.getRole().getName());

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager/tasks.jsp")
                    .forward(request, response);

        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to load manager task dashboard", e);
        }
    }

    // =========================================================
    // POST: CREATE OR UPDATE TASK
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getAuthorizedManager(request, response);

        if (user == null) {
            return;
        }

        request.setCharacterEncoding("UTF-8");

        Integer managerId = user.getEmployee().getId();
        String action = request.getParameter("action");

        try {
            if ("create".equalsIgnoreCase(action)) {

                Task task = buildTaskFromRequest(request);

                taskService.addTaskForManager(
                        task, managerId);

                response.sendRedirect(
                    request.getContextPath()
                    + "/manager/tasks?success=created");

            } else if ("update".equalsIgnoreCase(action)) {

                Task task = buildTaskFromRequest(request);

                task.setId(parseRequiredInteger(
                        request.getParameter("id"),
                        "Task ID"));

                taskService.updateTaskForManager(
                        task, managerId);

                response.sendRedirect(
                    request.getContextPath()
                    + "/manager/tasks?success=updated");

            } else {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid task action"
                );
            }

        } catch (IllegalArgumentException e) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                e.getMessage()
            );

        } catch (SecurityException e) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                e.getMessage()
            );

        } catch (RuntimeException e) {
            throw new ServletException(
                    "Unable to process manager task request", e);
        }
    }

    // =========================================================
    // AUTHENTICATION AND ROLE CHECK
    // =========================================================

    private User getAuthorizedManager(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");
            return null;
        }

        Object loggedInUser =
                session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Invalid user session"
            );
            return null;
        }

        User user = (User) loggedInUser;

        if (user.getRole() == null ||
            user.getRole().getName() == null ||
            !"MANAGER".equalsIgnoreCase(
                    user.getRole().getName())) {

            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Manager access required"
            );
            return null;
        }

        if (user.getEmployee() == null ||
            user.getEmployee().getId() == null ||
            user.getEmployee().getId() <= 0) {

            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "Manager employee profile is not configured"
            );
            return null;
        }

        return user;
    }

    // =========================================================
    // BUILD TASK FROM FORM
    // =========================================================

    private Task buildTaskFromRequest(
            HttpServletRequest request) {

        Task task = new Task();

        task.setTaskCode(
                requiredParameter(request, "taskCode"));

        task.setTitle(
                requiredParameter(request, "title"));

        task.setDescription(
                request.getParameter("description"));

        task.setPriority(
                defaultIfBlank(
                        request.getParameter("priority"),
                        "MEDIUM"));

        task.setStatus(
                defaultIfBlank(
                        request.getParameter("status"),
                        "TODO"));

        String progress = request.getParameter("progress");

        if (progress == null || progress.trim().isEmpty()) {
            task.setProgress(0);
        } else {
            task.setProgress(
                    parseRequiredInteger(progress, "Progress"));
        }

        Project project = new Project();
        project.setId(parseRequiredInteger(
                requiredParameter(request, "projectId"),
                "Project ID"));
        task.setProject(project);

        Employee employee = new Employee();
        employee.setId(parseRequiredInteger(
                requiredParameter(request, "assignedEmployeeId"),
                "Employee ID"));
        task.setAssignedEmployee(employee);

        String startDate = request.getParameter("startDate");

        if (startDate != null && !startDate.trim().isEmpty()) {
            task.setStartDate(parseDate(startDate, "Start date"));
        }

        String dueDate = request.getParameter("dueDate");

        if (dueDate != null && !dueDate.trim().isEmpty()) {
            task.setDueDate(parseDate(dueDate, "Due date"));
        }

        return task;
    }

    // =========================================================
    // FORM VALIDATION HELPERS
    // =========================================================

    private String requiredParameter(
            HttpServletRequest request,
            String name) {

        String value = request.getParameter(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    name + " is required");
        }

        return value.trim();
    }

    private Integer parseRequiredInteger(
            String value,
            String fieldName) {

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    fieldName + " is required");
        }

        try {
            return Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid " + fieldName);
        }
    }

    private LocalDate parseDate(
            String value,
            String fieldName) {

        try {
            return LocalDate.parse(value.trim());
        } catch (DateTimeParseException e) {
            throw new IllegalArgumentException(
                    "Invalid " + fieldName
                    + ". Use yyyy-MM-dd format.");
        }
    }

    private String defaultIfBlank(
            String value,
            String defaultValue) {

        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        return value.trim();
    }
}
