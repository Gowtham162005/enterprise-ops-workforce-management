
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.enterpriseops.dto.DashboardDTO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%
    DashboardDTO dashboard =
            (DashboardDTO) request.getAttribute("dashboard");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Operations Dashboard</title>

<style>
* {
    box-sizing: border-box;
}

html,
body {
    margin: 0;
    padding: 0;
    min-height: 100vh;
    font-family: Arial, sans-serif;
    background: #f5f6f8;
    color: #1f2937;
}


/* =========================================
   MAIN PAGE
   ========================================= */

.page {
    margin-left: 240px;
    min-height: 100vh;
    min-width: 0;
    box-sizing: border-box;
}

/* =========================================
   DASHBOARD CONTENT
   Shared topbar height: 65px
   ========================================= */

.dashboard-content {
    width: 100%;
    min-width: 0;
    min-height: 100vh;
    padding: 95px 30px 30px;
    box-sizing: border-box;
}

.dashboard-container {
    width: 100%;
    max-width: 1250px;
    margin: 0 auto;
    min-width: 0;
    box-sizing: border-box;
}

/* =========================================
   WELCOME
   ========================================= */

.welcome-section {
    margin-bottom: 25px;
}

.welcome-section h1 {
    margin: 0;
    font-size: 26px;
    font-weight: 700;
    color: #111827;
    overflow-wrap: anywhere;
}

.welcome-section p {
    margin: 7px 0 0;
    color: #6b7280;
    font-size: 14px;
    line-height: 1.5;
}

/* =========================================
   STATISTICS
   ========================================= */

.dashboard-stats {
    display: grid;
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 18px;
    margin-bottom: 25px;
}

.dashboard-stat {
    min-width: 0;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    padding: 20px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}

.stat-label {
    color: #6b7280;
    font-size: 12px;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.4px;
}

.stat-value {
    margin-top: 8px;
    color: #111827;
    font-size: 30px;
    font-weight: 700;
    overflow-wrap: anywhere;
}

.stat-description {
    margin-top: 5px;
    color: #9ca3af;
    font-size: 12px;
}

/* =========================================
   TWO-COLUMN AREA
   ========================================= */

.dashboard-grid {
    display: grid;
    grid-template-columns: minmax(0, 1.7fr) minmax(0, 1fr);
    gap: 20px;
    margin-bottom: 20px;
    min-width: 0;
}

.dashboard-grid > * {
    min-width: 0;
}

/* =========================================
   PANELS
   ========================================= */

.dashboard-panel {
    min-width: 0;
    background: #ffffff;
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}

.dashboard-panel-header {
    padding: 18px 20px;
    border-bottom: 1px solid #e5e7eb;
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
}

.dashboard-panel-header > div {
    min-width: 0;
}

.dashboard-panel-header h2 {
    margin: 0;
    color: #111827;
    font-size: 16px;
}

.dashboard-panel-header p {
    margin: 5px 0 0;
    color: #9ca3af;
    font-size: 12px;
    line-height: 1.5;
}

.dashboard-panel-header a {
    flex-shrink: 0;
    color: #374151;
    text-decoration: none;
    font-size: 12px;
    font-weight: 600;
}

.dashboard-panel-header a:hover {
    text-decoration: underline;
}

.dashboard-panel-body {
    padding: 20px;
    min-width: 0;
}

/* =========================================
   TASK OVERVIEW
   ========================================= */

.task-row {
    margin-bottom: 18px;
}

.task-row:last-child {
    margin-bottom: 0;
}

.task-row-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    margin-bottom: 7px;
}

.task-name {
    color: #374151;
    font-size: 13px;
    font-weight: 600;
}

.task-count {
    color: #6b7280;
    font-size: 12px;
    font-weight: 600;
}

.progress-track {
    width: 100%;
    height: 8px;
    background: #f3f4f6;
    border-radius: 10px;
    overflow: hidden;
}

.progress-bar {
    height: 100%;
    border-radius: 10px;
}

.progress-completed {
    background: #16a34a;
}

.progress-progress {
    background: #2563eb;
}

.progress-todo {
    background: #f59e0b;
}

