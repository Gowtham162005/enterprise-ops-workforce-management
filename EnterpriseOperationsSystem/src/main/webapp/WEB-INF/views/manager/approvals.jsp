<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Leave Approvals</title>


<style>
    * {
        box-sizing: border-box;
    }

    html,
    body {
        margin: 0;
        padding: 0;
        width: 100%;
        min-height: 100vh;
        font-family: Arial, Helvetica, sans-serif;
        background: #f5f7fb;
        color: #1f2937;
        overflow-x: hidden;
    }

    body {
        min-height: 100vh;
    }

    .page {
        width: 100%;
        min-height: 100vh;
    }

    .main-content {
        width: calc(100% - 240px);
        min-width: 0;
        min-height: 100vh;
        margin-left: 240px;
        padding: 95px 30px 50px;
    }

    .page-content {
        width: min(1400px, 100%);
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
    }

    .stats {
        width: 100%;
        display: grid;
        grid-template-columns: repeat(3, minmax(0, 1fr));
        gap: 20px;
        margin-bottom: 28px;
    }

    .stat-card {
        width: 100%;
        min-width: 0;
        background: #ffffff;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        padding: 22px 24px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
    }

    .stat-title {
        margin-bottom: 9px;
        color: #6b7280;
        font-size: 14px;
    }

    .stat-value {
        color: #111827;
        font-size: 28px;
        font-weight: 700;
    }

    .table-card {
        width: 100%;
        min-width: 0;
        background: #ffffff;
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        overflow: hidden;
    }

    .table-header {
        width: 100%;
        padding: 22px 24px;
        border-bottom: 1px solid #e5e7eb;
    }

    .table-header h2 {
        margin: 0 0 6px;
        color: #111827;
        font-size: 19px;
        font-weight: 700;
    }

    .table-header p {
        margin: 0;
        color: #6b7280;
        font-size: 14px;
    }

    .table-container {
        width: 100%;
        min-width: 0;
        overflow-x: auto;
    }

    table {
        width: 100%;
        min-width: 950px;
        border-collapse: collapse;
        table-layout: fixed;
    }

    th {
        padding: 14px 10px;
        background: #f8fafc;
        border-bottom: 1px solid #e5e7eb;
        color: #475569;
        font-size: 10px;
        font-weight: 700;
        text-align: left;
        text-transform: uppercase;
        letter-spacing: 0.2px;
        overflow-wrap: anywhere;
        word-break: break-word;
    }

    td {
        padding: 16px 10px;
        border-bottom: 1px solid #eef0f3;
        color: #374151;
        font-size: 12px;
        vertical-align: middle;
        overflow-wrap: anywhere;
        word-break: break-word;
    }

    tbody tr:last-child td {
        border-bottom: none;
    }

    tbody tr:hover {
        background: #fafafa;
    }

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
        line-height: 1.45;
    }

    .status {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        max-width: 100%;
        padding: 6px 9px;
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
        width: 100%;
        min-width: 0;
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 6px;
    }

    .action-form {
        width: 100%;
        min-width: 0;
        margin: 0;
    }

    .btn {
        width: 100%;
        min-width: 0;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        border: none;
        border-radius: 6px;
        padding: 8px 6px;
        font-size: 10px;
        font-weight: 700;
        cursor: pointer;
        white-space: nowrap;
    }

    .btn-approve {
        background: #16a34a;
        color: #ffffff;
    }

    .btn-approve:hover {
        background: #15803d;
    }

    .btn-reject {
        background: #dc2626;
        color: #ffffff;
    }

    .btn-reject:hover {
        background: #b91c1c;
    }

    .completed {
        display: block;
        color: #9ca3af;
        font-size: 10px;
        line-height: 1.4;
    }

    .empty-state {
        width: 100%;
        padding: 60px 20px;
        text-align: center;
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
    }

    th:nth-child(1),
    td:nth-child(1) {
        width: 17%;
    }

    th:nth-child(2),
    td:nth-child(2) {
        width: 10%;
    }

    th:nth-child(3),
    td:nth-child(3) {
        width: 11%;
    }

    th:nth-child(4),
    td:nth-child(4) {
        width: 11%;
    }

    th:nth-child(5),
    td:nth-child(5) {
        width: 21%;
    }

    th:nth-child(6),
    td:nth-child(6) {
        width: 12%;
    }

    th:nth-child(7),
    td:nth-child(7) {
        width: 18%;
    }

    @media (max-width: 1100px) {
        .main-content {
            padding-left: 20px;
            padding-right: 20px;
        }

        .stats {
            gap: 14px;
        }

        .stat-card {
            padding: 18px;
        }
    }

    @media (max-width: 850px) {
        .main-content {
            width: calc(100% - 240px);
            margin-left: 240px;
            padding: 90px 15px 30px;
        }

        .stats {
            grid-template-columns: 1fr;
            gap: 12px;
        }

        table {
            min-width: 950px;
        }
    }

    @media (max-width: 600px) {
        .main-content {
            width: 100%;
            margin-left: 0;
            padding: 85px 12px 30px;
        }
    }
</style>
```

</head>

<body>
<div class="page">

```
<%@ include file="/WEB-INF/views/sidebar.jspf" %>
<%@ include file="/WEB-INF/views/topbar.jspf" %>

