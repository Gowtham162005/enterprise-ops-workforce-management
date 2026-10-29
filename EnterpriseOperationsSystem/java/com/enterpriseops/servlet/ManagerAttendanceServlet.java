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

import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.User;
import com.enterpriseops.service.AttendanceService;

@WebServlet("/manager/attendance")
public class ManagerAttendanceServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private AttendanceService attendanceService;


    @Override
    public void init() throws ServletException {

        attendanceService =
                new AttendanceService();
    }


    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login");

            return;
        }


        Object roleObject =
                session.getAttribute("role");

        if (roleObject == null
                || !"MANAGER".equals(
                        roleObject.toString())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager access required");

            return;
        }


        User loggedInUser =
                (User) session.getAttribute(
                        "loggedInUser");

        if (loggedInUser == null) {

            response.sendRedirect(
                    request.getContextPath()
                            + "/login");

            return;
        }


        Employee manager =
                loggedInUser.getEmployee();

        if (manager == null
                || manager.getId() == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager employee profile not found");

            return;
        }


        try {

            String dateParameter =
                    request.getParameter("date");

            List<Attendance> attendanceList;

            LocalDate selectedDate = null;


            if (dateParameter != null
                    && !dateParameter.trim().isEmpty()) {

                selectedDate =
                        LocalDate.parse(
                                dateParameter);

                attendanceList =
                        attendanceService
                                .getTeamAttendanceByDate(
                                        manager.getId(),
                                        selectedDate);

            } else {

                attendanceList =
                        attendanceService
                                .getTeamAttendance(
                                        manager.getId());
            }


            int presentCount = 0;
            int absentCount = 0;
            int halfDayCount = 0;
            int leaveCount = 0;


            for (Attendance attendance
                    : attendanceList) {

                if (attendance.getStatus() == null) {
                    continue;
                }

                String status =
                        attendance.getStatus()
                                .trim()
                                .toUpperCase();


                if ("PRESENT".equals(status)) {

                    presentCount++;

                } else if ("ABSENT".equals(status)) {

                    absentCount++;

                } else if ("HALF_DAY".equals(status)) {

                    halfDayCount++;

                } else if ("LEAVE".equals(status)) {

                    leaveCount++;
                }
            }


            request.setAttribute(
                    "attendanceList",
                    attendanceList);

            request.setAttribute(
                    "selectedDate",
                    selectedDate);

            request.setAttribute(
                    "presentCount",
                    presentCount);

            request.setAttribute(
                    "absentCount",
                    absentCount);

            request.setAttribute(
                    "halfDayCount",
                    halfDayCount);

            request.setAttribute(
                    "leaveCount",
                    leaveCount);

            request.setAttribute(
                    "managerEmployeeId",
                    manager.getId());

            request.setAttribute(
                    "username",
                    loggedInUser.getUsername());

            request.setAttribute(
                    "role",
                    "MANAGER");


            request.getRequestDispatcher(
                    "/WEB-INF/views/manager/attendance.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Error loading team attendance: "
                            + e.getMessage());
        }
    }
}