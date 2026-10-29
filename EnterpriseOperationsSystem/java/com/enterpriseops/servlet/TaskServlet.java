package com.enterpriseops.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Project;
import com.enterpriseops.model.Task;
import com.enterpriseops.service.EmployeeService;
import com.enterpriseops.service.ProjectService;
import com.enterpriseops.service.TaskService;

@WebServlet("/tasks")
public class TaskServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private TaskService taskService;
    private ProjectService projectService;
    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {

        taskService = new TaskService();
        projectService = new ProjectService();
        employeeService = new EmployeeService();
    }

    // =========================================================
    // GET
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || "list".equals(action)) {

            listTasks(request, response);

        } else if ("add".equals(action)) {

            showAddForm(request, response);

        } else if ("edit".equals(action)) {

            showEditForm(request, response);

        } else if ("delete".equals(action)) {

            deleteTask(request, response);

        } else {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action"
            );
        }
    }

    // =========================================================
    // POST
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            addTask(request, response);

        } else if ("update".equals(action)) {

            updateTask(request, response);

        } else {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action"
            );
        }
    }

    // =========================================================
    // LIST TASKS
    // =========================================================

    private void listTasks(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Task> tasks =
                taskService.getAllTasks();

        request.setAttribute(
                "tasks",
                tasks
        );

        request.getRequestDispatcher(
                "/WEB-INF/views/task/list.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // SHOW ADD FORM
    // =========================================================

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        loadFormData(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/task/add.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // ADD TASK
    // =========================================================

    private void addTask(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            Task task =
                    buildTaskFromRequest(request);

            taskService.addTask(task);

            response.sendRedirect(
                    request.getContextPath()
                    + "/tasks"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Error adding task: "
                    + e.getMessage()
            );
        }
    }

    // =========================================================
    // SHOW EDIT FORM
    // =========================================================

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            Task task =
                    taskService.getTask(id);

            if (task == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Task not found"
                );

                return;
            }

            loadFormData(request);

            request.setAttribute(
                    "task",
                    task
            );

            request.getRequestDispatcher(
                    "/WEB-INF/views/task/edit.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid task ID"
            );
        }
    }

    // =========================================================
    // UPDATE TASK
    // =========================================================

    private void updateTask(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            Task task =
                    buildTaskFromRequest(request);

            task.setId(id);

            taskService.updateTask(task);

            response.sendRedirect(
                    request.getContextPath()
                    + "/tasks"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Error updating task: "
                    + e.getMessage()
            );
        }
    }

    // =========================================================
    // DELETE TASK
    // =========================================================

    private void deleteTask(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int id = Integer.parseInt(
                    request.getParameter("id")
            );

            taskService.deleteTask(id);

            response.sendRedirect(
                    request.getContextPath()
                    + "/tasks"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Error deleting task: "
                    + e.getMessage()
            );
        }
    }

    // =========================================================
    // LOAD PROJECTS + EMPLOYEES FOR FORM
    // =========================================================

    private void loadFormData(
            HttpServletRequest request) {

        List<Project> projects =
                projectService.getAllProjects();

        List<Employee> employees =
                employeeService.getAllEmployees();

        request.setAttribute(
                "projects",
                projects
        );

        request.setAttribute(
                "employees",
                employees
        );
    }

    // =========================================================
    // BUILD TASK FROM REQUEST
    // =========================================================

    private Task buildTaskFromRequest(
            HttpServletRequest request) {

        String taskCode =
                request.getParameter("taskCode");

        String title =
                request.getParameter("title");

        String description =
                request.getParameter("description");

        String projectIdValue =
                request.getParameter("projectId");

        String employeeIdValue =
                request.getParameter("assignedEmployeeId");

        String priority =
                request.getParameter("priority");

        String status =
                request.getParameter("status");

        String startDateValue =
                request.getParameter("startDate");

        String dueDateValue =
                request.getParameter("dueDate");

        String progressValue =
                request.getParameter("progress");

        // -----------------------------------------------------
        // Project
        // -----------------------------------------------------

        Project project = null;

        if (projectIdValue != null
                && !projectIdValue.trim().isEmpty()) {

            int projectId =
                    Integer.parseInt(projectIdValue);

            project = new Project();

            project.setId(projectId);
        }

        // -----------------------------------------------------
        // Assigned Employee
        // -----------------------------------------------------

        Employee employee = null;

        if (employeeIdValue != null
                && !employeeIdValue.trim().isEmpty()) {

            int employeeId =
                    Integer.parseInt(employeeIdValue);

            employee = new Employee();

            employee.setId(employeeId);
        }

        // -----------------------------------------------------
        // Dates
        // -----------------------------------------------------

        LocalDate startDate = null;
        LocalDate dueDate = null;

        if (startDateValue != null
                && !startDateValue.trim().isEmpty()) {

            startDate =
                    LocalDate.parse(startDateValue);
        }

        if (dueDateValue != null
                && !dueDateValue.trim().isEmpty()) {

            dueDate =
                    LocalDate.parse(dueDateValue);
        }

        // -----------------------------------------------------
        // Progress
        // -----------------------------------------------------

        Integer progress = 0;

        if (progressValue != null
                && !progressValue.trim().isEmpty()) {

            progress =
                    Integer.parseInt(progressValue);
        }

        // -----------------------------------------------------
        // Create Task
        // -----------------------------------------------------

        Task task = new Task();

        task.setTaskCode(taskCode);
        task.setTitle(title);
        task.setDescription(description);
        task.setProject(project);
        task.setAssignedEmployee(employee);
        task.setPriority(priority);
        task.setStatus(status);
        task.setStartDate(startDate);
        task.setDueDate(dueDate);
        task.setProgress(progress);

        return task;
    }
}