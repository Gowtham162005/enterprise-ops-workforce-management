
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Team - Enterprise Operations</title>

    <style>
        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            min-height: 100%;
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        body {
            overflow-x: hidden;
        }

        /* Main page layout */
        .manager-content {
            margin-left: 240px;
            width: calc(100% - 240px);
            min-height: 100vh;

            /* Keep content below the fixed shared topbar */
            padding: 100px 30px 35px;
        }

        .page-header {
            margin: 0 0 25px;
        }

        .page-header h1 {
            margin: 0 0 8px;
            font-size: 28px;
            font-weight: 700;
            color: #111827;
        }

        .page-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }

        /* Team panel */
        .team-panel {
            width: 100%;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .team-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            margin-bottom: 20px;
        }

        .team-header h2 {
            margin: 0;
            font-size: 19px;
            color: #111827;
        }

        .team-count {
            color: #6b7280;
            font-size: 14px;
        }

        /* Responsive table */
        .table-container {
            width: 100%;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        table {
            width: 100%;
            min-width: 750px;
            border-collapse: collapse;
        }

        thead {
            background: #f9fafb;
        }

        th {
            text-align: left;
            padding: 14px 12px;
            font-size: 12px;
            color: #6b7280;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            white-space: nowrap;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 15px 12px;
            font-size: 14px;
            line-height: 1.5;
            color: #374151;
            border-bottom: 1px solid #f0f0f0;
            overflow-wrap: anywhere;
        }

        tbody tr:hover {
            background: #fafafa;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .employee-name {
            font-weight: 600;
            color: #111827;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            background: #ecfdf5;
            color: #047857;
            white-space: nowrap;
        }

        .manager-badge {
            display: inline-block;
            margin-left: 6px;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            background: #eef2ff;
            color: #4338ca;
            white-space: nowrap;
        }

        .no-team {
            text-align: center;
            padding: 45px 20px;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
        }

        /* Tablet */
        @media (max-width: 1100px) {
            .manager-content {
                padding: 100px 24px 30px;
            }

            .team-panel {
                padding: 18px;
            }
        }

        /* Mobile */
        @media (max-width: 768px) {
            .manager-content {
                margin-left: 0;
                width: 100%;
                padding: 90px 15px 25px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .team-panel {
                padding: 16px;
                border-radius: 10px;
            }

            .team-header {
                align-items: flex-start;
                flex-direction: column;
                gap: 8px;
            }
        }

        @media (max-width: 400px) {
            .manager-content {
                padding-left: 10px;
                padding-right: 10px;
            }

            .team-panel {
                padding: 12px;
            }
        }
    </style>
</head>

<body>

    <%@ include file="/WEB-INF/views/sidebar.jspf" %>
    <%@ include file="/WEB-INF/views/topbar.jspf" %>

    <main class="manager-content">

        <section class="page-header">
            <h1>My Team</h1>
            <p>View employees assigned to you.</p>
        </section>

        <section class="team-panel">

            <div class="team-header">
                <h2>My Team</h2>

                <span class="team-count">
                    <c:choose>
                        <c:when test="${not empty employees}">
                            ${employees.size()} team member(s)
                        </c:when>
                        <c:otherwise>
                            0 team member(s)
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>

            <c:choose>

                <c:when test="${not empty employees}">

                    <div class="table-container">
                        <table>
                            <thead>
                                <tr>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Email</th>
                                    <th>Job Title</th>
                                    <th>Department</th>
                                    <th>Status</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="employee" items="${employees}">
                                    <tr>

                                        <td>
                                            <c:out value="${employee.employeeCode}" default="—" />
                                        </td>

                                        <td>
                                            <span class="employee-name">
                                                <c:out value="${employee.firstName}" default="" />

                                                <c:if test="${not empty employee.lastName}">
                                                    <c:out value="${employee.lastName}" />
                                                </c:if>
                                            </span>

                                            <c:if test="${employee.id == managerEmployeeId}">
                                                <span class="manager-badge">MANAGER</span>
                                            </c:if>
                                        </td>

                                        <td>
                                            <c:out value="${employee.email}" default="—" />
                                        </td>

                                        <td>
                                            <c:out value="${employee.jobTitle}" default="—" />
                                        </td>

                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty employee.department}">
                                                    <c:out value="${employee.department.name}" />
                                                </c:when>
                                                <c:otherwise>—</c:otherwise>
                                            </c:choose>
                                        </td>

                                        <td>
                                            <span class="status">
                                                <c:out value="${employee.status}" default="Unknown" />
                                            </span>
                                        </td>

                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="no-team">
                        No employees are currently assigned to you.
                    </div>
                </c:otherwise>

            </c:choose>

        </section>

    </main>

</body>
</html>
