
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Management</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        .app-layout {
            width: 100%;
            min-height: 100vh;
        }

        .main-content {
            margin-left: 240px;
            width: calc(100% - 240px);
            min-width: 0;
            min-height: 100vh;
            position: relative;
            box-sizing: border-box;
        }

        .leave-page {
            width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        .content {
            width: 100%;
            max-width: 1400px;
            min-width: 0;
            margin: 0 auto;
        }

        .page-header {
            width: 100%;
            margin-bottom: 28px;
        }

        .page-header h1 {
            margin: 0 0 8px;
            color: #111827;
            font-size: 30px;
            line-height: 1.25;
            font-weight: 700;
        }

        .page-header p {
            margin: 0;
            color: #6b7280;
            font-size: 15px;
            line-height: 1.5;
        }

        .admin-label {
            display: inline-block;
            margin-left: 8px;
            padding: 5px 9px;
            border-radius: 6px;
            background: #eef2ff;
            color: #4338ca;
            font-size: 11px;
            font-weight: 700;
            vertical-align: middle;
        }

        .summary {
            width: 100%;
            margin-bottom: 25px;
        }

        .summary-card {
            width: 220px;
            max-width: 100%;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 18px 22px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            box-sizing: border-box;
        }

        .summary-label {
            margin-bottom: 8px;
            color: #6b7280;
            font-size: 13px;
        }

        .summary-value {
            color: #111827;
            font-size: 27px;
            font-weight: 700;
        }

        .card {
            width: 100%;
            min-width: 0;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .card-header {
            width: 100%;
            padding: 22px 24px;
            border-bottom: 1px solid #e5e7eb;
            box-sizing: border-box;
        }

        .card-header h2 {
            margin: 0 0 6px;
            color: #111827;
            font-size: 19px;
            font-weight: 700;
        }

        .card-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        .table-wrapper {
            width: 100%;
            min-width: 0;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .leave-table {
            width: 100%;
            min-width: 1000px;
            border-collapse: collapse;
            table-layout: fixed;
        }

        .leave-table th {
            padding: 14px 10px;
            background: #f8fafc;
            border-bottom: 1px solid #e5e7eb;
            color: #475569;
            font-size: 11px;
            font-weight: 700;
            text-align: left;
            text-transform: uppercase;
            letter-spacing: 0.2px;
            overflow-wrap: anywhere;
        }

        .leave-table td {
            padding: 16px 10px;
            border-bottom: 1px solid #eef0f3;
            color: #374151;
            font-size: 12px;
            vertical-align: middle;
            overflow-wrap: anywhere;
        }

        .leave-table tbody tr:last-child td {
            border-bottom: none;
        }

        .leave-table tbody tr:hover {
            background: #fafafa;
        }

        .leave-table th:nth-child(1),
        .leave-table td:nth-child(1) { width: 17%; }

        .leave-table th:nth-child(2),
        .leave-table td:nth-child(2) { width: 11%; }

        .leave-table th:nth-child(3),
        .leave-table td:nth-child(3) { width: 11%; }

        .leave-table th:nth-child(4),
        .leave-table td:nth-child(4) { width: 11%; }

        .leave-table th:nth-child(5),
        .leave-table td:nth-child(5) { width: 20%; }

        .leave-table th:nth-child(6),
        .leave-table td:nth-child(6) { width: 12%; }

        .leave-table th:nth-child(7),
        .leave-table td:nth-child(7) { width: 18%; }

        .employee-name {
            display: block;
            margin-bottom: 4px;
            color: #111827;
            font-size: 13px;
            font-weight: 700;
        }

        .employee-id {
            display: block;
            color: #6b7280;
            font-size: 10px;
        }

        .reason {
            color: #4b5563;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .status {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            max-width: 100%;
            padding: 5px 8px;
            border-radius: 20px;
            font-size: 10px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status-pending {
            background: #fff7ed;
            color: #c2410c;
        }

        .status-approved {
            background: #ecfdf5;
            color: #047857;
        }

        .status-rejected {
            background: #fef2f2;
            color: #b91c1c;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 6px;
            align-items: center;
        }

        .action-form {
            margin: 0;
        }

        .btn {
            min-width: 65px;
            min-height: 30px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border: none;
            border-radius: 6px;
            padding: 7px 10px;
            font-size: 11px;
            font-weight: 700;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            box-sizing: border-box;
        }

        .btn-approve {
            background: #ecfdf5;
            color: #047857;
        }

        .btn-reject {
            background: #fff1f2;
            color: #be123c;
        }

        .waiting {
            color: #6b7280;
            font-size: 11px;
        }

        .empty-state {
            width: 100%;
            padding: 60px 20px;
            text-align: center;
            box-sizing: border-box;
        }

        .empty-state-title {
            margin-bottom: 7px;
            color: #374151;
            font-size: 17px;
            font-weight: 700;
        }

        .empty-state-text {
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        @media (max-width: 768px) {
            .leave-page {
                padding: 85px 16px 25px;
            }

            .page-header h1 {
                font-size: 25px;
            }

            .card-header {
                padding: 20px;
            }

            .leave-table {
                min-width: 950px;
            }
        }

        @media (max-width: 600px) {
            .leave-page {
                padding: 80px 12px 20px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .page-header p {
                font-size: 13px;
            }

            .summary-card {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="app-layout">

    <%@ include file="../sidebar.jspf" %>

    <div class="main-content">

        <%@ include file="../topbar.jspf" %>

        <main class="leave-page">
            <div class="content">

                <div class="page-header">
                    <h1>
                        Leave Management
                        <c:if test="${sessionScope.role eq 'ADMIN'}">
                            <span class="admin-label">Admin</span>
                        </c:if>
                    </h1>

                    <p>Manage employee leave requests and approvals.</p>
                </div>

                <div class="summary">
                    <div class="summary-card">
                        <div class="summary-label">Pending Requests</div>
                        <div class="summary-value">
                            <c:set var="pendingCount" value="0" />

                            <c:forEach var="leave" items="${leaveRequests}">
                                <c:if test="${leave.status eq 'PENDING'
                                    or leave.status eq 'PENDING_MANAGER'
                                    or leave.status eq 'PENDING_ADMIN'}">
                                    <c:set var="pendingCount"
                                           value="${pendingCount + 1}" />
                                </c:if>
                            </c:forEach>

                            <c:out value="${pendingCount}" />
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h2>Employee Leave Requests</h2>
                        <p>View leave requests and their approval status.</p>
                    </div>

                    <div class="table-wrapper">
                        <c:choose>
                            <c:when test="${not empty leaveRequests}">

                                <table class="leave-table">
                                    <thead>
                                    <tr>
                                        <th>Employee</th>
                                        <th>Leave Type</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Reason</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:forEach var="leave" items="${leaveRequests}">
                                        <tr>
                                            <td>
                                                <span class="employee-name">
                                                    <c:out value="${leave.employee.firstName}" />
                                                    <c:out value="${leave.employee.lastName}" />
                                                </span>
                                                <span class="employee-id">
                                                    Employee #
                                                    <c:out value="${leave.employee.id}" />
                                                </span>
                                            </td>

                                            <td><c:out value="${leave.leaveType}" /></td>
                                            <td><c:out value="${leave.startDate}" /></td>
                                            <td><c:out value="${leave.endDate}" /></td>

                                            <td>
                                                <div class="reason">
                                                    <c:choose>
                                                        <c:when test="${not empty leave.reason}">
                                                            <c:out value="${leave.reason}" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${leave.status eq 'APPROVED'}">
                                                        <span class="status status-approved">APPROVED</span>
                                                    </c:when>

                                                    <c:when test="${leave.status eq 'REJECTED'}">
                                                        <span class="status status-rejected">REJECTED</span>
                                                    </c:when>

                                                    <c:when test="${leave.status eq 'PENDING'
                                                        or leave.status eq 'PENDING_MANAGER'
                                                        or leave.status eq 'PENDING_ADMIN'}">
                                                        <span class="status status-pending">
                                                            <c:out value="${leave.status}" />
                                                        </span>
                                                    </c:when>

                                                    <c:otherwise>
                                                        <span class="status">
                                                            <c:out value="${leave.status}" />
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <div class="actions">

                                                    <%-- ADMIN: final approval only --%>
                                                    <c:if test="${sessionScope.role eq 'ADMIN'
                                                        and leave.status eq 'PENDING_ADMIN'}">

                                                        <form class="action-form"
                                                              method="post"
                                                              action="${pageContext.request.contextPath}/leaves">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="id" value="${leave.id}">
                                                            <button class="btn btn-approve" type="submit">
                                                                Approve
                                                            </button>
                                                        </form>

                                                        <form class="action-form"
                                                              method="post"
                                                              action="${pageContext.request.contextPath}/leaves">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="id" value="${leave.id}">
                                                            <button class="btn btn-reject" type="submit">
                                                                Reject
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <%-- MANAGER: first-stage approval --%>
                                                    <c:if test="${sessionScope.role eq 'MANAGER'
                                                        and (leave.status eq 'PENDING_MANAGER'
                                                        or leave.status eq 'PENDING')}">

                                                        <form class="action-form"
                                                              method="post"
                                                              action="${pageContext.request.contextPath}/leaves">
                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="id" value="${leave.id}">
                                                            <button class="btn btn-approve" type="submit">
                                                                Approve
                                                            </button>
                                                        </form>

                                                        <form class="action-form"
                                                              method="post"
                                                              action="${pageContext.request.contextPath}/leaves">
                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="id" value="${leave.id}">
                                                            <button class="btn btn-reject" type="submit">
                                                                Reject
                                                            </button>
                                                        </form>
                                                    </c:if>

                                                    <%-- Explain why there are no actions --%>
                                                    <c:if test="${leave.status eq 'PENDING_MANAGER'
                                                        and sessionScope.role eq 'ADMIN'}">
                                                        <span class="waiting">Awaiting manager</span>
                                                    </c:if>

                                                    <c:if test="${leave.status eq 'PENDING_ADMIN'
                                                        and sessionScope.role eq 'MANAGER'}">
                                                        <span class="waiting">Awaiting admin</span>
                                                    </c:if>

                                                    <c:if test="${leave.status eq 'PENDING'
                                                        and sessionScope.role eq 'ADMIN'}">
                                                        <span class="waiting">Manager review required</span>
                                                    </c:if>

                                                    <c:if test="${leave.status eq 'APPROVED'
                                                        or leave.status eq 'REJECTED'}">
                                                        <span class="waiting">No action required</span>
                                                    </c:if>

                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>

                            </c:when>

                            <c:otherwise>
                                <div class="empty-state">
                                    <div class="empty-state-title">No Leave Requests</div>
                                    <div class="empty-state-text">
                                        There are currently no leave requests to display.
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>
</body>
</html>