.progress-blocked {
    background: #dc2626;
}

/* =========================================
   LEAVE MANAGEMENT
   ========================================= */

.leave-summary {
    display: flex;
    flex-direction: column;
    gap: 12px;
}

.leave-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    padding: 13px;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
}

.leave-left {
    display: flex;
    align-items: center;
    gap: 11px;
    min-width: 0;
}

.leave-icon {
    width: 32px;
    height: 32px;
    flex-shrink: 0;
    border-radius: 7px;
    background: #f3f4f6;
    color: #374151;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 12px;
    font-weight: 700;
}

.leave-title {
    font-size: 13px;
    font-weight: 600;
    color: #374151;
}

.leave-subtitle {
    margin-top: 3px;
    color: #9ca3af;
    font-size: 11px;
}

.pending-badge {
    min-width: 28px;
    flex-shrink: 0;
    padding: 5px 8px;
    border-radius: 20px;
    background: #fef3c7;
    color: #92400e;
    text-align: center;
    font-size: 11px;
    font-weight: 700;
}

/* =========================================
   RECENT ACTIVITY
   ========================================= */

.activity-list {
    display: flex;
    flex-direction: column;
}

.activity-item {
    padding: 14px 0;
    border-bottom: 1px solid #f3f4f6;
    display: flex;
    align-items: center;
    gap: 12px;
}

.activity-item:last-child {
    border-bottom: none;
    padding-bottom: 0;
}

.activity-dot {
    width: 8px;
    height: 8px;
    border-radius: 50%;
    background: #9ca3af;
    flex-shrink: 0;
}

.activity-text {
    color: #4b5563;
    font-size: 13px;
    line-height: 1.5;
}

/* =========================================
   QUICK ACTIONS
   ========================================= */

.quick-actions {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
}

.quick-action {
    display: block;
    min-width: 0;
    padding: 13px;
    background: #f9fafb;
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    color: #374151;
    text-decoration: none;
    font-size: 12px;
    font-weight: 600;
    line-height: 1.5;
    overflow-wrap: anywhere;
    transition: background 0.15s ease, border-color 0.15s ease;
}

.quick-action:hover {
    background: #f3f4f6;
    border-color: #d1d5db;
}

/* =========================================
   MANAGER TASK TABLE
   ========================================= */

.manager-tasks-panel {
    margin-bottom: 20px;
}

.task-table-wrapper {
    width: 100%;
    overflow-x: auto;
}

.task-table {
    width: 100%;
    border-collapse: collapse;
    min-width: 800px;
}

.task-table th {
    padding: 12px 15px;
    text-align: left;
    background: #f9fafb;
    border-bottom: 1px solid #e5e7eb;
    color: #6b7280;
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
    letter-spacing: 0.4px;
    white-space: nowrap;
}

.task-table td {
    padding: 14px 15px;
    border-bottom: 1px solid #f3f4f6;
    color: #374151;
    font-size: 13px;
    vertical-align: middle;
}

.task-table tbody tr:hover {
    background: #fafafa;
}

.task-table tbody tr:last-child td {
    border-bottom: none;
}

.task-code {
    font-weight: 700;
    color: #111827;
}

.task-title {
    font-weight: 600;
    color: #374151;
}

.task-project {
    color: #6b7280;
}

.task-status {
    display: inline-block;
    padding: 5px 9px;
    border-radius: 20px;
    font-size: 10px;
    font-weight: 700;
    text-transform: uppercase;
    white-space: nowrap;
}

.status-todo {
    background: #fef3c7;
    color: #92400e;
}

.status-in-progress {
    background: #dbeafe;
    color: #1d4ed8;
}

.status-completed {
    background: #dcfce7;
    color: #166534;
}

.status-blocked {
    background: #fee2e2;
    color: #b91c1c;
}

.status-default {
    background: #f3f4f6;
    color: #4b5563;
}

.priority {
    font-size: 11px;
    font-weight: 700;
    text-transform: uppercase;
}

.priority-high {
    color: #dc2626;
}

.priority-medium {
    color: #d97706;
}

.priority-low {
    color: #16a34a;
}

