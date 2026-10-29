<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Attendance" %>
<%@ page import="com.enterpriseops.model.Employee" %>

<%
    List<Attendance> attendanceList =
            (List<Attendance>) request.getAttribute("attendanceList");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Attendance Management | Enterprise Operations</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        /* PAGE LAYOUT — aligned with Employee JSP */
        .app-layout {
            width: 100%;
            min-height: 100vh;
        }

        .main-content {
            margin-left: 240px;
            width: calc(100% - 240px);
            max-width: calc(100% - 240px);
            min-height: 100vh;
            min-width: 0;
            box-sizing: border-box;
            position: relative;
        }

        .attendance-page {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        /* PAGE CONTAINER */
        .attendance-container {
            width: 100%;
            max-width: 100%;
            min-width: 0;
            margin: 0 auto;
            box-sizing: border-box;
        }

        /* HEADER */
        .attendance-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 18px;
            margin-bottom: 25px;
            min-width: 0;
        }

        .attendance-header-content {
            min-width: 0;
        }

        .attendance-header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .attendance-subtitle {
            margin-top: 6px;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        /* ADD ATTENDANCE BUTTON */
        .add-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            background: #111827;
            color: #ffffff;
            text-decoration: none;
            padding: 11px 18px;
            border-radius: 7px;
            font-weight: 600;
            font-size: 14px;
            box-sizing: border-box;
            transition: background 0.2s ease;
        }

        .add-btn:hover {
            background: #374151;
        }

        /* TABLE CARD */
        .attendance-card {
            width: 100%;
            max-width: 100%;
            min-width: 0;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.04);
            box-sizing: border-box;
        }

        /* RESPONSIVE TABLE WRAPPER */
        .table-wrapper {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            box-sizing: border-box;
        }

        .attendance-table {
            width: 100%;
            min-width: 900px;
            border-collapse: collapse;
        }

        .attendance-table th {
            background: #f9fafb;
            text-align: left;
            padding: 14px;
            font-size: 12px;
            color: #6b7280;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            white-space: nowrap;
            border-bottom: 1px solid #e5e7eb;
        }

        .attendance-table td {
            padding: 15px 14px;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
            color: #374151;
            vertical-align: top;
        }

        .attendance-table tbody tr:hover {
            background: #fafafa;
        }

        .attendance-table tbody tr:first-child td {
            border-top: none;
        }

        /* EMPLOYEE DETAILS */
        .employee-name {
            font-weight: 600;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .employee-id {
            color: #9ca3af;
            font-size: 12px;
            margin-top: 3px;
            white-space: nowrap;
        }

        /* STATUS BADGES */
        .badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
        }

        .present {
            background: #dcfce7;
            color: #166534;
        }

        .absent {
            background: #fee2e2;
            color: #991b1b;
        }

        .half-day {
            background: #fef3c7;
            color: #92400e;
        }

        .leave {
            background: #dbeafe;
            color: #1e40af;
        }

        /* ACTIONS */
        .actions {
            display: flex;
            align-items: center;
            gap: 12px;
            white-space: nowrap;
        }

        .edit {
            color: #374151;
            text-decoration: none;
            font-weight: 600;
        }

        .edit:hover {
            text-decoration: underline;
        }

        .delete {
            color: #b91c1c;
            text-decoration: none;
            font-weight: 600;
        }

        .delete:hover {
            text-decoration: underline;
        }

        /* EMPTY STATE */
        .empty {
            padding: 50px 20px;
            text-align: center;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .attendance-page {
                padding: 85px 20px 25px;
            }

            .attendance-header {
                align-items: flex-start;
            }

            .attendance-header h1 {
                font-size: 25px;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
                max-width: calc(100% - 220px);
            }

            .attendance-page {
                padding: 80px 12px 20px;
            }

            .attendance-header {
                flex-direction: column;
                align-items: stretch;
                gap: 14px;
            }

            .attendance-header h1 {
                font-size: 23px;
            }

            .add-btn {
                align-self: flex-start;
            }

            .attendance-table th,
            .attendance-table td {
                padding: 12px 10px;
            }

            .empty {
                padding: 40px 16px;
            }
        }
    </style>
