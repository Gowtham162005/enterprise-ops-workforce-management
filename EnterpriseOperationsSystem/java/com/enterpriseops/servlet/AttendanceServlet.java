package com.enterpriseops.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Employee;
import com.enterpriseops.service.AttendanceService;
import com.enterpriseops.service.EmployeeService;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AttendanceService attendanceService;
    private EmployeeService employeeService;

    @Override
    public void init() throws ServletException {
        attendanceService = new AttendanceService();
        employeeService = new EmployeeService();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if (action == null || "list".equals(action)) {
                listAttendance(request, response);

            } else if ("add".equals(action)) {
                showAddForm(request, response);

            } else if ("edit".equals(action)) {
                showEditForm(request, response);

            } else if ("delete".equals(action)) {
                deleteAttendance(request, response);

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid action");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error processing attendance request: "
                            + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        try {
            if ("add".equals(action)) {
                addAttendance(request, response);

            } else if ("update".equals(action)) {
                updateAttendance(request, response);

            } else {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid action");
            }

        } catch (Exception e) {
            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    e.getMessage());
        }
    }

    private void listAttendance(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        List<Attendance> attendanceList =
                attendanceService.getAllAttendance();

        request.setAttribute(
                "attendanceList",
                attendanceList);

        request.getRequestDispatcher(
                "/WEB-INF/views/attendance/list.jsp")
                .forward(request, response);
    }

    private void showAddForm(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        List<Employee> employees =
                employeeService.getAllEmployees();

        request.setAttribute(
                "employees",
                employees);

        request.getRequestDispatcher(
                "/WEB-INF/views/attendance/add.jsp")
                .forward(request, response);
    }

    private void addAttendance(HttpServletRequest request,
                               HttpServletResponse response)
            throws IOException {

        Attendance attendance =
                buildAttendanceFromRequest(request);

        attendanceService.addAttendance(attendance);

        response.sendRedirect(
                request.getContextPath() + "/attendance");
    }

    private void showEditForm(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        int id = Integer.parseInt(
                request.getParameter("id"));

        Attendance attendance =
                attendanceService.getAttendance(id);

        if (attendance == null) {
            response.sendError(
                    HttpServletResponse.SC_NOT_FOUND,
                    "Attendance record not found");
            return;
        }

        List<Employee> employees =
                employeeService.getAllEmployees();

        request.setAttribute(
                "attendance",
                attendance);

        request.setAttribute(
                "employees",
                employees);

        request.getRequestDispatcher(
                "/WEB-INF/views/attendance/edit.jsp")
                .forward(request, response);
    }

    private void updateAttendance(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(
                request.getParameter("id"));

        Attendance attendance =
                buildAttendanceFromRequest(request);

        attendance.setId(id);

        attendanceService.updateAttendance(
                attendance);

        response.sendRedirect(
                request.getContextPath() + "/attendance");
    }

    private void deleteAttendance(HttpServletRequest request,
                                  HttpServletResponse response)
            throws IOException {

        int id = Integer.parseInt(
                request.getParameter("id"));

        attendanceService.deleteAttendance(id);

        response.sendRedirect(
                request.getContextPath() + "/attendance");
    }

    private Attendance buildAttendanceFromRequest(
            HttpServletRequest request) {

        String employeeIdValue =
                request.getParameter("employeeId");

        String dateValue =
                request.getParameter("attendanceDate");

        String status =
                request.getParameter("status");

        String checkInValue =
                request.getParameter("checkIn");

        String checkOutValue =
                request.getParameter("checkOut");

        String notes =
                request.getParameter("notes");

        if (employeeIdValue == null ||
                employeeIdValue.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Employee is required");
        }

        if (dateValue == null ||
                dateValue.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Attendance date is required");
        }

        int employeeId =
                Integer.parseInt(employeeIdValue);

        Employee employee = new Employee();
        employee.setId(employeeId);

        Attendance attendance =
                new Attendance();

        attendance.setEmployee(employee);

        attendance.setAttendanceDate(
                LocalDate.parse(dateValue));

        attendance.setStatus(status);

        if (checkInValue != null &&
                !checkInValue.trim().isEmpty()) {

            attendance.setCheckIn(
                    LocalTime.parse(checkInValue));
        }

        if (checkOutValue != null &&
                !checkOutValue.trim().isEmpty()) {

            attendance.setCheckOut(
                    LocalTime.parse(checkOutValue));
        }

        attendance.setNotes(notes);

        return attendance;
    }
}