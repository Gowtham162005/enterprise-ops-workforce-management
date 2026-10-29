
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.AuditLog" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audit Logs | Enterprise Operations</title>

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

        .audit-page {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
            position: relative;
        }

        /* PAGE HEADER */
        .page-header {
            width: 100%;
            min-width: 0;
            margin-bottom: 25px;
            box-sizing: border-box;
        }

        .page-header h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .page-header p {
            margin: 6px 0 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        /* AUDIT PANEL */
        .audit-panel {
            width: 100%;
            max-width: 100%;
            min-width: 0;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            overflow: hidden;
            box-sizing: border-box;
        }

        .audit-panel-header {
            padding: 20px 24px;
            border-bottom: 1px solid #e5e7eb;
            box-sizing: border-box;
        }

        .audit-panel-header h2 {
            margin: 0;
            font-size: 18px;
            color: #111827;
        }

        .audit-panel-header p {
            margin: 6px 0 0;
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }

        /* TABLE */
        .table-wrapper {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
            box-sizing: border-box;
        }

        .audit-table {
            width: 100%;
            min-width: 850px;
            border-collapse: collapse;
        }

        .audit-table th {
            padding: 14px 18px;
            background: #f9fafb;
            border-bottom: 1px solid #e5e7eb;
            color: #6b7280;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            text-align: left;
            white-space: nowrap;
        }

        .audit-table td {
            padding: 16px 18px;
            border-bottom: 1px solid #f0f0f0;
            color: #374151;
            font-size: 13px;
            vertical-align: top;
        }

        .audit-table tbody tr:hover {
            background: #fafafa;
        }

        .audit-table tbody tr:last-child td {
            border-bottom: none;
        }

        /* AUDIT DETAILS */
        .audit-id {
            color: #6b7280;
            font-weight: 600;
            white-space: nowrap;
        }

        .audit-user {
            font-weight: 600;
            color: #111827;
        }

        .audit-description {
            max-width: 320px;
            line-height: 1.5;
            color: #4b5563;
            overflow-wrap: anywhere;
        }

        .action-badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            background: #f3f4f6;
            color: #374151;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .entity-type {
            font-weight: 600;
            color: #374151;
            overflow-wrap: anywhere;
        }

        .entity-id {
            color: #6b7280;
            white-space: nowrap;
        }

        .created-at {
            color: #6b7280;
            white-space: nowrap;
        }

        /* EMPTY STATE */
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            box-sizing: border-box;
        }

        .empty-state h3 {
            margin: 0;
            font-size: 18px;
            color: #374151;
        }

        .empty-state p {
            margin: 8px 0 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        /* RESPONSIVE */
        @media (max-width: 768px) {
            .audit-page {
                padding: 85px 20px 25px;
            }

            .page-header {
                margin-bottom: 20px;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
                max-width: calc(100% - 220px);
            }

            .audit-page {
                padding: 80px 12px 20px;
            }

            .page-header h1 {
                font-size: 24px;
            }

            .audit-panel-header {
                padding: 18px;
            }

            .audit-table th,
            .audit-table td {
                padding: 12px 10px;
            }

            .empty-state {
                padding: 45px 16px;
            }
        }
    </style>
</head>

<body>
    <div class="app-layout">

        <%@ include file="sidebar.jspf" %>

        <div class="main-content">

<%@ include file="topbar.jspf" %>
            <main class="audit-page content-layout">

                <!-- PAGE HEADER -->
                <div class="page-header">
                    <h1>Audit Logs</h1>
                    <p>
                        Track important actions performed across the system.
                    </p>
                </div>

                <!-- AUDIT PANEL -->
                <div class="audit-panel">

                    <div class="audit-panel-header">
                        <h2>System Activity</h2>
                        <p>
                            A chronological record of system operations.
                        </p>
                    </div>

                    <%
                        List<AuditLog> auditLogs =
                            (List<AuditLog>) request.getAttribute("auditLogs");
                    %>

                    <% if (auditLogs == null || auditLogs.isEmpty()) { %>

                        <!-- EMPTY STATE -->
                        <div class="empty-state">
                            <h3>No audit logs found</h3>
                            <p>
                                There are currently no recorded system activities.
                            </p>
                        </div>

                    <% } else { %>

                        <!-- AUDIT TABLE -->
                        <div class="table-wrapper">
                            <table class="audit-table">

                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>User</th>
                                        <th>Action</th>
                                        <th>Entity</th>
                                        <th>Description</th>
                                        <th>Created At</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <% for (AuditLog log : auditLogs) { %>

                                        <tr>
                                            <!-- AUDIT ID -->
                                            <td>
                                                <span class="audit-id">
                                                    <%= log.getId() %>
                                                </span>
                                            </td>

                                            <!-- USER -->
                                            <td>
                                                <%
                                                    String username = "System";

                                                    if (log.getUser() != null
                                                            && log.getUser().getUsername() != null) {
                                                        username = log.getUser().getUsername();
                                                    }
                                                %>

                                                <span class="audit-user">
                                                    <%= username %>
                                                </span>
                                            </td>

                                            <!-- ACTION -->
                                            <td>
                                                <span class="action-badge">
                                                    <%= log.getAction() != null
                                                            ? log.getAction()
                                                            : "-" %>
                                                </span>
                                            </td>

                                            <!-- ENTITY -->
                                            <td>
                                                <%
                                                    String entityType = log.getEntityType();
                                                    Integer entityId = log.getEntityId();
                                                %>

                                                <% if (entityType != null
                                                        && !entityType.trim().isEmpty()) { %>

                                                    <span class="entity-type">
                                                        <%= entityType %>
                                                    </span>

                                                    <% if (entityId != null) { %>
                                                        <span class="entity-id">
                                                            #<%= entityId %>
                                                        </span>
                                                    <% } %>

                                                <% } else { %>

                                                    <span class="entity-id">-</span>

                                                <% } %>
                                            </td>

                                            <!-- DESCRIPTION -->
                                            <td>
                                                <div class="audit-description">
                                                    <%
                                                        String description = log.getDescription();

                                                        if (description == null
                                                                || description.trim().isEmpty()) {
                                                            description = "-";
                                                        }
                                                    %>

                                                    <%= description %>
                                                </div>
                                            </td>

                                            <!-- CREATED DATE -->
                                            <td>
                                                <span class="created-at">
                                                    <%= log.getCreatedAt() != null
                                                            ? log.getCreatedAt()
                                                            : "-" %>
                                                </span>
                                            </td>
                                        </tr>

                                    <% } %>
                                </tbody>

                            </table>
                        </div>

                    <% } %>

                </div>
            </main>
        </div>
    </div>
</body>
</html>
