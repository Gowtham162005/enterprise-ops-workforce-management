<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Team Attendance - Enterprise Operations</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        .main-content {
            margin-left: 240px;
            width: calc(100% - 240px);
            min-height: 100vh;
            padding: 90px 30px 30px 30px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin: 0 0 8px 0;
            font-size: 28px;
            color: #111827;
        }

        .page-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        .filter-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .filter-form {
            display: flex;
            align-items: flex-end;
            gap: 15px;
            flex-wrap: wrap;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .form-group input {
            min-width: 190px;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font-size: 14px;
            outline: none;
        }

        .form-group input:focus {
            border-color: #2563eb;
        }

        .btn {
            border: none;
            border-radius: 7px;
            padding: 10px 18px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #e5e7eb;
            color: #374151;
        }

        .btn-secondary:hover {
            background: #d1d5db;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 18px;
            margin-bottom: 25px;
        }

        .summary-card {
            background: #ffffff;
            border-radius: 12px;
            padding: 20px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .summary-label {
            color: #6b7280;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 10px;
        }

        .summary-value {
            font-size: 28px;
            font-weight: 700;
            color: #111827;
        }

        .summary-card.present {
            border-left: 4px solid #16a34a;
        }

        .summary-card.absent {
            border-left: 4px solid #dc2626;
        }

        .summary-card.half-day {
            border-left: 4px solid #f59e0b;
        }

        .summary-card.leave {
            border-left: 4px solid #7c3aed;
        }

        .table-card {
            background: #ffffff;
            border-radius: 12px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .table-header {
            padding: 20px;
            border-bottom: 1px solid #e5e7eb;
        }

        .table-header h2 {
            margin: 0 0 6px 0;
            font-size: 19px;
            color: #111827;
        }

        .table-header p {
            margin: 0;
            color: #6b7280;
            font-size: 13px;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 900px;
        }

        th {
            background: #f9fafb;
            padding: 13px 15px;
            text-align: left;
            font-size: 12px;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 15px;
            border-bottom: 1px solid #f0f1f3;
            font-size: 14px;
            color: #374151;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .employee-name {
            font-weight: 600;
            color: #111827;
        }

        .employee-id {
            margin-top: 3px;
            font-size: 12px;
            color: #9ca3af;
        }

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }

        .status-present {
            background: #dcfce7;
            color: #166534;
        }

        .status-absent {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-half-day {
            background: #fef3c7;
            color: #92400e;
        }

        .status-leave {
            background: #ede9fe;
            color: #5b21b6;
        }

        .status-default {
            background: #e5e7eb;
            color: #374151;
        }

        .time-value {
            font-weight: 600;
            color: #374151;
        }

        .empty-state {
            padding: 55px 20px;
            text-align: center;
            color: #6b7280;
        }

        .empty-state h3 {
            margin: 0 0 8px 0;
            color: #374151;
            font-size: 18px;
        }

        .empty-state p {
            margin: 0;
            font-size: 14px;
        }

        .selected-date {
            margin-top: 6px;
            color: #2563eb;
            font-size: 13px;
            font-weight: 600;
        }

        @media (max-width: 1100px) {
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                width: 100%;
                padding: 80px 15px 20px 15px;
            }

            .page-header {
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .filter-form {
                align-items: stretch;
            }

            .form-group input {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<%@ include file="/WEB-INF/views/sidebar.jspf" %>
<%@ include file="/WEB-INF/views/topbar.jspf" %>
<div class="main-content">

    <div class="page-header">
        <div>
            <h1>Team Attendance</h1>
            <p>View attendance records for employees assigned to you.</p>

            <c:if test="${not empty selectedDate}">
                <div class="selected-date">
                    Selected Date: ${selectedDate}
                </div>
            </c:if>
        </div>
    </div>

    <div class="filter-card">
        <form method="get"
              action="${pageContext.request.contextPath}/manager/attendance"
              class="filter-form">

            <div class="form-group">
                <label for="date">Attendance Date</label>

                <input type="date"
                       id="date"
                       name="date"
                       value="${selectedDate}">
            </div>

            <button type="submit" class="btn btn-primary">
                Filter
            </button>

            <a href="${pageContext.request.contextPath}/manager/attendance"
               class="btn btn-secondary">
                All Records
            </a>

        </form>
    </div>

    <div class="summary-grid">

        <div class="summary-card present">
            <div class="summary-label">Present</div>
            <div class="summary-value">
                ${presentCount}
            </div>
        </div>

        <div class="summary-card absent">
            <div class="summary-label">Absent</div>
            <div class="summary-value">
                ${absentCount}
            </div>
        </div>

        <div class="summary-card half-day">
            <div class="summary-label">Half Day</div>
            <div class="summary-value">
                ${halfDayCount}
            </div>
        </div>

        <div class="summary-card leave">
            <div class="summary-label">On Leave</div>
            <div class="summary-value">
                ${leaveCount}
            </div>
        </div>

    </div>

    <div class="table-card">

        <div class="table-header">
            <h2>Team Attendance Records</h2>
            <p>
                Only attendance records belonging to your team are displayed.
            </p>
        </div>

        <c:choose>

            <c:when test="${empty attendanceList}">

                <div class="empty-state">
                    <h3>No attendance records found</h3>
                    <p>
                        There are no attendance records available for your team
                        for the selected date.
                    </p>
                </div>

            </c:when>

            <c:otherwise>

                <div class="table-wrapper">

                    <table>

                        <thead>
                            <tr>
                                <th>Employee</th>
                                <th>Date</th>
                                <th>Check In</th>
                                <th>Check Out</th>
                                <th>Working Hours</th>
                                <th>Status</th>
                                <th>Notes</th>
                            </tr>
                        </thead>

                        <tbody>

                            <c:forEach var="attendance"
                                       items="${attendanceList}">

                                <tr>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty attendance.employee}">
                                                <div class="employee-name">
                                                    ${attendance.employee.firstName}
                                                    ${attendance.employee.lastName}
                                                </div>

                                                <div class="employee-id">
                                                    Employee #${attendance.employee.id}
                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <span>Unknown Employee</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        ${attendance.attendanceDate}
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty attendance.checkIn}">
                                                ${attendance.checkIn}
                                            </c:when>

                                            <c:otherwise>
                                                —
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty attendance.checkOut}">
                                                ${attendance.checkOut}
                                            </c:when>

                                            <c:otherwise>
                                                —
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <span class="time-value">
                                            ${attendance.workingHours}
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>

                                            <c:when test="${attendance.status eq 'PRESENT'}">
                                                <span class="status-badge status-present">
                                                    PRESENT
                                                </span>
                                            </c:when>

                                            <c:when test="${attendance.status eq 'ABSENT'}">
                                                <span class="status-badge status-absent">
                                                    ABSENT
                                                </span>
                                            </c:when>

                                            <c:when test="${attendance.status eq 'HALF_DAY'}">
                                                <span class="status-badge status-half-day">
                                                    HALF DAY
                                                </span>
                                            </c:when>

                                            <c:when test="${attendance.status eq 'LEAVE'}">
                                                <span class="status-badge status-leave">
                                                    LEAVE
                                                </span>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="status-badge status-default">
                                                    ${attendance.status}
                                                </span>
                                            </c:otherwise>

                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty attendance.notes}">
                                                ${attendance.notes}
                                            </c:when>

                                            <c:otherwise>
                                                —
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                </tr>

                            </c:forEach>

                        </tbody>

                    </table>

                </div>

            </c:otherwise>

        </c:choose>

    </div>

</div>

</body>
</html>