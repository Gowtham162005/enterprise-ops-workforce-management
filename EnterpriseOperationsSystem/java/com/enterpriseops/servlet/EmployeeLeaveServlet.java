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

import com.enterpriseops.model.Employee;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.User;
import com.enterpriseops.service.LeaveService;

@WebServlet("/employee/leaves")
public class EmployeeLeaveServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private LeaveService leaveService;

    @Override
    public void init() throws ServletException {
        leaveService = new LeaveService();
    }

    private User getEmployeeUser(
            HttpServletRequest request,
            HttpServletResponse response) throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        Object value = session.getAttribute("loggedInUser");

        if (!(value instanceof User)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return null;
        }

        User user = (User) value;

        if (user.getRole() == null
                || user.getRole().getName() == null
                || !"EMPLOYEE".equalsIgnoreCase(
                        user.getRole().getName())) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Access denied");
            return null;
        }

        if (user.isMustChangePassword()) {
            response.sendRedirect(
                    request.getContextPath() + "/change-password");
            return null;
        }

        if (user.getEmployee() == null
                || user.getEmployee().getId() == null) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "No employee profile is linked to this account");
            return null;
        }

        return user;
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getEmployeeUser(request, response);

        if (user == null) {
            return;
        }

        try {
            Employee employee = user.getEmployee();

            List<LeaveRequest> leaveRequests =
                    leaveService.getLeaveRequestsByEmployee(
                            employee.getId());

            request.setAttribute("username", user.getUsername());
            request.setAttribute("leaveRequests", leaveRequests);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/leaves.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load employee leave requests", e);
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getEmployeeUser(request, response);

        if (user == null) {
            return;
        }

        HttpSession session = request.getSession();

        try {
            String leaveType = request.getParameter("leaveType");
            String startValue = request.getParameter("startDate");
            String endValue = request.getParameter("endDate");
            String reason = request.getParameter("reason");

            if (startValue == null || startValue.trim().isEmpty()
                    || endValue == null || endValue.trim().isEmpty()) {
                throw new IllegalArgumentException(
                        "Please select both start and end dates.");
            }

            LocalDate startDate = LocalDate.parse(startValue);
            LocalDate endDate = LocalDate.parse(endValue);

            LeaveRequest leaveRequest = new LeaveRequest();

            // Always take the employee ID from the logged-in session.
            leaveRequest.setEmployee(user.getEmployee());
            leaveRequest.setLeaveType(leaveType);
            leaveRequest.setStartDate(startDate);
            leaveRequest.setEndDate(endDate);
            leaveRequest.setReason(reason);

         // Employee leave must go to the manager first.
         leaveRequest.setStatus("PENDING_MANAGER");

         leaveService.addLeaveRequest(leaveRequest);

            session.setAttribute(
                    "leaveSuccess",
                    "Your leave request was submitted successfully.");

        } catch (DateTimeParseException e) {
            session.setAttribute(
                    "leaveError",
                    "Please enter valid leave dates.");

        } catch (IllegalArgumentException e) {
            session.setAttribute("leaveError", e.getMessage());

        } catch (Exception e) {
            getServletContext().log(
                    "Failed to submit employee leave request", e);

            session.setAttribute(
                    "leaveError",
                    "Unable to submit your leave request. Please try again.");
        }

        response.sendRedirect(
                request.getContextPath() + "/employee/leaves");
    }
}