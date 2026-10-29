<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Task" %>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <title>My Tasks</title>

<style>
    body {
        font-family: Arial, sans-serif;
        margin: 30px;
        background: #f4f6f9;
    }

    h2 {
        color: #263b5e;
    }

    .container {
        max-width: 1100px;
        margin: auto;
        background: white;
        padding: 24px;
        border-radius: 8px;
    }

    .back-link {
        display: inline-block;
        margin-bottom: 20px;
        color: #175cd3;
        text-decoration: none;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 15px;
    }

    th, td {
        border: 1px solid #ddd;
        padding: 11px;
        text-align: left;
    }

    th {
        background: #263b5e;
        color: white;
    }

    tr:nth-child(even) {
        background: #f7f9fc;
    }

    .empty {
        padding: 18px;
        background: #f0f4f8;
        border-radius: 5px;
    }
</style>

</head>

<body>
<div class="container">

<a class="back-link"
   href="${pageContext.request.contextPath}/employee/dashboard">
    &larr; Back to Dashboard
</a>

<h2>My Tasks</h2>
<p>Tasks assigned to your employee account are listed below.</p>

<%
    List<Task> tasks = (List<Task>) request.getAttribute("tasks");

    if (tasks == null || tasks.isEmpty()) {
%>

    <div class="empty">
        You do not have any tasks assigned yet.
    </div>

<%
    } else {
%>

    <table>
        <thead>
            <tr>
                <th>Task Code</th>
                <th>Title</th>
                <th>Description</th>
                <th>Project</th>
                <th>Priority</th>
                <th>Status</th>
                <th>Progress</th>
                <th>Start Date</th>
                <th>Due Date</th>
            </tr>
        </thead>

        <tbody>
        <%
            for (Task task : tasks) {
        %>
            <tr>
                <td><%= task.getTaskCode() == null
                        ? "" : task.getTaskCode() %></td>

                <td><%= task.getTitle() == null
                        ? "" : task.getTitle() %></td>

                <td><%= task.getDescription() == null
                        ? "" : task.getDescription() %></td>

                <td>
                    <%= task.getProject() == null
                            ? ""
                            : task.getProject().getName() %>
                </td>

                <td><%= task.getPriority() == null
                        ? "" : task.getPriority() %></td>

                <td><%= task.getStatus() == null
                        ? "" : task.getStatus() %></td>

                <td>
                    <%= task.getProgress() == null
                            ? 0 : task.getProgress() %>%
                </td>

                <td><%= task.getStartDate() == null
                        ? "" : task.getStartDate() %></td>

                <td><%= task.getDueDate() == null
                        ? "" : task.getDueDate() %></td>
            </tr>
        <%
            }
        %>
        </tbody>
    </table>

<%
    }
%>


</div>
</body>
</html>
