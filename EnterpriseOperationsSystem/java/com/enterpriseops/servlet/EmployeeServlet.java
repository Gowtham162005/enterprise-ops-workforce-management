
package com.enterpriseops.servlet;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;
import com.enterpriseops.service.DepartmentService;
import com.enterpriseops.service.EmployeeService;
import com.enterpriseops.service.UserService;

@WebServlet("/employees")
public class EmployeeServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private EmployeeService employeeService;
    private DepartmentService departmentService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        employeeService = new EmployeeService();
        departmentService = new DepartmentService();
        userService = new UserService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || "list".equals(action)) {
            listEmployees(request, response);
        } else if ("add".equals(action)) {
            showAddForm(request, response);
        } else if ("edit".equals(action)) {
            showEditForm(request, response);
        } else if ("search".equals(action)) {
            searchEmployees(request, response);
        } else if ("managersByDepartment".equals(action)) {
            getManagersByDepartment(request, response);
        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid employee action.");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("resetPassword".equals(action)) {
            resetEmployeePassword(request, response);
        } else if ("add".equals(action)) {
            addEmployee(request, response);
        } else if ("update".equals(action)) {
            updateEmployee(request, response);
        } else if ("deactivate".equals(action)) {
            deactivateEmployee(request, response);
        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid employee action.");
        }
    }

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return false;
        }

        Object roleValue = session.getAttribute("role");

        if (roleValue != null
                && "ADMIN".equalsIgnoreCase(roleValue.toString().trim())) {
            return true;
        }

        Object loggedInUser = session.getAttribute("loggedInUser");

        if (loggedInUser instanceof User) {
            User user = (User) loggedInUser;

            return user.getRole() != null
                    && user.getRole().getName() != null
                    && "ADMIN".equalsIgnoreCase(
                            user.getRole().getName().trim());
        }

        return false;
    }

    private void resetEmployeePassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdmin(request)) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators can reset employee passwords.");
            return;
        }

        try {
            String idValue = request.getParameter("id");

            if (idValue == null || idValue.trim().isEmpty()) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Employee ID is required.");
                return;
            }

            int employeeId = Integer.parseInt(idValue.trim());

            if (employeeId <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid employee ID.");
                return;
            }

            Employee employee = employeeService.getEmployee(employeeId);

            if (employee == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Employee not found.");
                return;
            }

            String[] credentials =
                    userService.createOrResetEmployeeAccount(employee);

            if (credentials == null
                    || credentials.length < 2
                    || credentials[0] == null
                    || credentials[1] == null) {
                throw new IllegalStateException(
                        "Temporary credentials could not be generated.");
            }

            request.setAttribute("resetUsername", credentials[0]);
            request.setAttribute("temporaryPassword", credentials[1]);
            request.setAttribute(
                    "success",
                    "Temporary credentials generated successfully. "
                    + "Share them securely with the employee.");

            listEmployees(request, response);

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid employee ID.");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            listEmployees(request, response);

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to reset or create employee account.", e);

            request.setAttribute(
                    "error",
                    "Unable to reset or create the employee account. "
                    + "Check the server logs for details.");

            listEmployees(request, response);
        }
    }

    private void listEmployees(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute(
                "employees", employeeService.getAllEmployees());

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/list.jsp")
                .forward(request, response);
    }

    private void searchEmployees(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        request.setAttribute(
                "employees", employeeService.searchEmployees(keyword));
        request.setAttribute("keyword", keyword);

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/list.jsp")
                .forward(request, response);
    }

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        loadFormData(request);

        request.getRequestDispatcher(
                "/WEB-INF/views/employee/add.jsp")
                .forward(request, response);
    }

    private void addEmployee(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Employee employee = buildEmployeeFromRequest(request);

            String[] credentials =
                    employeeService.addEmployeeAndCreateAccount(employee);

            request.setAttribute("createdUsername", credentials[0]);
            request.setAttribute("temporaryPassword", credentials[1]);
            request.setAttribute(
                    "success",
                    "Employee and login account created. "
                    + "Share the temporary credentials securely.");

            loadFormData(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/add.jsp")
                    .forward(request, response);

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            loadFormData(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/add.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to create employee and login account.", e);

            request.setAttribute(
                    "error",
                    "Unable to complete employee/account creation. "
                    + "Check whether the employee was saved before retrying.");

            loadFormData(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/add.jsp")
                    .forward(request, response);
        }
    }

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            Employee employee = employeeService.getEmployee(id);

            if (employee == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Employee not found.");
                return;
            }

            request.setAttribute("employee", employee);
            loadFormData(request);

            // Load managers for this employee's current department.
            Integer departmentId = employee.getDepartment() == null
                    ? null
                    : employee.getDepartment().getId();

            loadDepartmentManagers(request, departmentId);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid employee ID.");

        } catch (Exception e) {
            getServletContext().log("Unable to load employee.", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to load employee.");
        }
    }

    private void updateEmployee(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        Employee employee = null;

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            employee = buildEmployeeFromRequest(request);
            employee.setId(id);

            employeeService.updateEmployee(employee);
            String username = request.getParameter("username");

            if (username != null && !username.trim().isEmpty()) {
                userService.updateEmployeeUsername(id, username);
            }

            response.sendRedirect(
                    request.getContextPath() + "/employees");

        } catch (IllegalArgumentException e) {
            request.setAttribute("error", e.getMessage());
            request.setAttribute("employee", employee);

            loadFormData(request);
            loadDepartmentManagersFromRequest(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/edit.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            getServletContext().log("Unable to update employee.", e);

            request.setAttribute(
                    "error",
                    "Unable to update employee. Please try again.");

            request.setAttribute("employee", employee);

            loadFormData(request);
            loadDepartmentManagersFromRequest(request);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/edit.jsp")
                    .forward(request, response);
        }
    }

    private void deactivateEmployee(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            employeeService.deactivateEmployee(id);

            response.sendRedirect(
                    request.getContextPath() + "/employees");

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid employee ID.");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to deactivate employee.", e);

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to deactivate employee.");
        }
    }

    /**
     * AJAX endpoint used by the Edit Employee page.
     * The managers come from the department_managers relationship.
     */
    private void getManagersByDepartment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String departmentValue = request.getParameter("departmentId");

            if (departmentValue == null
                    || departmentValue.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write(
                        "{\"error\":\"Department ID is required\"}");
                return;
            }

            int departmentId = Integer.parseInt(departmentValue.trim());

            Department department =
                    departmentService.getDepartment(departmentId);

            if (department == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write(
                        "{\"error\":\"Department not found\"}");
                return;
            }

            Set<Employee> departmentManagers = department.getManagers();

            StringBuilder json = new StringBuilder("[");
            boolean first = true;

            if (departmentManagers != null) {
                for (Employee manager : departmentManagers) {
                    if (manager == null || manager.getId() == null) {
                        continue;
                    }

                    if (!first) {
                        json.append(",");
                    }
                    first = false;

                    String fullName =
                            (manager.getFirstName() == null
                                    ? ""
                                    : manager.getFirstName().trim())
                            + (manager.getLastName() == null
                                    || manager.getLastName().trim().isEmpty()
                                    ? ""
                                    : " " + manager.getLastName().trim());

                    json.append("{")
                        .append("\"id\":").append(manager.getId()).append(",")
                        .append("\"name\":\"")
                        .append(escapeJson(fullName)).append("\",")
                        .append("\"code\":\"")
                        .append(escapeJson(manager.getEmployeeCode()))
                        .append("\"}");
                }
            }

            json.append("]");
            response.getWriter().write(json.toString());

        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write(
                    "{\"error\":\"Invalid department ID\"}");

        } catch (Exception e) {
            getServletContext().log(
                    "Unable to load managers by department.", e);

            response.setStatus(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write(
                    "{\"error\":\"Unable to load managers\"}");
        }
    }

    private void loadFormData(HttpServletRequest request) {
        request.setAttribute(
                "departments", departmentService.getAllDepartments());

        // Retained for your existing Add Employee form if it uses this list.
        request.setAttribute(
                "managers", employeeService.getManagers());
    }

    /**
     * Loads managers for a department into the JSP attribute
     * named departmentManagers.
     */
    private void loadDepartmentManagers(
            HttpServletRequest request,
            Integer departmentId) {

        if (departmentId == null) {
            request.setAttribute(
                    "departmentManagers",
                    Collections.emptyList());
            return;
        }

        Department department =
                departmentService.getDepartment(departmentId);

        if (department == null || department.getManagers() == null) {
            request.setAttribute(
                    "departmentManagers",
                    Collections.emptyList());
            return;
        }

        request.setAttribute(
                "departmentManagers",
                new ArrayList<Employee>(department.getManagers()));
    }

    /**
     * Reloads manager options if the update form is redisplayed
     * after a validation or persistence error.
     */
    private void loadDepartmentManagersFromRequest(
            HttpServletRequest request) {

        String departmentValue = request.getParameter("departmentId");

        if (departmentValue == null || departmentValue.trim().isEmpty()) {
            loadDepartmentManagers(request, null);
            return;
        }

        try {
            loadDepartmentManagers(
                    request,
                    Integer.parseInt(departmentValue.trim()));
        } catch (NumberFormatException e) {
            loadDepartmentManagers(request, null);
        }
    }

    private String escapeJson(String value) {
        if (value == null) {
            return "";
        }

        return value
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }

    private Employee buildEmployeeFromRequest(
            HttpServletRequest request) {

        Employee employee = new Employee();

        employee.setEmployeeCode(request.getParameter("employeeCode"));
        employee.setFirstName(request.getParameter("firstName"));
        employee.setLastName(request.getParameter("lastName"));
        employee.setEmail(request.getParameter("email"));
        employee.setPhone(request.getParameter("phone"));
        employee.setJobTitle(request.getParameter("jobTitle"));
        employee.setStatus(request.getParameter("status"));

        String salaryValue = request.getParameter("salary");

        if (salaryValue != null && !salaryValue.trim().isEmpty()) {
            employee.setSalary(new BigDecimal(salaryValue.trim()));
        }

        String departmentIdValue = request.getParameter("departmentId");

        if (departmentIdValue != null
                && !departmentIdValue.trim().isEmpty()) {
            Department department = new Department();
            department.setId(Integer.parseInt(departmentIdValue.trim()));
            employee.setDepartment(department);
        } else {
            employee.setDepartment(null);
        }

        /*
         * The manager dropdown submits managerId.
         * An empty value deliberately clears the employee's manager.
         */
        String managerIdValue = request.getParameter("managerId");

        if (managerIdValue != null
                && !managerIdValue.trim().isEmpty()) {
            Employee manager = new Employee();
            manager.setId(Integer.parseInt(managerIdValue.trim()));
            employee.setManager(manager);
        } else {
            employee.setManager(null);
        }

        String joiningDateValue = request.getParameter("joiningDate");

        if (joiningDateValue != null
                && !joiningDateValue.trim().isEmpty()) {
            employee.setJoiningDate(
                    LocalDate.parse(joiningDateValue.trim()));
        }

        return employee;
    }
}