</head>

<body>
    <div class="app-layout">

   <%@ include file="../sidebar.jspf" %>
        <div class="main-content">
        
        <%@ include file="../topbar.jspf" %>


            <main class="attendance-page content-layout">

                <div class="attendance-container">

                    <!-- PAGE HEADER -->
                    <div class="attendance-header">

                        <div class="attendance-header-content">
                            <h1>Attendance Management</h1>

                            <div class="attendance-subtitle">
                                Track employee attendance and working hours.
                            </div>
                        </div>

                        <a class="add-btn"
                           href="${pageContext.request.contextPath}/attendance?action=add">
                            + Mark Attendance
                        </a>

                    </div>

                    <!-- ATTENDANCE TABLE CARD -->
                    <div class="attendance-card">

                        <% if (attendanceList == null || attendanceList.isEmpty()) { %>

                            <div class="empty">
                                No attendance records found.
                            </div>

                        <% } else { %>

                            <div class="table-wrapper">

                                <table class="attendance-table">

                                    <thead>
                                        <tr>
                                            <th>Employee</th>
                                            <th>Date</th>
                                            <th>Status</th>
                                            <th>Check In</th>
                                            <th>Check Out</th>
                                            <th>Notes</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <% for (Attendance attendance : attendanceList) {

                                            Employee employee = attendance.getEmployee();

                                            String status = attendance.getStatus();

                                            String statusClass = status == null
                                                    ? ""
                                                    : status.toLowerCase()
                                                            .replace("_", "-");
                                        %>

                                            <tr>

                                                <!-- EMPLOYEE -->
                                                <td>
                                                    <div class="employee-name">
                                                        <%= employee != null
                                                                ? ((employee.getFirstName() != null
                                                                    ? employee.getFirstName()
                                                                    : "")
                                                                    + " "
                                                                    + (employee.getLastName() != null
                                                                        ? employee.getLastName()
                                                                        : "")).trim()
                                                                : "Unknown Employee" %>
                                                    </div>

                                                    <div class="employee-id">
                                                        ID:
                                                        <%= employee != null
                                                                ? employee.getId()
                                                                : "-" %>
                                                    </div>
                                                </td>

                                                <!-- DATE -->
                                                <td>
                                                    <%= attendance.getAttendanceDate() != null
                                                            ? attendance.getAttendanceDate()
                                                            : "-" %>
                                                </td>

                                                <!-- STATUS -->
                                                <td>
                                                    <span class="badge <%= statusClass %>">
                                                        <%= status != null && !status.trim().isEmpty()
                                                                ? status
                                                                : "-" %>
                                                    </span>
                                                </td>

                                                <!-- CHECK IN -->
                                                <td>
                                                    <%= attendance.getCheckIn() != null
                                                            ? attendance.getCheckIn()
                                                            : "-" %>
                                                </td>

                                                <!-- CHECK OUT -->
                                                <td>
                                                    <%= attendance.getCheckOut() != null
                                                            ? attendance.getCheckOut()
                                                            : "-" %>
                                                </td>

                                                <!-- NOTES -->
                                                <td>
                                                    <%= attendance.getNotes() != null
                                                            && !attendance.getNotes().trim().isEmpty()
                                                            ? attendance.getNotes()
                                                            : "-" %>
                                                </td>

                                                <!-- ACTIONS -->
                                                <td>
                                                    <div class="actions">

                                                        <a class="edit"
                                                           href="${pageContext.request.contextPath}/attendance?action=edit&id=<%= attendance.getId() %>">
                                                            Edit
                                                        </a>

                                                        <a class="delete"
                                                           href="${pageContext.request.contextPath}/attendance?action=delete&id=<%= attendance.getId() %>"
                                                           onclick="return confirm('Delete this attendance record?');">
                                                            Delete
                                                        </a>

                                                    </div>
                                                </td>

                                            </tr>

                                        <% } %>

                                    </tbody>

                                </table>

                            </div>

                        <% } %>

                    </div>

                </div>

            </main>
        </div>
    </div>
</body>
</html>
