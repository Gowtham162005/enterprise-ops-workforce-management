package com.enterpriseops.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.regex.Pattern;

import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.dao.impl.EmployeeDAOImpl;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Role;
import com.enterpriseops.model.User;

import com.enterpriseops.dao.DepartmentDAO;
import com.enterpriseops.dao.impl.DepartmentDAOImpl;
import com.enterpriseops.model.Department;

public class EmployeeService {

    private final EmployeeDAO employeeDAO;
    private final AuditLogService auditLogService;

    private static final Pattern EMAIL_PATTERN =
            Pattern.compile(
                "^[A-Za-z0-9.!#$%&'*+/=?^_`{|}~-]+@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)+$");
    
    private static final Pattern PHONE_PATTERN =
            Pattern.compile("^[6-9][0-9]{9}$");

    public EmployeeService() {
        this.employeeDAO = new EmployeeDAOImpl();
        this.auditLogService = new AuditLogService();
    }

    // =========================================================
    // ADD EMPLOYEE
    // =========================================================

    public void addEmployee(Employee employee) {

        validateEmployee(employee);

        String employeeCode =
                employee.getEmployeeCode().trim().toUpperCase();

        String email =
                employee.getEmail().trim().toLowerCase();

        employee.setEmployeeCode(employeeCode);
        employee.setEmail(email);

        if (employeeDAO.existsByEmployeeCode(employeeCode)) {
            throw new IllegalArgumentException(
                    "Employee code already exists.");
        }

        if (employeeDAO.existsByEmail(email)) {
            throw new IllegalArgumentException(
                    "Employee email already exists.");
        }

        employeeDAO.save(employee);

        auditLogService.log(
                null,
                "CREATE",
                "EMPLOYEE",
                employee.getId(),
                "Employee created: " + employee.getEmployeeCode());
    }

    // =========================================================
    // ADD EMPLOYEE + LOGIN ACCOUNT
    // Returns [username, temporaryPassword].
    // =========================================================

    public String[] addEmployeeAndCreateAccount(Employee employee) {

        // Save employee first using existing validation and audit logic.
        addEmployee(employee);

        UserService userService = new UserService();

        String baseUsername = employee.getEmployeeCode()
                .toLowerCase()
                .replaceAll("[^a-z0-9._-]", "");

        if (baseUsername.isEmpty()) {
            baseUsername = "employee" + employee.getId();
        }

        String username = baseUsername;
        int suffix = 1;

        // Generate a unique username.
        while (userService.getUserByUsername(username) != null) {
            username = baseUsername + suffix;
            suffix++;
        }

        Role employeeRole = new Role();
        employeeRole.setId(3);
        employeeRole.setName("EMPLOYEE");

        User user = new User();
        user.setUsername(username);
        user.setRole(employeeRole);
        user.setEmployee(employee);

        // This method generates and hashes a temporary password.
        // It also sets mustChangePassword = true.
        String temporaryPassword =
                userService.createEmployeeAccount(user);

        return new String[] { username, temporaryPassword };
    }

    // =========================================================
    // GET EMPLOYEE
    // =========================================================

    public Employee getEmployee(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Invalid employee ID.");
        }

