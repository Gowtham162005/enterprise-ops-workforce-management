
package com.enterpriseops.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.util.Arrays;
import java.util.Locale;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Employee;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.User;
import com.enterpriseops.service.EmployeeService;
import com.enterpriseops.service.LeaveService;

@WebServlet("/leaves")
public class LeaveServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private LeaveService leaveService;
    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        leaveService = new LeaveService();
        employeeService = new EmployeeService();
    }

    // =========================================================
    // GET REQUESTS
    // =========================================================

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || "list".equals(action)) {
            listLeaves(request, response);

        } else if ("add".equals(action)) {
            showAddForm(request, response);

        } else if ("edit".equals(action)) {
            showEditForm(request, response);

        } else if ("delete".equals(action)
                || "approve".equals(action)
                || "reject".equals(action)) {

            response.sendError(
                    HttpServletResponse.SC_METHOD_NOT_ALLOWED,
                    "This action must use POST.");

        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
        }
    }

    // =========================================================
    // POST REQUESTS
    // =========================================================

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            addLeave(request, response);

        } else if ("update".equals(action)) {
            updateLeave(request, response);

        } else if ("approve".equals(action)) {
            approveLeave(request, response);

        } else if ("reject".equals(action)) {
            rejectLeave(request, response);

        } else if ("delete".equals(action)) {
            deleteLeave(request, response);

        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action.");
        }
    }

    // =========================================================
    // LIST LEAVE REQUESTS
    // =========================================================

    private void listLeaves(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return;
        }

        String role = getRole(user);

        if ("ADMIN".equals(role)) {

            request.setAttribute(
                    "leaveRequests",
                    leaveService.getAllLeaveRequests());

        } else if ("MANAGER".equals(role)) {

            if (user.getEmployee() == null
                    || user.getEmployee().getId() == null) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Manager account has no linked employee record.");
                return;
            }

            request.setAttribute(
                    "leaveRequests",
                    leaveService.getLeaveRequestsByManager(
                            user.getEmployee().getId()));

        } else if ("EMPLOYEE".equals(role)) {

            if (user.getEmployee() == null
                    || user.getEmployee().getId() == null) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Employee account has no linked employee record.");
                return;
            }

            request.setAttribute(
                    "leaveRequests",
                    leaveService.getLeaveRequestsByEmployee(
                            user.getEmployee().getId()));

        } else {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Invalid user role.");
            return;
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/leave/list.jsp")
                .forward(request, response);
    }

    // =========================================================
    // SHOW ADD FORM
    // =========================================================

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return;
        }

        String role = getRole(user);

        if (!"EMPLOYEE".equals(role)
                && !"MANAGER".equals(role)) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only employees and managers can apply for leave.");
            return;
        }

        if (user.getEmployee() == null
                || user.getEmployee().getId() == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Your account must be linked to an employee record.");
            return;
        }

        request.getRequestDispatcher(
                "/WEB-INF/views/leave/add.jsp")
                .forward(request, response);
    }

    // =========================================================
    // ADD LEAVE REQUEST
    // =========================================================

    private void addLeave(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            User user = requireLoggedInUser(request);
            String role = getRole(user);

            if (!"EMPLOYEE".equals(role)
                    && !"MANAGER".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Only employees and managers can apply for leave.");
                return;
            }

            Employee employee = user.getEmployee();

            if (employee == null || employee.getId() == null) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Your account must be linked to an employee record.");
                return;
            }

            LeaveRequest leave = buildLeaveFromRequest(request);

            // Associate the request with the logged-in employee.
            leave.setEmployee(employee);

            // Set workflow status explicitly.
            if ("EMPLOYEE".equalsIgnoreCase(role)) {
                leave.setStatus("PENDING_MANAGER");
            } else if ("MANAGER".equalsIgnoreCase(role)) {
                leave.setStatus("PENDING_ADMIN");
            } else {
                throw new IllegalArgumentException(
                        "Unsupported role: " + role);
            }
            // Diagnostic output for troubleshooting.
            System.out.println(
                    "LeaveServlet submitting status: "
                            + leave.getStatus()
                            + ", type: " + leave.getLeaveType()
                            + ", role: " + role);

            // Save through the service.
         // Print the status immediately before calling the service.
            System.out.println("========== LEAVE DEBUG ==========");
            System.out.println("Logged-in username: " + user.getUsername());
            System.out.println("Role: [" + role + "]");
            System.out.println("Status: [" + leave.getStatus() + "]");
            System.out.println("Leave type: [" + leave.getLeaveType() + "]");
            System.out.println("==================================");
            // Save through the service.
            leaveService.addLeaveRequest(leave);

            response.sendRedirect(
            request.getContextPath() + "/leaves");

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid leave request: " + e.getMessage());

        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to submit leave request. "
                            + "Check the Eclipse Console for details.");
        }
    }

    // =========================================================
    // SHOW EDIT FORM
    // =========================================================

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return;
        }

        if (!"ADMIN".equals(getRole(user))) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators may access this edit page.");
            return;
        }

        try {
            int id = getRequiredId(request);

            LeaveRequest leave = leaveService.getLeaveRequest(id);

            if (leave == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Leave request not found.");
                return;
            }

            request.setAttribute("leaveRequest", leave);

            request.getRequestDispatcher(
                    "/WEB-INF/views/leave/edit.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing or invalid leave request ID.");
        }
    }

    // =========================================================
    // UPDATE LEAVE REQUEST
    // =========================================================

    private void updateLeave(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        User user = getLoggedInUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return;
        }

        if (!"ADMIN".equals(getRole(user))) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators may update leave requests.");
            return;
        }

        try {
            int id = getRequiredId(request);

            LeaveRequest existing = leaveService.getLeaveRequest(id);

            if (existing == null) {
                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Leave request not found.");
                return;
            }

            LeaveRequest updated = buildLeaveFromRequest(request);

            updated.setId(id);
            updated.setEmployee(existing.getEmployee());

            leaveService.updateLeaveRequest(updated);

            response.sendRedirect(
                    request.getContextPath() + "/leaves");

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing or invalid leave request ID.");

        } catch (IllegalArgumentException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to update leave request: " + e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to update leave request.");
        }
    }

    // =========================================================
    // APPROVE LEAVE REQUEST
    // =========================================================

    private void approveLeave(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            User user = requireLoggedInUser(request);
            int id = getRequiredId(request);
            String role = getRole(user);

            if ("ADMIN".equals(role)) {

                leaveService.approveLeave(id, user);

            } else if ("MANAGER".equals(role)) {

                if (user.getEmployee() == null
                        || user.getEmployee().getId() == null) {

                    response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "Manager account has no linked employee record.");
                    return;
                }

                leaveService.approveLeaveForManager(
                        id,
                        user.getEmployee().getId());

            } else {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Only managers and administrators can approve leave.");
                return;
            }

            response.sendRedirect(
                    request.getContextPath() + "/leaves");

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing or invalid leave request ID.");

        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (IllegalStateException e) {

            response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to approve leave request.");
        }
    }

    // =========================================================
    // REJECT LEAVE REQUEST
    // =========================================================

    private void rejectLeave(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {
            User user = requireLoggedInUser(request);
            int id = getRequiredId(request);
            String role = getRole(user);

            if ("ADMIN".equals(role)) {

                leaveService.rejectLeave(id, user);

            } else if ("MANAGER".equals(role)) {

                if (user.getEmployee() == null
                        || user.getEmployee().getId() == null) {

                    response.sendError(
                            HttpServletResponse.SC_FORBIDDEN,
                            "Manager account has no linked employee record.");
                    return;
                }

                leaveService.rejectLeaveForManager(
                        id,
                        user.getEmployee().getId());

            } else {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Only managers and administrators can reject leave.");
                return;
            }

            response.sendRedirect(
                    request.getContextPath() + "/leaves");

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing or invalid leave request ID.");

        } catch (SecurityException e) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (IllegalStateException e) {

            response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    e.getMessage());

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to reject leave request.");
        }
    }

    // =========================================================
    // DELETE LEAVE REQUEST
    // =========================================================

    private void deleteLeave(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        User user = getLoggedInUser(request);

        if (user == null) {
            response.sendError(
                    HttpServletResponse.SC_UNAUTHORIZED,
                    "Please sign in.");
            return;
        }

        if (!"ADMIN".equals(getRole(user))) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Only administrators may delete leave requests.");
            return;
        }

        try {
            int id = getRequiredId(request);

            leaveService.deleteLeaveRequest(id);

            response.sendRedirect(
                    request.getContextPath() + "/leaves");

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Missing or invalid leave request ID.");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Unable to delete leave request.");
        }
    }

    // =========================================================
    // HELPER: REQUIRED ID
    // =========================================================

    private int getRequiredId(HttpServletRequest request) {

        String value = request.getParameter("id");

        if (value == null || value.trim().isEmpty()) {
            throw new NumberFormatException(
                    "Leave ID is missing.");
        }

        return Integer.parseInt(value.trim());
    }

    // =========================================================
    // HELPER: BUILD LEAVE REQUEST FROM FORM
    // =========================================================

    private LeaveRequest buildLeaveFromRequest(
            HttpServletRequest request) {

        String leaveType = request.getParameter("leaveType");
        String startValue = request.getParameter("startDate");
        String endValue = request.getParameter("endDate");
        String reason = request.getParameter("reason");

        if (leaveType == null || leaveType.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Please select a leave type.");
        }

        leaveType = leaveType.trim().toUpperCase(Locale.ROOT);

        if (!Arrays.asList(
                "CASUAL",
                "SICK",
                "ANNUAL",
                "MATERNITY",
                "PATERNITY",
                "UNPAID"
        ).contains(leaveType)) {

            throw new IllegalArgumentException(
                    "Unsupported leave type: " + leaveType);
        }

        if (startValue == null
                || startValue.trim().isEmpty()
                || endValue == null
                || endValue.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Start date and end date are required.");
        }

        try {
            LeaveRequest leave = new LeaveRequest();

            leave.setLeaveType(leaveType);
            leave.setStartDate(
                    LocalDate.parse(startValue.trim()));
            leave.setEndDate(
                    LocalDate.parse(endValue.trim()));
            leave.setReason(reason);

            return leave;

        } catch (java.time.format.DateTimeParseException e) {

            throw new IllegalArgumentException(
                    "Please enter valid start and end dates.");
        }
    }

    // =========================================================
    // HELPER: GET LOGGED-IN USER
    // =========================================================

    private User getLoggedInUser(
            HttpServletRequest request) {

        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object value = session.getAttribute("loggedInUser");

        if (!(value instanceof User)) {
            return null;
        }

        return (User) value;
    }

    // =========================================================
    // HELPER: REQUIRE LOGGED-IN USER
    // =========================================================

    private User requireLoggedInUser(
            HttpServletRequest request) {

        User user = getLoggedInUser(request);

        if (user == null) {
            throw new SecurityException(
                    "Please sign in again.");
        }

        return user;
    }

    // =========================================================
    // HELPER: GET USER ROLE
    // =========================================================

    private String getRole(User user) {

        if (user == null
                || user.getRole() == null
                || user.getRole().getName() == null) {

            return "";
        }

        return user.getRole()
                .getName()
                .trim()
                .toUpperCase(Locale.ROOT);
    }
}