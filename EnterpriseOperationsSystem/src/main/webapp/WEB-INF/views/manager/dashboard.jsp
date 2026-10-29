
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manager Dashboard - Enterprise Operations</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f3f4f6;
            color: #111827;
        }

        .main-content {
            margin-left: 240px;
            padding: 95px 30px 40px;
            min-height: 100vh;
        }

        .dashboard-header {
            margin-bottom: 25px;
        }

        .dashboard-header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }

        .dashboard-header p {
            margin: 8px 0 0;
            color: #6b7280;
            font-size: 14px;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }

        .stat-card,
        .card {
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 22px;
        }

        .stat-label {
            color: #6b7280;
            font-size: 13px;
            margin-bottom: 10px;
        }

        .stat-value {
            font-size: 30px;
            font-weight: 700;
            color: #111827;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: minmax(0, 1fr) minmax(0, 1fr);
            gap: 20px;
        }

        .card h2 {
            margin: 0 0 20px;
            font-size: 18px;
        }

        .task-row {
            margin-bottom: 18px;
        }

        .task-row:last-child {
            margin-bottom: 0;
        }

        .task-label {
            display: flex;
            justify-content: space-between;
            margin-bottom: 7px;
            font-size: 13px;
        }

        .progress-bar {
            width: 100%;
            height: 9px;
            background: #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
        }

        .progress-fill {
            height: 100%;
            background: #2563eb;
            border-radius: 10px;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            padding: 13px 0;
            border-bottom: 1px solid #e5e7eb;
            font-size: 14px;
        }

        .summary-row:last-child {
            border-bottom: none;
        }

        .summary-label {
            color: #6b7280;
        }

        .summary-value {
            font-weight: 700;
        }

        .quick-actions {
            margin-top: 20px;
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
        }

        .action-link {
            display: inline-block;
            padding: 10px 14px;
            background: #111827;
            color: #ffffff;
            text-decoration: none;
            border-radius: 7px;
            font-size: 13px;
        }

        .action-link:hover {
            background: #1f2937;
        }

        .empty-message {
            color: #6b7280;
            font-size: 14px;
            padding: 12px 0;
        }

        @media (max-width: 1000px) {
            .stats-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .dashboard-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 85px 15px 30px;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
<%@ include file="/WEB-INF/views/sidebar.jspf" %>
<%@ include file="/WEB-INF/views/topbar.jspf" %>

    <main class="main-content">

        <div class="dashboard-header">
            <h1>Manager Dashboard</h1>
            <p>
                Welcome back,
                <strong><c:out value="${sessionScope.username}" /></strong>.
                Here's an overview of your team.
            </p>
        </div>

        <div class="stats-grid">

            <div class="stat-card">
                <div class="stat-label">My Team</div>
                <div class="stat-value">
                    <c:out value="${dashboard.myTeam}" default="0" />
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Active Projects</div>
                <div class="stat-value">
                    <c:out value="${dashboard.activeProjects}" default="0" />
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Open Tasks</div>
                <div class="stat-value">
                    <c:out value="${dashboard.openTasks}" default="0" />
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-label">Pending Leaves</div>
                <div class="stat-value">
                    <c:out value="${dashboard.pendingLeaves}" default="0" />
                </div>
            </div>

        </div>

        <div class="dashboard-grid">

            <div class="card">
                <h2>Team Task Overview</h2>

                <c:set var="todoCount" value="0" />
                <c:set var="inProgressCount" value="0" />
                <c:set var="completedCount" value="0" />
                <c:set var="blockedCount" value="0" />

                <c:forEach var="task" items="${managerTasks}">
                    <c:choose>
                        <c:when test="${task.status eq 'TODO'}">
                            <c:set var="todoCount" value="${todoCount + 1}" />
                        </c:when>

                        <c:when test="${task.status eq 'IN_PROGRESS'}">
                            <c:set var="inProgressCount" value="${inProgressCount + 1}" />
                        </c:when>

                        <c:when test="${task.status eq 'COMPLETED'}">
                            <c:set var="completedCount" value="${completedCount + 1}" />
                        </c:when>

                        <c:when test="${task.status eq 'BLOCKED'}">
                            <c:set var="blockedCount" value="${blockedCount + 1}" />
                        </c:when>
                    </c:choose>
                </c:forEach>

                <c:set var="totalTasks" value="${todoCount + inProgressCount + completedCount + blockedCount}" />

                <c:if test="${empty managerTasks}">
                    <p class="empty-message">
                        No tasks are currently assigned to projects you manage.
                    </p>
                </c:if>

                <div class="task-row">
                    <div class="task-label">
                        <span>To Do</span>
                        <strong><c:out value="${todoCount}" /></strong>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill"
                             style="width: ${totalTasks gt 0 ? (todoCount * 100.0 / totalTasks) : 0}%;"></div>
                    </div>
                </div>

                <div class="task-row">
                    <div class="task-label">
                        <span>In Progress</span>
                        <strong><c:out value="${inProgressCount}" /></strong>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill"
                             style="width: ${totalTasks gt 0 ? (inProgressCount * 100.0 / totalTasks) : 0}%;"></div>
                    </div>
                </div>

                <div class="task-row">
                    <div class="task-label">
                        <span>Completed</span>
                        <strong><c:out value="${completedCount}" /></strong>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill"
                             style="width: ${totalTasks gt 0 ? (completedCount * 100.0 / totalTasks) : 0}%;"></div>
                    </div>
                </div>

                <div class="task-row">
                    <div class="task-label">
                        <span>Blocked</span>
                        <strong><c:out value="${blockedCount}" /></strong>
                    </div>
                    <div class="progress-bar">
                        <div class="progress-fill"
                             style="width: ${totalTasks gt 0 ? (blockedCount * 100.0 / totalTasks) : 0}%;"></div>
                    </div>
                </div>
            </div>

            <div class="card">
                <h2>Management Summary</h2>

                <div class="summary-row">
                    <span class="summary-label">Team Members</span>
                    <span class="summary-value">
                        <c:out value="${dashboard.myTeam}" default="0" />
                    </span>
                </div>

                <div class="summary-row">
                    <span class="summary-label">Active Projects</span>
                    <span class="summary-value">
                        <c:out value="${dashboard.activeProjects}" default="0" />
                    </span>
                </div>

                <div class="summary-row">
                    <span class="summary-label">Open Tasks</span>
                    <span class="summary-value">
                        <c:out value="${dashboard.openTasks}" default="0" />
                    </span>
                </div>

                <div class="summary-row">
                    <span class="summary-label">Pending Leave Approvals</span>
                    <span class="summary-value">
                        <c:out value="${dashboard.pendingLeaves}" default="0" />
                    </span>
                </div>

                <div class="quick-actions">
                    <a class="action-link"
                       href="${pageContext.request.contextPath}/manager/team">
                        My Team
                    </a>

                    <a class="action-link"
                       href="${pageContext.request.contextPath}/manager/projects">
                        My Projects
                    </a>

                    <a class="action-link"
                       href="${pageContext.request.contextPath}/manager/tasks">
                        Task Management 
                    </a>

                    <a class="action-link"
                       href="${pageContext.request.contextPath}/manager/approvals">
                        Leave Approval
                    </a>
                    
                    <a class="action-link"
   href="${pageContext.request.contextPath}/leaves?action=add">
    Apply Leave
</a>

                    <a class="action-link"
                       href="${pageContext.request.contextPath}/manager/attendance">
                        Team Attendance
                    </a>
                </div>
            </div>

        </div>
    </main>
</body>
</html>
