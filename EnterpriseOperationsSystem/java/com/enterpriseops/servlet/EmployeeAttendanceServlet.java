package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;
import com.enterpriseops.service.AttendanceService;

@WebServlet("/employee/attendance")
public class EmployeeAttendanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AttendanceService attendanceService;

    @Override
    public void init() throws ServletException {
        attendanceService = new AttendanceService();
    }

    private User getEmployeeUser(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return null;
        }

        Object loggedInObject = session.getAttribute("loggedInUser");

        if (!(loggedInObject instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return null;
        }

        User user = (User) loggedInObject;

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

        Employee employee = user.getEmployee();

        try {
            Attendance today =
                    attendanceService.getTodayAttendance(
                            employee.getId());

            List<Attendance> records =
                    attendanceService.getEmployeeAttendance(
                            employee.getId());

            request.setAttribute("username", user.getUsername());
            request.setAttribute("employee", employee);
            request.setAttribute("todayAttendance", today);
            request.setAttribute("attendanceRecords", records);

            request.getRequestDispatcher(
                    "/WEB-INF/views/employee/attendance.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            throw new ServletException(
                    "Unable to load employee attendance", e);
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

        Employee employee = user.getEmployee();

        String action = request.getParameter("action");

        try {
            if ("checkIn".equals(action)) {

                attendanceService.checkIn(employee.getId());

                request.getSession().setAttribute(
                        "attendanceMessage",
                        "Check-in recorded successfully.");

            } else if ("checkOut".equals(action)) {

                attendanceService.checkOut(employee.getId());

                request.getSession().setAttribute(
                        "attendanceMessage",
                        "Check-out recorded successfully.");

            } else {

                request.getSession().setAttribute(
                        "attendanceError",
                        "Invalid attendance action.");
            }

        } catch (IllegalStateException | IllegalArgumentException e) {

            request.getSession().setAttribute(
                    "attendanceError",
                    e.getMessage());

        } catch (Exception e) {

            getServletContext().log(
                    "Employee attendance action failed", e);

            request.getSession().setAttribute(
                    "attendanceError",
                    "Unable to update attendance. Please try again.");
        }

        response.sendRedirect(
                request.getContextPath() + "/employee/attendance");
    }
}