.task-progress-wrapper {
    display: flex;
    align-items: center;
    gap: 8px;
    min-width: 120px;
}

.task-progress-track {
    flex: 1;
    height: 7px;
    background: #f3f4f6;
    border-radius: 10px;
    overflow: hidden;
}

.task-progress-bar {
    height: 100%;
    background: #2563eb;
    border-radius: 10px;
}

.task-progress-value {
    font-size: 11px;
    font-weight: 700;
    color: #6b7280;
    min-width: 35px;
    text-align: right;
}

.no-tasks {
    padding: 30px 20px;
    text-align: center;
    color: #9ca3af;
    font-size: 13px;
    line-height: 1.5;
}


/* =========================================
   RESPONSIVE LAYOUT
   ========================================= */

@media (max-width: 1100px) {
    .dashboard-stats {
        grid-template-columns: repeat(2, minmax(0, 1fr));
    }

    .dashboard-grid {
        grid-template-columns: minmax(0, 1fr);
    }
}

@media (max-width: 700px) {
    .dashboard-content {
        padding: 95px 20px 25px;
    }

    .welcome-section h1 {
        font-size: 23px;
    }

    .dashboard-panel-header {
        padding: 16px;
    }

    .dashboard-panel-body {
        padding: 16px;
    }
}

@media (max-width: 600px) {
    .page {
        margin-left: 220px;
        width: calc(100% - 220px);
    }

    .dashboard-content {
        padding: 85px 15px 20px;
    }

    .dashboard-stats {
        grid-template-columns: minmax(0, 1fr);
    }

    .quick-actions {
        grid-template-columns: minmax(0, 1fr);
    }
}

</style>
</head>

