package com.enterpriseops.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Project;
import com.enterpriseops.service.DepartmentService;
import com.enterpriseops.service.EmployeeService;
import com.enterpriseops.service.ProjectService;

@WebServlet("/projects")
public class ProjectServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private ProjectService projectService;
    private EmployeeService employeeService;
    private DepartmentService departmentService;

    @Override
    public void init() throws ServletException {
        projectService = new ProjectService();
        employeeService = new EmployeeService();
        departmentService = new DepartmentService();
    }

    // ---------------------------------------------------------
    // GET
    // ---------------------------------------------------------

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || "list".equals(action)) {
            listProjects(request, response);

        } else if ("add".equals(action)) {
            if (requireAdmin(request, response)) {
                showAddForm(request, response);
            }

        } else if ("edit".equals(action)) {
            if (requireAdmin(request, response)) {
                showEditForm(request, response);
            }

        } else if ("members".equals(action)) {
            showMembers(request, response);

        } else if ("delete".equals(action)
                || "removeMember".equals(action)) {
            response.sendError(
                    HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                    "Use POST for this operation.");

        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
        }
    }

    // ---------------------------------------------------------
    // POST
    // ---------------------------------------------------------

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            if (requireAdmin(request, response)) {
                addProject(request, response);
            }

        } else if ("update".equals(action)) {
            if (requireAdmin(request, response)) {
                updateProject(request, response);
            }

        } else if ("delete".equals(action)) {
            if (requireAdmin(request, response)) {
                deleteProject(request, response);
            }

        } else if ("addMember".equals(action)) {
            addMember(request, response);

        } else if ("removeMember".equals(action)) {
            removeMember(request, response);

        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
        }
    }

    // ---------------------------------------------------------
    // PROJECT LIST
    // ---------------------------------------------------------

    private void listProjects(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Project> projects;

            if (isAdmin(request)) {
                projects = projectService.getAllProjects();

            } else if ("MANAGER".equals(getUserRole(request))) {
                Integer employeeId = getLoggedInEmployeeId(request);

                if (employeeId == null) {
                    response.sendError(
                            HttpServletResponse.SC_UNAUTHORIZED,
                            "Please sign in again.");
                    return;
                }

                projects =
                        projectService.getProjectsByManager(employeeId);

            } else {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You are not allowed to view projects.");
                return;
            }

            request.setAttribute("projects", projects);

            request.getRequestDispatcher(
                    "/WEB-INF/views/project/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            log("Unable to load projects.", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load projects.");
        }
    }

    // ---------------------------------------------------------
    // ADD PROJECT
    // ---------------------------------------------------------

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            loadDepartmentFormData(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/project/add.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            log("Unable to load the project add form.", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load the project form.");
        }
    }

    private void addProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            Project project = buildProjectFromRequest(request);
            validateProject(project);

            validateManagerDepartment(project);

            projectService.addProject(project);

            response.sendRedirect(
                    request.getContextPath() + "/projects");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            log("Unable to add project.", e);
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to add project. Check the submitted values.");
        }
    }

    // ---------------------------------------------------------
    // EDIT / UPDATE PROJECT
    // ---------------------------------------------------------

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer id = parsePositiveId(request.getParameter("id"));

        if (id == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID.");
            return;
        }

        try {
            Project project = projectService.getProject(id);

            if (project == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            request.setAttribute("project", project);
            loadDepartmentFormData(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/project/edit.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            log("Unable to load project for editing.", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load project.");
        }
    }

    private void updateProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Integer id = parsePositiveId(request.getParameter("id"));

        if (id == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID.");
            return;
        }

        try {
            Project existing = projectService.getProject(id);

            if (existing == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            Project updated = buildProjectFromRequest(request);
            updated.setId(id);

            validateProject(updated);
            validateManagerDepartment(updated);

            /*
             * ProjectService/ProjectDAOImpl must update the existing
             * database row without clearing its existing members.
             */
            projectService.updateProject(updated);

            response.sendRedirect(
                    request.getContextPath() + "/projects");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            log("Unable to update project " + id, e);
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to update project. Check the submitted values.");
        }
    }

    // ---------------------------------------------------------
    // DELETE PROJECT
    // ---------------------------------------------------------

    private void deleteProject(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Integer id = parsePositiveId(request.getParameter("id"));

        if (id == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID.");
            return;
        }

        try {
            Project project = projectService.getProject(id);

            if (project == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            projectService.deleteProject(id);

            response.sendRedirect(
                    request.getContextPath() + "/projects");

        } catch (Exception e) {
            log("Unable to delete project " + id, e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to delete project. Check the server log.");
        }
    }

    // ---------------------------------------------------------
    // PROJECT MEMBERS
    // ---------------------------------------------------------

    private void showMembers(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Integer projectId =
                parsePositiveId(request.getParameter("id"));

        if (projectId == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid project ID.");
            return;
        }

        try {
            Project project = projectService.getProject(projectId);

            if (project == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            if (!canManageProject(request, project)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot manage this project's members.");
                return;
            }

            request.setAttribute("project", project);
            request.setAttribute(
                    "employees",
                    employeeService.getAllEmployees());

            request.getRequestDispatcher(
                    "/WEB-INF/views/project/members.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            log("Unable to load project members.", e);
            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load project members.");
        }
    }

    private void addMember(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Integer projectId =
                parsePositiveId(request.getParameter("projectId"));
        Integer employeeId =
                parsePositiveId(request.getParameter("employeeId"));

        if (projectId == null || employeeId == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid project and employee are required.");
            return;
        }

        try {
            Project project = projectService.getProject(projectId);

            if (project == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            if (!canManageProject(request, project)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot manage this project's members.");
                return;
            }

            projectService.addMember(projectId, employeeId);

            response.sendRedirect(
                    request.getContextPath()
                            + "/projects?action=members&id=" + projectId);

        } catch (Exception e) {
            log("Unable to add employee to project " + projectId, e);
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to add employee to project.");
        }
    }

    private void removeMember(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        Integer projectId =
                parsePositiveId(request.getParameter("projectId"));
        Integer employeeId =
                parsePositiveId(request.getParameter("employeeId"));

        if (projectId == null || employeeId == null) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "A valid project and employee are required.");
            return;
        }

        try {
            Project project = projectService.getProject(projectId);

            if (project == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Project not found.");
                return;
            }

            if (!canManageProject(request, project)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "You cannot manage this project's members.");
                return;
            }

            projectService.removeMember(projectId, employeeId);

            response.sendRedirect(
                    request.getContextPath()
                            + "/projects?action=members&id=" + projectId);

        } catch (Exception e) {
            log("Unable to remove employee from project " + projectId, e);
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to remove employee from project.");
        }
    }

    // ---------------------------------------------------------
    // DEPARTMENT FORM DATA
    // ---------------------------------------------------------

    private void loadDepartmentFormData(HttpServletRequest request) {
        List<Department> departments =
                departmentService.getDepartmentsWithEmployees();

        request.setAttribute("departments", departments);
    }

    /**
     * Validates the submitted department and ensures that the selected
     * manager is an employee of that department.
     */
    private void validateManagerDepartment(Project project) {
        if (project.getDepartment() == null
                || project.getDepartment().getId() == null) {
            throw new IllegalArgumentException(
                    "Please select a department.");
        }

        Integer departmentId = project.getDepartment().getId();

        List<Department> departments =
                departmentService.getDepartmentsWithEmployees();

        Department selectedDepartment = null;

        for (Department department : departments) {
            if (department.getId() != null
                    && department.getId().equals(departmentId)) {
                selectedDepartment = department;
                break;
            }
        }

        if (selectedDepartment == null) {
            throw new IllegalArgumentException(
                    "The selected department does not exist.");
        }

        if (project.getManager() != null
                && project.getManager().getId() != null) {

            Integer managerId = project.getManager().getId();
            boolean managerBelongsToDepartment = false;

            if (selectedDepartment.getEmployees() != null) {
                for (Employee employee : selectedDepartment.getEmployees()) {
                    if (employee.getId() != null
                            && employee.getId().equals(managerId)) {
                        managerBelongsToDepartment = true;
                        break;
                    }
                }
            }

            if (!managerBelongsToDepartment) {
                throw new IllegalArgumentException(
                        "The selected project manager must belong "
                                + "to the selected department.");
            }
        }

        // Replace the submitted ID-only object with the loaded department.
        project.setDepartment(selectedDepartment);
    }

    // ---------------------------------------------------------
    // REQUEST -> PROJECT
    // ---------------------------------------------------------

    private Project buildProjectFromRequest(
            HttpServletRequest request) {

        String projectCode = trim(request.getParameter("projectCode"));
        String name = trim(request.getParameter("name"));
        String description = trim(request.getParameter("description"));
        String status = trim(request.getParameter("status"));

        String startDateValue = trim(request.getParameter("startDate"));
        String endDateValue = trim(request.getParameter("endDate"));
        String departmentIdValue =
                trim(request.getParameter("departmentId"));
        String managerIdValue = trim(request.getParameter("managerId"));

        LocalDate startDate = parseDate(startDateValue, "start date");
        LocalDate endDate = parseDate(endDateValue, "end date");

        Integer departmentId = parsePositiveId(departmentIdValue);

        if (departmentId == null) {
            throw new IllegalArgumentException(
                    "Please select a valid department.");
        }

        Department department = new Department();
        department.setId(departmentId);

        Employee manager = null;

        if (managerIdValue != null && !managerIdValue.isEmpty()) {
            Integer managerId = parsePositiveId(managerIdValue);

            if (managerId == null) {
                throw new IllegalArgumentException(
                        "Invalid project manager.");
            }

            manager = new Employee();
            manager.setId(managerId);
        }

        Project project = new Project();
        project.setProjectCode(projectCode);
        project.setName(name);
        project.setDescription(description);
        project.setStartDate(startDate);
        project.setEndDate(endDate);
        project.setStatus(status);
        project.setDepartment(department);
        project.setManager(manager);

        return project;
    }

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------

    private void validateProject(Project project) {

        if (project.getProjectCode() == null
                || project.getProjectCode().trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Project code is required.");
        }

        if (project.getName() == null
                || project.getName().trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Project name is required.");
        }

        if (project.getProjectCode().length() > 30) {
            throw new IllegalArgumentException(
                    "Project code must be 30 characters or fewer.");
        }

        if (project.getName().length() > 150) {
            throw new IllegalArgumentException(
                    "Project name must be 150 characters or fewer.");
        }

        if (project.getDescription() != null
                && project.getDescription().length() > 500) {
            throw new IllegalArgumentException(
                    "Description must be 500 characters or fewer.");
        }

        if (project.getStartDate() != null
                && project.getEndDate() != null
                && project.getEndDate().isBefore(project.getStartDate())) {
            throw new IllegalArgumentException(
                    "End date cannot be before start date.");
        }

        if (project.getStatus() == null
                || project.getStatus().trim().isEmpty()) {
            project.setStatus("PLANNED");
        } else {
            project.setStatus(project.getStatus().trim());
        }

        if (project.getStatus().length() > 30) {
            throw new IllegalArgumentException(
                    "Status must be 30 characters or fewer.");
        }

        project.setProjectCode(project.getProjectCode().trim());
        project.setName(project.getName().trim());

        if (project.getDescription() != null) {
            project.setDescription(project.getDescription().trim());
        }
    }

    private LocalDate parseDate(String value, String fieldName) {
        if (value == null || value.isEmpty()) {
            return null;
        }

        try {
            return LocalDate.parse(value);
        } catch (Exception e) {
            throw new IllegalArgumentException(
                    "Invalid " + fieldName + ". Use YYYY-MM-DD.");
        }
    }

    private String trim(String value) {
        return value == null ? null : value.trim();
    }

    private Integer parsePositiveId(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }

        try {
            int id = Integer.parseInt(value.trim());
            return id > 0 ? id : null;
        } catch (NumberFormatException e) {
            return null;
        }
    }

    // ---------------------------------------------------------
    // SESSION / AUTHORIZATION
    // ---------------------------------------------------------

    private String getUserRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object role = session.getAttribute("role");

        return role == null
                ? null
                : role.toString().trim().toUpperCase();
    }

    private Integer getLoggedInEmployeeId(
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("employeeId");

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        if (value instanceof String) {
            try {
                return Integer.valueOf(((String) value).trim());
            } catch (NumberFormatException e) {
                return null;
            }
        }

        return null;
    }

    private boolean isAdmin(HttpServletRequest request) {
        return "ADMIN".equals(getUserRole(request));
    }

    private boolean requireAdmin(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        if (getUserRole(request) == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return false;
        }

        if (!isAdmin(request)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Administrator permission is required.");
            return false;
        }

        return true;
    }

    private boolean canManageProject(
            HttpServletRequest request,
            Project project) {

        if (project == null) {
            return false;
        }

        if (isAdmin(request)) {
            return true;
        }

        if (!"MANAGER".equals(getUserRole(request))) {
            return false;
        }

        Integer loggedInId = getLoggedInEmployeeId(request);

        return loggedInId != null
                && project.getManager() != null
                && project.getManager().getId() != null
                && loggedInId.equals(project.getManager().getId());
    }
}