package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Role;
import com.enterpriseops.model.User;
import com.enterpriseops.service.DepartmentService;
import com.enterpriseops.service.EmployeeService;
import com.enterpriseops.service.UserService;

@WebServlet("/admin/managers")
public class ManagerManagementServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DepartmentService departmentService;
    private EmployeeService employeeService;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        departmentService = new DepartmentService();
        employeeService = new EmployeeService();
        userService = new UserService();
    }

    // Display manager management page
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            List<Department> departments =
                    departmentService.getAllDepartments();

            List<Employee> employees =
                    employeeService.getAllEmployees();

            List<User> managerUsers =
                    getUsersWithEmployeeAccounts();

            request.setAttribute("departments", departments);
            request.setAttribute("employees", employees);
            request.setAttribute("managerUsers", managerUsers);

            request.getRequestDispatcher(
                    "/WEB-INF/views/admin/manager-management.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            throw new ServletException(
                    "Unable to load manager management page.", e);
        }
    }

    // Handle form actions
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("assign".equals(action)) {
            assignManager(request, response);

        } else if ("remove".equals(action)) {
            removeManager(request, response);

        } else if ("resetPassword".equals(action)) {
            resetPassword(request, response);

        } else if ("updateUsername".equals(action)) {
            updateUsername(request, response);

        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
        }
    }

    // Assign an employee as a department manager
    private void assignManager(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            Integer departmentId =
                    parseRequiredId(
                            request.getParameter("departmentId"),
                            "Department ID");

            Integer employeeId =
                    parseRequiredId(
                            request.getParameter("employeeId"),
                            "Employee ID");

            Employee employee =
                    employeeService.getEmployee(employeeId);

            if (employee == null) {
                throw new IllegalArgumentException(
                        "Employee not found.");
            }

            if (employee.getDepartment() == null
                    || employee.getDepartment().getId() == null) {
                throw new IllegalArgumentException(
                        "Selected employee has no department.");
            }

            if (!departmentId.equals(
                    employee.getDepartment().getId())) {
                throw new IllegalArgumentException(
                        "Selected employee does not belong "
                        + "to the selected department.");
            }

            // Find any existing account linked to this employee.
            User managerUser = findUserByEmployeeId(employeeId);

            if (managerUser != null) {

                // Promote the existing account when necessary.
                Role role = managerUser.getRole();

                if (role == null
                        || role.getName() == null
                        || !"MANAGER".equalsIgnoreCase(
                                role.getName())) {

                    userService.updateUserRole(
                            managerUser.getId(), "MANAGER");
                }

            } else {

                // Create an account if the employee has none.
                String username =
                        request.getParameter("username");

                String password =
                        request.getParameter("password");

                String confirmPassword =
                        request.getParameter("confirmPassword");

                if (username == null
                        || username.trim().isEmpty()) {
                    throw new IllegalArgumentException(
                            "Username is required for this employee.");
                }

                username = username.trim();

                if (password == null || password.isEmpty()) {
                    throw new IllegalArgumentException(
                            "Password is required for this employee.");
                }

                if (confirmPassword == null
                        || !password.equals(confirmPassword)) {
                    throw new IllegalArgumentException(
                            "Passwords do not match.");
                }

                if (userService.getUserByUsername(username) != null) {
                    throw new IllegalArgumentException(
                            "Username already exists. "
                            + "Please choose another username.");
                }

                Role managerRole = new Role();
                managerRole.setId(2);
                managerRole.setName("MANAGER");

                User newManager = new User(
                        username,
                        password,
                        managerRole,
                        employee);

                userService.createUser(newManager);
            }

            // Service must validate employee status and assignment.
            departmentService.assignManager(
                    departmentId, employeeId);

            response.sendRedirect(
                    request.getContextPath() + "/admin/managers");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to assign manager.");
        }
    }

    // Remove one manager from one department only
    private void removeManager(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            Integer departmentId =
                    parseRequiredId(
                            request.getParameter("departmentId"),
                            "Department ID");

            Integer employeeId =
                    parseRequiredId(
                            request.getParameter("employeeId"),
                            "Manager employee ID");

            departmentService.removeManager(
                    departmentId, employeeId);

            response.sendRedirect(
                    request.getContextPath() + "/admin/managers");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();

            throw new IOException(
                    "Unable to remove department manager.", e);
        }
    }

    // Reset a manager's password
    private void resetPassword(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            Integer userId =
                    parseRequiredId(
                            request.getParameter("userId"),
                            "User ID");

            String newPassword =
                    request.getParameter("newPassword");

            String confirmPassword =
                    request.getParameter("confirmPassword");

            if (newPassword == null || newPassword.isEmpty()) {
                throw new IllegalArgumentException(
                        "New password is required.");
            }

            if (newPassword.length() < 8) {
                throw new IllegalArgumentException(
                        "Password must be at least 8 characters.");
            }

            if (confirmPassword == null
                    || !newPassword.equals(confirmPassword)) {
                throw new IllegalArgumentException(
                        "Passwords do not match.");
            }

            User user = userService.getUserById(userId);

            if (user == null) {
                throw new IllegalArgumentException(
                        "User account not found.");
            }

            if (user.getRole() == null
                    || !"MANAGER".equalsIgnoreCase(
                            user.getRole().getName())) {
                throw new IllegalArgumentException(
                        "Selected user is not a manager.");
            }

            if (user.getEmployee() == null
                    || user.getEmployee().getId() == null) {
                throw new IllegalArgumentException(
                        "Manager employee profile is not configured.");
            }

            userService.resetPassword(userId, newPassword);

            response.sendRedirect(
                    request.getContextPath() + "/admin/managers");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to reset manager password.");
        }
    }

    // Update a manager's username
    private void updateUsername(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            Integer userId =
                    parseRequiredId(
                            request.getParameter("userId"),
                            "User ID");

            String newUsername =
                    request.getParameter("username");

            if (newUsername == null
                    || newUsername.trim().isEmpty()) {
                throw new IllegalArgumentException(
                        "Username is required.");
            }

            userService.updateUsername(
                    userId, newUsername.trim());

            response.sendRedirect(
                    request.getContextPath() + "/admin/managers");

        } catch (IllegalArgumentException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to update manager username.");
        }
    }

    // Find the user account linked to an employee