        return employeeDAO.findById(id);
    }

    public List<Employee> getAllEmployees() {
        return employeeDAO.findAll();
    }

    // =========================================================
    // UPDATE EMPLOYEE
    // =========================================================
    public void updateEmployee(Employee employee) {

        if (employee == null
                || employee.getId() == null
                || employee.getId() <= 0) {
            throw new IllegalArgumentException("Invalid employee.");
        }

        validateEmployee(employee);

        String employeeCode =
                employee.getEmployeeCode().trim().toUpperCase();

        String email =
                employee.getEmail().trim().toLowerCase();

        employee.setEmployeeCode(employeeCode);
        employee.setEmail(email);

        if (employeeDAO.existsByEmployeeCodeExceptId(
                employeeCode, employee.getId())) {
            throw new IllegalArgumentException(
                    "Employee code already exists.");
        }

        if (employeeDAO.existsByEmailExceptId(
                email, employee.getId())) {
            throw new IllegalArgumentException(
                    "Employee email already exists.");
        }

        // Verify that the employee exists.
        Employee existingEmployee =
                employeeDAO.findById(employee.getId());

        if (existingEmployee == null) {
            throw new IllegalArgumentException("Employee not found.");
        }

        // A department is required for manager allocation.
        Department selectedDepartment = employee.getDepartment();

        if (selectedDepartment == null
                || selectedDepartment.getId() == null) {
            throw new IllegalArgumentException(
                    "Please select a department.");
        }

        // Verify that the selected department exists.
        DepartmentDAO departmentDAO = new DepartmentDAOImpl();

        Department department =
                departmentDAO.findById(selectedDepartment.getId());

        if (department == null) {
            throw new IllegalArgumentException(
                    "Selected department was not found.");
        }

        employee.setDepartment(department);

        // Validate the selected reporting manager, if one was selected.
        Employee selectedManager = employee.getManager();

        if (selectedManager != null
                && selectedManager.getId() != null) {

            Employee manager =
                    employeeDAO.findById(selectedManager.getId());

            if (manager == null) {
                throw new IllegalArgumentException(
                        "Selected reporting manager was not found.");
            }

            if (manager.getId().equals(employee.getId())) {
                throw new IllegalArgumentException(
                        "An employee cannot be their own reporting manager.");
            }

            if (manager.getDepartment() == null
                    || !department.getId().equals(
                            manager.getDepartment().getId())) {
                throw new IllegalArgumentException(
                        "The reporting manager must belong to the selected department.");
            }

            // Only employees allocated as department managers can be selected.
            if (!employeeDAO.findManagersByDepartment(
                    department.getId()).stream()
                    .anyMatch(m -> m.getId().equals(manager.getId()))) {

                throw new IllegalArgumentException(
                        "The selected employee is not an allocated manager "
                        + "of this department.");
            }

            employee.setManager(manager);

        } else {
            // No reporting manager selected.
            employee.setManager(null);
        }

        employeeDAO.update(employee);

        auditLogService.log(
                null,
                "UPDATE",
                "EMPLOYEE",
                employee.getId(),
                "Employee updated: " + employee.getEmployeeCode());
    }
    // =========================================================
    // DEACTIVATE EMPLOYEE
    // =========================================================

    public void deactivateEmployee(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Invalid employee ID.");
        }

        Employee employee = employeeDAO.findById(id);

        if (employee == null) {
            throw new IllegalArgumentException("Employee not found.");
        }

        if ("INACTIVE".equalsIgnoreCase(employee.getStatus())) {
            throw new IllegalArgumentException(
                    "Employee is already inactive.");
        }

        employeeDAO.deactivate(id);

        auditLogService.log(
                null,
                "DEACTIVATE",
                "EMPLOYEE",
                id,
                "Employee deactivated: " + employee.getEmployeeCode());
    }

    // =========================================================
    // SEARCH / FILTER
    // =========================================================

    public List<Employee> searchEmployees(String keyword) {

        if (keyword == null || keyword.trim().isEmpty()) {
            return employeeDAO.findAll();
        }

        return employeeDAO.search(keyword);
    }

    public List<Employee> getEmployeesByDepartment(Integer departmentId) {

        if (departmentId == null || departmentId <= 0) {
            throw new IllegalArgumentException("Invalid department ID.");
        }

        return employeeDAO.findByDepartment(departmentId);
    }

    public List<Employee> getEmployeesByStatus(String status) {

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Employee status is required.");
        }

        String normalizedStatus = status.trim().toUpperCase();

        if (!"ACTIVE".equals(normalizedStatus)
                && !"INACTIVE".equals(normalizedStatus)) {
            throw new IllegalArgumentException(
                    "Invalid employee status.");
        }

        return employeeDAO.findByStatus(normalizedStatus);
    }

    public long countEmployees() {
        return employeeDAO.countEmployees();
    }

    // =========================================================
    // MANAGER METHODS
    // =========================================================

    public List<Employee> getManagers() {
        return employeeDAO.findManagers();
    }

    public List<Employee> getManagersByDepartment(Integer departmentId) {

        if (departmentId == null || departmentId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid department ID.");
        }

        return employeeDAO.findManagersByDepartment(departmentId);
    }

    public List<Employee> getEmployeesByManager(Integer managerId) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid manager ID.");
        }

        return employeeDAO.findByManager(managerId);
    }

    // =========================================================
    // VALIDATION
    // =========================================================

    private void validateEmployee(Employee employee) {

        if (employee == null) {
            throw new IllegalArgumentException(
                    "Employee cannot be null.");
        }

        if (isBlank(employee.getEmployeeCode())) {
            throw new IllegalArgumentException(
                    "Employee code is required.");
        }

        if (employee.getEmployeeCode().trim().length() > 30) {
            throw new IllegalArgumentException(
                    "Employee code must not exceed 30 characters.");
        }

        if (isBlank(employee.getFirstName())) {
            throw new IllegalArgumentException(
                    "First name is required.");
        }

        if (employee.getFirstName().trim().length() > 100) {
            throw new IllegalArgumentException(
                    "First name must not exceed 100 characters.");
        }

        if (employee.getLastName() != null
                && employee.getLastName().trim().length() > 100) {
            throw new IllegalArgumentException(
                    "Last name must not exceed 100 characters.");
        }

        if (isBlank(employee.getEmail())) {
            throw new IllegalArgumentException("Email is required.");
        }

        if (!EMAIL_PATTERN.matcher(employee.getEmail().trim()).matches()) {
            throw new IllegalArgumentException(
                    "Please enter a valid email address.");
        }

        if (employee.getEmail().trim().length() > 150) {
            throw new IllegalArgumentException(
                    "Email must not exceed 150 characters.");
        }

        if (isBlank(employee.getPhone())) {
            throw new IllegalArgumentException("Phone number is required.");
        }

        String phone = employee.getPhone().trim();

        if (!PHONE_PATTERN.matcher(phone).matches()) {
            throw new IllegalArgumentException(
                    "Enter a valid 10-digit Indian mobile number "
                    + "starting with 6, 7, 8, or 9.");
        }

        employee.setPhone(phone);
        if (employee.getJobTitle() != null
                && employee.getJobTitle().trim().length() > 100) {
            throw new IllegalArgumentException(
                    "Job title must not exceed 100 characters.");
        }

        BigDecimal salary = employee.getSalary();

        if (salary != null && salary.compareTo(BigDecimal.ZERO) < 0) {
            throw new IllegalArgumentException(
                    "Salary cannot be negative.");
        }

        String status = employee.getStatus();

        if (status == null || status.trim().isEmpty()) {
            employee.setStatus("ACTIVE");
        } else {
            status = status.trim().toUpperCase();

            if (!"ACTIVE".equals(status)
                    && !"INACTIVE".equals(status)) {
                throw new IllegalArgumentException(
                        "Status must be ACTIVE or INACTIVE.");
            }

            employee.setStatus(status);
        }

        employee.setEmployeeCode(employee.getEmployeeCode().trim());
        employee.setFirstName(employee.getFirstName().trim());

        if (employee.getLastName() != null) {
            employee.setLastName(employee.getLastName().trim());
        }

        employee.setEmail(employee.getEmail().trim());

        if (employee.getPhone() != null) {
            employee.setPhone(employee.getPhone().trim());
        }

        if (employee.getJobTitle() != null) {
            employee.setJobTitle(employee.getJobTitle().trim());
        }
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
