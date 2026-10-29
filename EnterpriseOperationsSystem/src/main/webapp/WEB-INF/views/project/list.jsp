
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Project" %>
<%@ page import="javax.servlet.http.HttpSession" %>

<%!
    // Escape untrusted values before rendering them as HTML.
    private String escapeHtml(Object value) {
        if (value == null) {
            return "";
        }

        String text = String.valueOf(value);

        return text.replace("&", "&amp;")
                   .replace("<", "&lt;")
                   .replace(">", "&gt;")
                   .replace("\"", "&quot;")
                   .replace("'", "&#39;");
    }
%>

<%
    HttpSession userSession = request.getSession(false);

    String role = userSession == null
            ? null
            : String.valueOf(userSession.getAttribute("role"));

    role = role == null ? "" : role.trim().toUpperCase();

    boolean isAdmin = "ADMIN".equals(role);
    boolean isManager = "MANAGER".equals(role);

    List<Project> projects =
            (List<Project>) request.getAttribute("projects");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Project Management</title>

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
            min-height: 100vh;
            min-width: 0;
            box-sizing: border-box;
            position: relative;
        }

        .project-page {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        .project-page *,
        .project-page *::before,
        .project-page *::after {
            box-sizing: border-box;
        }

        .project-page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
            margin-bottom: 25px;
            min-width: 0;
        }

        .project-page-header > div {
            min-width: 0;
        }

        .project-page-title {
            margin: 0;
            font-size: 26px;
            color: #111827;
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .project-page-subtitle {
            margin: 7px 0 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        .add-project-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            flex-shrink: 0;
            padding: 10px 16px;
            border-radius: 6px;
            border: none;
            background: #2563eb;
            color: #fff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
        }

        .add-project-btn:hover {
            background: #1d4ed8;
            color: #fff;
        }

        .project-table-card {
            width: 100%;
            max-width: 100%;
            min-width: 0;
            background: #fff;
            border-radius: 10px;
            overflow: hidden;
            border: 1px solid #eef0f3;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        }

        .project-table-wrapper {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            overflow-x: auto;
            overflow-y: hidden;
            -webkit-overflow-scrolling: touch;
        }

        .project-table {
            width: 100%;
            min-width: 900px;
            border-collapse: collapse;
        }

        .project-table th,
        .project-table td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        .project-table th {
            background: #f8fafc;
            color: #374151;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
            white-space: nowrap;
        }

        .project-table td {
            color: #374151;
            font-size: 14px;
            vertical-align: middle;
        }

        .project-table tbody tr:hover {
            background: #f9fafb;
        }

        .project-table tbody tr:last-child td {
            border-bottom: none;
        }

        .project-code {
            font-weight: 700;
            color: #111827;
            white-space: nowrap;
        }

        .project-name {
            font-weight: 600;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .project-description {
            color: #4b5563;
            line-height: 1.5;
            max-width: 320px;
            min-width: 120px;
            white-space: normal;
            overflow-wrap: anywhere;
        }

        .project-status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            background: #eef2ff;
            color: #3730a3;
            font-size: 12px;
            font-weight: bold;
            white-space: nowrap;
        }

        .project-actions {
            display: flex;
            gap: 7px;
            align-items: center;
            flex-wrap: wrap;
            min-width: 180px;
        }

        .project-action {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 11px;
            border: 0;
            border-radius: 6px;
            text-decoration: none;
            font-family: inherit;
            font-size: 12px;
            font-weight: 600;
            white-space: nowrap;
            cursor: pointer;
        }

        .project-action-edit {
            background: #eef2ff;
            color: #3730a3;
        }

        .project-action-edit:hover {
            background: #e0e7ff;
            color: #312e81;
        }

        .project-action-delete {
            background: #fee2e2;
            color: #b91c1c;
        }

        .project-action-delete:hover {
            background: #fecaca;
            color: #991b1b;
        }

        .project-action-members {
            background: #ecfdf5;
            color: #047857;
        }

        .project-action-members:hover {
            background: #d1fae5;
            color: #065f46;
        }

        .project-delete-form {
            display: inline-flex;
            margin: 0;
        }

        .project-table .no-data {
            text-align: center;
            padding: 40px 20px;
            color: #6b7280;
            white-space: normal;
        }

        @media (max-width: 768px) {
            .project-page {
                padding: 85px 20px 25px;
            }

            .project-page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .add-project-btn {
                max-width: 100%;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
            }

            .project-page {
                padding: 80px 12px 20px;
            }

            .project-page-title {
                font-size: 24px;
            }
        }
    </style>
</head>

<body>

<div class="app-layout">

    <%@ include file="../sidebar.jspf" %>

    <div class="main-content">

        <%@ include file="../topbar.jspf" %>

        <main class="project-page">

            <div class="project-page-header">

                <div>
                    <h1 class="project-page-title">
                        Project Management
                    </h1>

                    <p class="project-page-subtitle">
                        Manage projects, schedules, status and team members.
                    </p>
                </div>

                <% if (isAdmin) { %>
                    <a class="add-project-btn"
                       href="${pageContext.request.contextPath}/projects?action=add">
                        + Add Project
                    </a>
                <% } %>

            </div>

            <div class="project-table-card">
                <div class="project-table-wrapper">

                    <table class="project-table">

                        <thead>
                        <tr>
                            <th>ID</th>
                            <th>Project Code</th>
                            <th>Name</th>
                            <th>Description</th>
                            <th>Start Date</th>
                            <th>End Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                        </thead>

                        <tbody>

                        <% if (projects != null && !projects.isEmpty()) { %>

                            <% for (Project project : projects) { %>

                                <tr>
                                    <td>
                                        <%= escapeHtml(project.getId()) %>
                                    </td>

                                    <td>
                                        <span class="project-code">
                                            <%= escapeHtml(project.getProjectCode()) %>
                                        </span>
                                    </td>

                                    <td>
                                        <span class="project-name">
                                            <%= escapeHtml(project.getName()) %>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="project-description">
                                            <%= escapeHtml(project.getDescription()) %>
                                        </div>
                                    </td>

                                    <td>
                                        <%= escapeHtml(project.getStartDate()) %>
                                    </td>

                                    <td>
                                        <%= escapeHtml(project.getEndDate()) %>
                                    </td>

                                    <td>
                                        <span class="project-status">
                                            <%= escapeHtml(project.getStatus()) %>
                                        </span>
                                    </td>

                                    <td>
                                        <div class="project-actions">

                                            <% if (isAdmin) { %>

                                                <a class="project-action project-action-edit"
                                                   href="${pageContext.request.contextPath}/projects?action=edit&amp;id=<%= project.getId() %>">
                                                    Edit
                                                </a>

                                                <form class="project-delete-form"
                                                      action="${pageContext.request.contextPath}/projects"
                                                      method="post"
                                                      onsubmit="return confirm('Are you sure you want to delete this project?');">

                                                    <input type="hidden"
                                                           name="action"
                                                           value="delete">

                                                    <input type="hidden"
                                                           name="id"
                                                           value="<%= project.getId() %>">

                                                    <button type="submit"
                                                            class="project-action project-action-delete">
                                                        Delete
                                                    </button>
                                                </form>

                                            <% } %>

                                            <% if (isAdmin || isManager) { %>

                                                <a class="project-action project-action-members"
                                                   href="${pageContext.request.contextPath}/projects?action=members&amp;id=<%= project.getId() %>">
                                                    Manage Members
                                                </a>

                                            <% } %>

                                        </div>
                                    </td>
                                </tr>

                            <% } %>

                        <% } else { %>

                            <tr>
                                <td colspan="8" class="no-data">
                                    No projects found.
                                </td>
                            </tr>

                        <% } %>

                        </tbody>
                    </table>

                </div>
            </div>

        </main>
    </div>
</div>

</body>
</html>