private User findUserByEmployeeId(Integer employeeId) {

    if (employeeId == null) {
        return null;
    }

    List<User> allUsers = userService.getAllUsers();

    if (allUsers == null) {
        return null;
    }

    for (User user : allUsers) {
        if (user == null
                || user.getEmployee() == null
                || user.getEmployee().getId() == null) {
            continue;
        }

        if (employeeId.equals(user.getEmployee().getId())) {
            return user;
        }
    }

    return null;
}


    // Get user accounts linked to employee profiles

private List<User> getUsersWithEmployeeAccounts() {
    List<User> managerUsers = new ArrayList<>();

    // Only the six current managers
    Set<Integer> currentManagerEmployeeIds =
            new HashSet<>(Arrays.asList(1, 2, 5, 7, 15, 29));

    for (User user : userService.getAllUsers()) {
        if (user.getRole() == null
                || !"MANAGER".equalsIgnoreCase(user.getRole().getName())) {
            continue;
        }

        if (user.getEmployee() == null) {
            continue;
        }

        Integer employeeId = user.getEmployee().getId();

        if (currentManagerEmployeeIds.contains(employeeId)) {
            managerUsers.add(user);
        }
    }

    return managerUsers;
}
    // Validate and parse required integer request parameters
    private Integer parseRequiredId(String value, String fieldName) {

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    fieldName + " is required.");
        }

        try {
            Integer id = Integer.valueOf(value.trim());

            if (id <= 0) {
                throw new IllegalArgumentException(
                        "Invalid " + fieldName + ".");
            }

            return id;

        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(
                    "Invalid " + fieldName + ".");
        }
    }
}