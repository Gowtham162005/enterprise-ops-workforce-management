
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        * {
            box-sizing: border-box;
        }

        html,
        body {
            margin: 0;
            padding: 0;
            min-height: 100%;
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f6f8;
            color: #1f2937;
        }

        body {
            min-height: 100vh;
        }

        ```css
/* =========================================
   MAIN LAYOUT
   Desktop sidebar: 240px
   Mobile sidebar: 220px
   Fixed topbar height: 65px
   ========================================= */

.app-layout {
    min-height: 100vh;
    width: 100%;
}

.main-content {
    margin-left: 240px;
    width: calc(100% - 240px);
    min-height: 100vh;
    min-width: 0;
    box-sizing: border-box;
    position: relative;
}

.reports-page {
    width: 100%;
    min-width: 0;
    padding: 95px 30px 30px;
    box-sizing: border-box;
}

.reports-container {
    width: 100%;
    max-width: 1250px;
    min-width: 0;
    margin: 0 auto;
    box-sizing: border-box;
}

/* Responsive layout */
@media (max-width: 700px) {
    .reports-page {
        padding: 85px 20px 25px;
    }
}

@media (max-width: 600px) {
    .main-content {
        margin-left: 220px;
        width: calc(100% - 220px);
    }

    .reports-page {
        padding: 80px 12px 20px;
    }
}


        /* =========================================
           PAGE HEADER
           ========================================= */

        .page-header {
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 27px;
            color: #111827;
        }

        .page-header p {
            margin: 8px 0 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        /* =========================================
           SUMMARY CARDS
           ========================================= */

        .report-stats {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 18px;
            margin-bottom: 25px;
        }

        .report-stat {
            min-width: 0;
            background: #ffffff;
            border-radius: 10px;
            padding: 22px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .report-stat-label {
            font-size: 12px;
            font-weight: 600;
            color: #6b7280;
            margin-bottom: 8px;
            line-height: 1.5;
        }

        .report-stat-value {
            font-size: 30px;
            font-weight: 700;
            color: #111827;
            overflow-wrap: anywhere;
        }

        /* =========================================
           REPORT GRID
           ========================================= */

        .report-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }

        .report-panel {
            min-width: 0;
            background: #ffffff;
            border-radius: 10px;
            padding: 22px;
            border: 1px solid #e5e7eb;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
        }

        .report-panel h2 {
            margin: 0 0 18px;
            font-size: 17px;
            color: #111827;
        }

        /* =========================================
           REPORT ROWS
           ========================================= */

        .report-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding: 13px 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .report-row:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .report-row-label {
            min-width: 0;
            color: #4b5563;
            font-size: 13px;
            line-height: 1.5;
        }

        .report-row-value {
            flex-shrink: 0;
            font-size: 14px;
            font-weight: 700;
            color: #111827;
            text-align: right;
        }

        /* =========================================
           STATUS BADGES
           ========================================= */

        .status-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status-todo {
            background: #f3f4f6;
            color: #374151;
        }

        .status-progress {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .status-completed {
            background: #dcfce7;
            color: #166534;
        }

        .status-blocked {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-approved {
            background: #dcfce7;
            color: #166534;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        /* =========================================
           EMPTY REPORT NOTICE
           ========================================= */

        .report-note {
            padding: 14px 16px;
            margin-bottom: 20px;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            background: #ffffff;
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        /* =========================================
           RESPONSIVE LAYOUT
           ========================================= */

        @media (max-width: 1100px) {
            .report-stats {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .report-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        @media (max-width: 700px) {
            .reports-page {
                padding: 85px 20px 25px;
            }

            .page-header h1 {
                font-size: 23px;
            }

            .report-panel {
                padding: 18px;
            }

            .report-stat {
                padding: 18px;
            }
        }

        @media (max-width: 600px) {
            /*
             * sidebar.jspf uses width: 220px at this
             * breakpoint. Keep the content aligned
             * with that sidebar.
             */
            .main-content {
                margin-left: 220px;
                width: auto;
            }

            .reports-page {
                padding: 80px 12px 20px;
            }

            .report-stats {
                grid-template-columns: minmax(0, 1fr);
                gap: 12px;
            }

            .report-grid {
                gap: 14px;
                margin-bottom: 14px;
            }

            .report-stat,
            .report-panel {
                padding: 14px;
            }

            .report-panel h2 {
                font-size: 16px;
            }

            .report-row {
                gap: 8px;
                padding: 11px 0;
            }

            .report-row-label {
                font-size: 12px;
            }

            .report-row-value {
                font-size: 13px;
            }

            .report-stat-value {
                font-size: 26px;
            }
        }
    </style>
</head>

<body>

    <div class="app-layout">

        <%@ include file="sidebar.jspf" %>

        <div class="main-content">

            <%@ include file="topbar.jspf" %>

            <main class="reports-page">
                <div class="reports-container">

                    <header class="page-header">
                        <h1>Reports</h1>
                        <p>
                            Overview of employees, projects, tasks, leave and attendance.
                        </p>
                    </header>

                    <c:if test="${empty report}">
                        <div class="report-note">
                            Report data has not been supplied to this page.
                            Ensure the controller loads the report DTO and sets
                            the request attribute named <strong>report</strong>.
                        </div>
                    </c:if>

                    <!-- Summary cards -->
                    <section class="report-stats">

                        <div class="report-stat">
                            <div class="report-stat-label">Total Employees</div>
                            <div class="report-stat-value">
                                <c:out value="${report.totalEmployees}" default="0" />
                            </div>
                        </div>

                        <div class="report-stat">
                            <div class="report-stat-label">Active Employees</div>
                            <div class="report-stat-value">
                                <c:out value="${report.activeEmployees}" default="0" />
                            </div>
                        </div>

                        <div class="report-stat">
                            <div class="report-stat-label">Total Projects</div>
                            <div class="report-stat-value">
                                <c:out value="${report.totalProjects}" default="0" />
                            </div>
                        </div>

                        <div class="report-stat">
                            <div class="report-stat-label">Active Projects</div>
                            <div class="report-stat-value">
                                <c:out value="${report.activeProjects}" default="0" />
                            </div>
                        </div>

                    </section>

                    <!-- Employee and project overview -->
                    <section class="report-grid">

                        <div class="report-panel">
                            <h2>Employee Overview</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Employees</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalEmployees}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Active Employees</span>
                                <span class="report-row-value">
                                    <c:out value="${report.activeEmployees}" default="0" />
                                </span>
                            </div>
                        </div>

                        <div class="report-panel">
                            <h2>Project Overview</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Projects</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalProjects}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Active Projects</span>
                                <span class="report-row-value">
                                    <c:out value="${report.activeProjects}" default="0" />
                                </span>
                            </div>
                        </div>

                    </section>

                    <!-- Tasks and leave -->
                    <section class="report-grid">

                        <div class="report-panel">
                            <h2>Task Overview</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Tasks</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalTasks}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">To Do</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-todo">
                                        <c:out value="${report.todoTasks}" default="0" />
                                    </span>
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">In Progress</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-progress">
                                        <c:out value="${report.inProgressTasks}" default="0" />
                                    </span>
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Completed</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-completed">
                                        <c:out value="${report.completedTasks}" default="0" />
                                    </span>
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Blocked</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-blocked">
                                        <c:out value="${report.blockedTasks}" default="0" />
                                    </span>
                                </span>
                            </div>
                        </div>

                        <div class="report-panel">
                            <h2>Leave Management</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Leave Requests</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalLeaveRequests}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Pending</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-pending">
                                        <c:out value="${report.pendingLeaves}" default="0" />
                                    </span>
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Approved</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-approved">
                                        <c:out value="${report.approvedLeaves}" default="0" />
                                    </span>
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Rejected</span>
                                <span class="report-row-value">
                                    <span class="status-badge status-rejected">
                                        <c:out value="${report.rejectedLeaves}" default="0" />
                                    </span>
                                </span>
                            </div>
                        </div>

                    </section>

                    <!-- Attendance and organization -->
                    <section class="report-grid">

                        <div class="report-panel">
                            <h2>Attendance Summary</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Attendance Records</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalAttendance}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Present</span>
                                <span class="report-row-value">
                                    <c:out value="${report.presentAttendance}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Absent</span>
                                <span class="report-row-value">
                                    <c:out value="${report.absentAttendance}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Late</span>
                                <span class="report-row-value">
                                    <c:out value="${report.lateAttendance}" default="0" />
                                </span>
                            </div>
                        </div>

                        <div class="report-panel">
                            <h2>Organization Overview</h2>

                            <div class="report-row">
                                <span class="report-row-label">Total Departments</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalDepartments}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Total Employees</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalEmployees}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Total Projects</span>
                                <span class="report-row-value">
                                    <c:out value="${report.totalProjects}" default="0" />
                                </span>
                            </div>

                            <div class="report-row">
                                <span class="report-row-label">Total Tasks</span>
                                <span class="report-row-value">
                                   <c:out value="${report.totalTasks}" default="0" />
                                </span>
                            </div>
                        </div>

                    </section>

                </div>
            </main>

        </div>
    </div>

</body>
</html>