<main class="main-content">
    <div class="page-content">

        <div class="page-header">
            <h1>Leave Approvals</h1>
            <p>Review and manage leave requests from your team.</p>
        </div>

        <!-- Summary cards -->
        <div class="stats">

            <div class="stat-card">
                <div class="stat-title">Pending</div>
                <div class="stat-value">
                    <c:set var="pendingCount" value="0" />

                    <c:forEach var="leave" items="${leaveRequests}">
                        <c:if test="${leave.status eq 'PENDING'
                            or leave.status eq 'PENDING_MANAGER'}">
                            <c:set var="pendingCount"
                                value="${pendingCount + 1}" />
                        </c:if>
                    </c:forEach>

                    ${pendingCount}
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Approved</div>
                <div class="stat-value">
                    <c:set var="approvedCount" value="0" />

                    <c:forEach var="leave" items="${leaveRequests}">
                        <c:if test="${leave.status eq 'APPROVED'}">
                            <c:set var="approvedCount"
                                value="${approvedCount + 1}" />
                        </c:if>
                    </c:forEach>

                    ${approvedCount}
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-title">Rejected</div>
                <div class="stat-value">
                    <c:set var="rejectedCount" value="0" />

                    <c:forEach var="leave" items="${leaveRequests}">
                        <c:if test="${leave.status eq 'REJECTED'}">
                            <c:set var="rejectedCount"
                                value="${rejectedCount + 1}" />
                        </c:if>
                    </c:forEach>

                    ${rejectedCount}
                </div>
            </div>

        </div>

        <!-- Leave requests table -->
        <div class="table-card">

            <div class="table-header">
                <h2>Team Leave Requests</h2>
                <p>Only employees assigned to you are displayed here.</p>
            </div>

            <div class="table-container">

                <c:choose>
                    <c:when test="${not empty leaveRequests}">

                        <table>
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
                                                Employee #<c:out value="${leave.employee.id}" />
                                            </span>
                                        </td>

                                        <td>
                                            <c:out value="${leave.leaveType}" />
                                        </td>

                                        <td>
                                            <c:out value="${leave.startDate}" />
                                        </td>

                                        <td>
                                            <c:out value="${leave.endDate}" />
                                        </td>

                                        <td>
                                            <div class="reason">
                                                <c:choose>
                                                    <c:when test="${not empty leave.reason}">
                                                        <c:out value="${leave.reason}" />
                                                    </c:when>
                                                    <c:otherwise>
                                                        -
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </td>

                                        <!-- Status -->
                                        <td>
                                            <c:choose>
                                                <c:when test="${leave.status eq 'PENDING'
                                                    or leave.status eq 'PENDING_MANAGER'
                                                    or leave.status eq 'PENDING_ADMIN'}">
                                                    <span class="status status-pending">
                                                        <c:out value="${leave.status}" />
                                                    </span>
                                                </c:when>

                                                <c:when test="${leave.status eq 'APPROVED'}">
                                                    <span class="status status-approved">
                                                        APPROVED
                                                    </span>
                                                </c:when>

                                                <c:when test="${leave.status eq 'REJECTED'}">
                                                    <span class="status status-rejected">
                                                        REJECTED
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="status">
                                                        <c:out value="${leave.status}" />
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>

                                        <!-- Actions -->
                                        <td>
                                            <c:choose>

                                                <c:when test="${leave.status eq 'PENDING_MANAGER'
                                                    or leave.status eq 'PENDING'}">

                                                    <div class="actions">

                                                        <form class="action-form"
                                                            method="post"
                                                            action="${pageContext.request.contextPath}/manager/approvals">

                                                            <input type="hidden"
                                                                name="action"
                                                                value="approve" />

                                                            <input type="hidden"
                                                                name="id"
                                                                value="${leave.id}" />

                                                            <button type="submit"
                                                                class="btn btn-approve">
                                                                Approve
                                                            </button>
                                                        </form>

                                                        <form class="action-form"
                                                            method="post"
                                                            action="${pageContext.request.contextPath}/manager/approvals">

                                                            <input type="hidden"
                                                                name="action"
                                                                value="reject" />

                                                            <input type="hidden"
                                                                name="id"
                                                                value="${leave.id}" />

                                                            <button type="submit"
                                                                class="btn btn-reject">
                                                                Reject
                                                            </button>
                                                        </form>

                                                    </div>
                                                </c:when>

                                                <c:when test="${leave.status eq 'PENDING_ADMIN'}">
                                                    <span class="completed">
                                                        Awaiting admin review
                                                    </span>
                                                </c:when>

                                                <c:when test="${leave.status eq 'APPROVED'}">
                                                    <span class="completed">
                                                        Already approved
                                                    </span>
                                                </c:when>

                                                <c:when test="${leave.status eq 'REJECTED'}">
                                                    <span class="completed">
                                                        Already rejected
                                                    </span>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="completed">
                                                        No action
                                                    </span>
                                                </c:otherwise>

                                            </c:choose>
                                        </td>

                                    </tr>

                                </c:forEach>
                            </tbody>
                        </table>

                    </c:when>

                    <c:otherwise>
                        <div class="empty-state">
                            <div class="empty-state-title">
                                No Leave Requests
                            </div>

                            <div class="empty-state-text">
                                Your team currently has no leave requests.
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>

    </div>
</main>


</div>
</body>
</html>