<body>

    <!-- SIDEBAR -->
    <%@ include file="sidebar.jspf"%>

    <div class="page">

        <!-- SHARED TOPBAR -->
        <%@ include file="topbar.jspf"%>

        <main class="dashboard-content">
            <div class="dashboard-container">

                <!-- WELCOME -->
                <section class="welcome-section">
                    <h1>
                        Welcome back,
                        <c:choose>
                            <c:when test="${not empty sessionScope.username}">
                                <c:out value="${sessionScope.username}"/>
                            </c:when>
                            <c:otherwise>User</c:otherwise>
                        </c:choose>
                    </h1>

                    <p>
                        Here's what's happening across your organization today.
                    </p>
                </section>

                <!-- STATISTICS -->
                <section class="dashboard-stats">

                    <div class="dashboard-stat">
                        <div class="stat-label">Active Employees</div>
                        <div class="stat-value"><%= dashboard != null ? dashboard.getTotalEmployees() : 0 %></div>
                        <div class="stat-description">Current workforce</div>
                    </div>

                    <div class="dashboard-stat">
                        <div class="stat-label">Active Projects</div>
                        <div class="stat-value"><%= dashboard != null ? dashboard.getActiveProjects() : 0 %></div>
                        <div class="stat-description">Currently active</div>
                    </div>

                    <div class="dashboard-stat">
                        <div class="stat-label">Open Tasks</div>
                        <div class="stat-value"><%= dashboard != null ? dashboard.getOpenTasks() : 0 %></div>
                        <div class="stat-description">Todo and in progress</div>
                    </div>

                    <div class="dashboard-stat">
                        <div class="stat-label">Pending Leaves</div>
                        <div class="stat-value"><%= dashboard != null ? dashboard.getPendingLeaves() : 0 %></div>
                        <div class="stat-description">Awaiting approval</div>
                    </div>

                </section>

                <!-- TASK + LEAVE -->
                <section class="dashboard-grid">

                    <!-- TASK OVERVIEW -->
                    <div class="dashboard-panel">
                        <div class="dashboard-panel-header">
                            <div>
                                <h2>Task Overview</h2>
                                <p>Current task distribution</p>
                            </div>

                            <a href="${pageContext.request.contextPath}/tasks">View all</a>
                        </div>

                        <div class="dashboard-panel-body">

                            <%
                                long completed =
                                    dashboard != null
                                    ? dashboard.getCompletedTasks()
                                    : 0;

                                long inProgress =
                                    dashboard != null
                                    ? dashboard.getInProgressTasks()
                                    : 0;

                                long todo =
                                    dashboard != null
                                    ? dashboard.getTodoTasks()
                                    : 0;

                                long blocked =
                                    dashboard != null
                                    ? dashboard.getBlockedTasks()
                                    : 0;

                                long totalTasks =
                                    completed + inProgress + todo + blocked;
                            %>

                            <div class="task-row">
                                <div class="task-row-header">
                                    <span class="task-name">Completed</span>
                                    <span class="task-count"><%= completed %></span>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-bar progress-completed"
                                         style="width:<%= totalTasks > 0 ? (completed * 100 / totalTasks) : 0 %>%;">
                                    </div>
                                </div>
                            </div>

                            <div class="task-row">
                                <div class="task-row-header">
                                    <span class="task-name">In Progress</span>
                                    <span class="task-count"><%= inProgress %></span>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-bar progress-progress"
                                         style="width:<%= totalTasks > 0 ? (inProgress * 100 / totalTasks) : 0 %>%;">
                                    </div>
                                </div>
                            </div>

                            <div class="task-row">
                                <div class="task-row-header">
                                    <span class="task-name">To Do</span>
                                    <span class="task-count"><%= todo %></span>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-bar progress-todo"
                                         style="width:<%= totalTasks > 0 ? (todo * 100 / totalTasks) : 0 %>%;">
                                    </div>
                                </div>
                            </div>

                            <div class="task-row">
                                <div class="task-row-header">
                                    <span class="task-name">Blocked</span>
                                    <span class="task-count"><%= blocked %></span>
                                </div>
                                <div class="progress-track">
                                    <div class="progress-bar progress-blocked"
                                         style="width:<%= totalTasks > 0 ? (blocked * 100 / totalTasks) : 0 %>%;">
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- LEAVE MANAGEMENT -->
                    <div class="dashboard-panel">
                        <div class="dashboard-panel-header">
                            <div>
                                <h2>Leave Management</h2>
                                <p>Current approval workload</p>
                            </div>

                            <a href="${pageContext.request.contextPath}/leaves">View all</a>
                        </div>

                        <div class="dashboard-panel-body">
                            <div class="leave-summary">

                                <div class="leave-item">
                                    <div class="leave-left">
                                        <div class="leave-icon">P</div>
                                        <div>
                                            <div class="leave-title">Pending Requests</div>
                                            <div class="leave-subtitle">Awaiting approval</div>
                                        </div>
                                    </div>

                                    <span class="pending-badge">
                                        <%= dashboard != null ? dashboard.getPendingLeaves() : 0 %>
                                    </span>
                                </div>

                                <div class="leave-item">
                                    <div class="leave-left">
                                        <div class="leave-icon">→</div>
                                        <div>
                                            <div class="leave-title">Review Requests</div>
                                            <div class="leave-subtitle">Manage employee leave</div>
                                        </div>
                                    </div>

                                    <a href="${pageContext.request.contextPath}/leaves"
                                       style="font-size:12px;color:#374151;text-decoration:none;font-weight:600;">
                                        Open
                                    </a>
                                </div>

                            </div>
                        </div>
                    </div>

                </section>

         
               
                    <!-- QUICK ACTIONS -->
                    <div class="dashboard-panel">
                        <div class="dashboard-panel-header">
                            <div>
                                <h2>Quick Actions</h2>
                                <p>Frequently used operations</p>
                            </div>
                        </div>

                        <div class="dashboard-panel-body">
                            <div class="quick-actions">

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/employees">
                                    Manage Employees
                                </a>

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/departments">
                                    Departments
                                </a>

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/projects">
                                    Projects
                                </a>

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/tasks">
                                    Tasks
                                </a>

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/attendance">
                                    Attendance
                                </a>

                                <a class="quick-action"
                                   href="${pageContext.request.contextPath}/leaves">
                                    Leave Management
                                </a>

                            </div>
                        </div>
                    </div>

                </section>

            </div>
        </main>
    </div>

</body>
</html>
