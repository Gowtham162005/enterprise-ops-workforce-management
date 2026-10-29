<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.LeaveRequest" %>

<%
    List<LeaveRequest> leaveRequests =
        (List<LeaveRequest>) request.getAttribute("leaveRequests");

    String username = (String) request.getAttribute("username");

    String success = (String) session.getAttribute("leaveSuccess");
    String error = (String) session.getAttribute("leaveError");

    session.removeAttribute("leaveSuccess");
    session.removeAttribute("leaveError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>My Leave Requests</title>

<style>
    * { box-sizing: border-box; }

    body {
        margin: 0;
        font-family: Arial, sans-serif;
        background: #f4f7fb;
        color: #263238;
    }

    header {
        background: #17365d;
        color: white;
        padding: 24px 35px;
    }

    header h1 { margin: 0 0 8px; }

    header p { margin: 0; color: #dce6f2; }

    .container {
        max-width: 1100px;
        margin: 28px auto;
        padding: 0 18px;
    }

    .back {
        display: inline-block;
        margin-bottom: 20px;
        color: #174ea6;
        text-decoration: none;
        font-weight: bold;
    }

    .card {
        background: white;
        padding: 25px;
        margin-bottom: 25px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0,0,0,.07);
    }

    h2 { color: #17365d; margin-top: 0; }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .field {
        display: flex;
        flex-direction: column;
        gap: 7px;
    }

    .full { grid-column: 1 / -1; }

    label { font-weight: bold; font-size: 14px; }

    input, select, textarea {
        width: 100%;
        padding: 11px;
        border: 1px solid #cbd5e1;
        border-radius: 6px;
        font: inherit;
    }

    textarea { min-height: 100px; resize: vertical; }

    button {
        background: #176b45;
        color: white;
        border: 0;
        border-radius: 6px;
        padding: 12px 20px;
        font-size: 15px;
        font-weight: bold;
        cursor: pointer;
    }

    button:hover { background: #125536; }

    .message {
        padding: 13px 16px;
        margin-bottom: 18px;
        border-radius: 6px;
    }

    .success { background: #d4edda; color: #155724; }
    .error { background: #f8d7da; color: #721c24; }

    .table-wrapper { overflow-x: auto; }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    th, td {
        text-align: left;
        padding: 13px;
        border-bottom: 1px solid #e6eaf0;
    }

    th { background: #edf2f8; color: #17365d; }

    .status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 15px;
        background: #fff1c2;
        color: #765500;
        font-size: 12px;
        font-weight: bold;
    }

    .empty { text-align: center; color: #687789; padding: 25px; }

    footer {
        text-align: center;
        color: #7b8794;
        padding: 20px;
    }

    @media (max-width: 600px) {
        .form-grid { grid-template-columns: 1fr; }
        .full { grid-column: auto; }
        .card { padding: 18px; }
        header { padding: 22px 18px; }
    }
</style>
</head>

<body>

<header>
    <h1>Apply for Leave</h1>
    <p>Welcome, <%= username == null ? "Employee" : username %></p>
</header>

<div class="container">

    <a class="back"
       href="<%= request.getContextPath() %>/employee/dashboard">
       &larr; Back to Dashboard
    </a>

    <% if (success != null) { %>
        <div class="message success"><%= success %></div>
    <% } %>

    <% if (error != null) { %>
        <div class="message error"><%= error %></div>
    <% } %>

    <div class="card">
        <h2>New Leave Request</h2>

        <form method="post"
              action="<%= request.getContextPath() %>/employee/leaves">

            <div class="form-grid">

                <div class="field">
                    <label for="leaveType">Leave Type</label>
                    <select id="leaveType" name="leaveType" required>
                        <option value="">-- Select leave type --</option>
                        <option value="CASUAL">Casual Leave</option>
                        <option value="SICK">Sick Leave</option>
                        <option value="ANNUAL">Annual Leave</option>
                        <option value="MATERNITY">Maternity Leave</option>
                        <option value="PATERNITY">Paternity Leave</option>
                        <option value="UNPAID">Unpaid Leave</option>
                    </select>
                </div>

                <div class="field">
                    <label for="startDate">Start Date</label>
                    <input type="date"
                           id="startDate"
                           name="startDate"
                           required>
                </div>

                <div class="field">
                    <label for="endDate">End Date</label>
                    <input type="date"
                           id="endDate"
                           name="endDate"
                           required>
                </div>

                <div class="field full">
                    <label for="reason">Reason</label>
                    <textarea id="reason"
                              name="reason"
                              maxlength="500"
                              placeholder="Enter the reason for your leave"
                              required></textarea>
                </div>

                <div class="field full">
                    <button type="submit">Submit Leave Request</button>
                </div>

            </div>
        </form>
    </div>

    <div class="card">
        <h2>My Leave History</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>Leave Type</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Reason</th>
                        <th>Status</th>
                    </tr>
                </thead>

                <tbody>
                <% if (leaveRequests != null && !leaveRequests.isEmpty()) {
                       for (LeaveRequest leave : leaveRequests) {
                %>
                    <tr>
                        <td><%= leave.getLeaveType() %></td>
                        <td><%= leave.getStartDate() %></td>
                        <td><%= leave.getEndDate() %></td>
                        <td><%= leave.getReason() == null
                            ? "-" : leave.getReason() %></td>
                        <td>
                            <span class="status">
                                <%= leave.getStatus() %>
                            </span>
                        </td>
                    </tr>
                <%     }
                   } else { %>
                    <tr>
                        <td colspan="5" class="empty">
                            You have not submitted any leave requests yet.
                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<footer>Enterprise Operations System &copy; 2026</footer>

</body>
</html>