
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.enterpriseops.model.Attendance" %>

<%
    Attendance todayAttendance =
        (Attendance) request.getAttribute("todayAttendance");

@SuppressWarnings("unchecked")
    List<Attendance> attendanceRecords =
        (List<Attendance>) request.getAttribute("attendanceRecords");

    String username = (String) request.getAttribute("username");

    String message = (String) session.getAttribute("attendanceMessage");
    String error = (String) session.getAttribute("attendanceError");

    session.removeAttribute("attendanceMessage");
    session.removeAttribute("attendanceError");

    boolean checkedIn = todayAttendance != null
        && todayAttendance.getCheckIn() != null;

    boolean checkedOut = todayAttendance != null
        && todayAttendance.getCheckOut() != null;
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Attendance</title>

<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f4f7fb;
        color: #263238;
    }

    .header {
        background: #17365d;
        color: white;
        padding: 22px 35px;
    }

    .header h1 {
        margin: 0;
        font-size: 26px;
    }

    .header p {
        margin: 8px 0 0;
        color: #dce6f2;
    }

    .container {
        max-width: 1100px;
        margin: 30px auto;
        padding: 0 20px;
    }

    .top-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #174ea6;
        text-decoration: none;
        font-weight: bold;
    }

    .top-link:hover {
        text-decoration: underline;
    }

    .card {
        background: white;
        padding: 25px;
        margin-bottom: 25px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.07);
    }

    .card h2 {
        margin-top: 0;
        color: #17365d;
    }

    .summary {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
        gap: 18px;
        margin-top: 20px;
    }

    .summary-item {
        background: #f1f5fb;
        padding: 18px;
        border-radius: 8px;
    }

    .summary-item .label {
        color: #65758b;
        font-size: 13px;
        margin-bottom: 10px;
    }

    .summary-item .value {
        font-size: 20px;
        font-weight: bold;
        overflow-wrap: anywhere;
    }

    .actions {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        margin-top: 25px;
    }

    button {
        border: none;
        border-radius: 6px;
        padding: 12px 22px;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
        color: white;
    }

    .checkin {
        background: #198754;
    }

    .checkout {
        background: #0d6efd;
    }

    button:disabled {
        background: #aab2bd;
        cursor: not-allowed;
    }

    .message {
        padding: 13px 16px;
        border-radius: 6px;
        margin-bottom: 18px;
    }

    .success {
        color: #155724;
        background: #d4edda;
    }

    .error {
        color: #721c24;
        background: #f8d7da;
    }

    .table-wrapper {
        width: 100%;
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    th, td {
        padding: 14px 12px;
        text-align: left;
        border-bottom: 1px solid #e6eaf0;
        white-space: nowrap;
    }

    th {
        background: #edf2f8;
        color: #17365d;
    }

    tr:hover td {
        background: #fafcff;
    }

    .status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 15px;
        background: #e1f3e8;
        color: #176b38;
        font-size: 12px;
        font-weight: bold;
    }

    .empty {
        padding: 25px;
        text-align: center;
        color: #687789;
    }

    .footer {
        text-align: center;
        color: #7b8794;
        padding: 20px;
        font-size: 13px;
    }

    @media (max-width: 600px) {
        .header {
            padding: 20px;
        }

        .container {
            padding: 0 12px;
            margin-top: 20px;
        }

        .card {
            padding: 18px;
        }

        .actions {
            flex-direction: column;
        }

        .actions form, .actions button {
            width: 100%;
        }
    }
</style>
</head>

<body>

<div class="header">
    <h1>My Attendance</h1>
    <p>Welcome, <%= username == null ? "Employee" : username %></p>
</div>

<div class="container">

    <a class="top-link"
       href="<%= request.getContextPath() %>/employee/dashboard">
       &larr; Back to Dashboard
    </a>

    <% if (message != null && !message.trim().isEmpty()) { %>
        <div class="message success">
            <%= message %>
        </div>
    <% } %>

    <% if (error != null && !error.trim().isEmpty()) { %>
        <div class="message error">
            <%= error %>
        </div>
    <% } %>

    <div class="card">
        <h2>Today's Attendance</h2>

        <div class="summary">

            <div class="summary-item">
                <div class="label">Date</div>
                <div class="value"><%= LocalDate.now() %></div>
            </div>

            <div class="summary-item">
                <div class="label">Check-in Time</div>
                <div class="value">
                    <%= checkedIn ? todayAttendance.getCheckIn() : "--:--" %>
                </div>
            </div>

            <div class="summary-item">
                <div class="label">Check-out Time</div>
                <div class="value">
                    <%= checkedOut ? todayAttendance.getCheckOut() : "--:--" %>
                </div>
            </div>

            <div class="summary-item">
                <div class="label">Status</div>
                <div class="value">
                    <%= todayAttendance == null
                        ? "NOT MARKED"
                        : todayAttendance.getStatus() %>
                </div>
            </div>

        </div>

        <div class="actions">

            <form method="post"
                  action="<%= request.getContextPath() %>/employee/attendance">
                <input type="hidden" name="action" value="checkIn">

                <button type="submit"
                        class="checkin"
                        <%= checkedIn ? "disabled" : "" %>>
                    Check In
                </button>
            </form>

            <form method="post"
                  action="<%= request.getContextPath() %>/employee/attendance">
                <input type="hidden" name="action" value="checkOut">

                <button type="submit"
                        class="checkout"
                        <%= (!checkedIn || checkedOut) ? "disabled" : "" %>>
                    Check Out
                </button>
            </form>

        </div>

        <p style="color:#687789; font-size:13px; margin-top:18px;">
            Check in when you start work and check out when your workday ends.
        </p>
    </div>

    <div class="card">
        <h2>Attendance History</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Check In</th>
                        <th>Check Out</th>
                        <th>Working Hours</th>
                    </tr>
                </thead>

                <tbody>
                <% if (attendanceRecords != null && !attendanceRecords.isEmpty()) {
                       for (Attendance record : attendanceRecords) {
                %>
                    <tr>
                        <td><%= record.getAttendanceDate() == null
                            ? "-" : record.getAttendanceDate() %></td>

                        <td>
                            <span class="status">
                                <%= record.getStatus() == null
                                    ? "-" : record.getStatus() %>
                            </span>
                        </td>

                        <td><%= record.getCheckIn() == null
                            ? "-" : record.getCheckIn() %></td>

                        <td><%= record.getCheckOut() == null
                            ? "-" : record.getCheckOut() %></td>

                        <td><%= record.getWorkingHours() %></td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="5" class="empty">
                            No attendance records found.
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<div class="footer">
    Enterprise Operations System &copy; 2026
</div>

</body>
</html>
