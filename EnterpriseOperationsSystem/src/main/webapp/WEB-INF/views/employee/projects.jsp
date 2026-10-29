<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.enterpriseops.model.Project"%>

<%
List<Project> projects =
(List<Project>) request.getAttribute("projects");


String contextPath = request.getContextPath();


%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>My Projects</title>

<style>
    body {
        margin: 0;
        padding: 30px;
        font-family: Arial, sans-serif;
        background: #f4f6f9;
        color: #333;
    }

    .container {
        max-width: 1100px;
        margin: auto;
    }

    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
        margin-bottom: 25px;
    }

    h1 {
        margin-bottom: 8px;
        color: #243b53;
    }

    .subtitle {
        color: #667085;
        margin-top: 0;
    }

    .back-link {
        display: inline-block;
        padding: 10px 16px;
        background: #243b53;
        color: white;
        text-decoration: none;
        border-radius: 6px;
    }

    .card {
        background: white;
        padding: 22px;
        border-radius: 10px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        overflow-x: auto;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th, td {
        padding: 13px;
        border-bottom: 1px solid #e5e7eb;
        text-align: left;
    }

    th {
        background: #f8fafc;
        color: #344054;
    }

    .status {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 15px;
        background: #e8f1ff;
        color: #2457a7;
        font-size: 12px;
        font-weight: bold;
    }

    .empty {
        padding: 25px;
        text-align: center;
        color: #667085;
    }
</style>

</head>

<body>
<div class="container">


<div class="header">
    <div>
        <h1>My Projects</h1>
        <p class="subtitle">
            View projects assigned to you.
        </p>
    </div>

    <a class="back-link"
       href="<%= contextPath %>/employee/dashboard">
        Back to Dashboard
    </a>
</div>

<div class="card">

    <% if (projects == null || projects.isEmpty()) { %>

        <div class="empty">
            <h3>No Projects Assigned</h3>
            <p>
                You do not have any projects assigned to you yet.
            </p>
        </div>

    <% } else { %>

        <table>
            <thead>
                <tr>
                    <th>Project Code</th>
                    <th>Project Name</th>
                    <th>Description</th>
                    <th>Start Date</th>
                    <th>End Date</th>
                    <th>Status</th>
                </tr>
            </thead>

            <tbody>
            <% for (Project project : projects) { %>
                <tr>
                    <td>
                        <%= project.getProjectCode() == null
                            ? "-"
                            : project.getProjectCode() %>
                    </td>

                    <td>
                        <%= project.getName() == null
                            ? "-"
                            : project.getName() %>
                    </td>

                    <td>
                        <%= project.getDescription() == null
                            || project.getDescription().trim().isEmpty()
                            ? "-"
                            : project.getDescription() %>
                    </td>

                    <td>
                        <%= project.getStartDate() == null
                            ? "-"
                            : project.getStartDate() %>
                    </td>

                    <td>
                        <%= project.getEndDate() == null
                            ? "-"
                            : project.getEndDate() %>
                    </td>

                    <td>
                        <span class="status">
                            <%= project.getStatus() == null
                                ? "UNKNOWN"
                                : project.getStatus() %>
                        </span>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>

    <% } %>

</div>


</div>
</body>
</html>
