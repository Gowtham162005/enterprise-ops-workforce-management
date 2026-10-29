
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.enterpriseops.model.Project" %>
<%@ page import="com.enterpriseops.model.Employee" %>

<%!
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
    Project project = (Project) request.getAttribute("project");

    List<Employee> employees =
            (List<Employee>) request.getAttribute("employees");

    if (project == null) {
        response.sendError(
                javax.servlet.http.HttpServletResponse.SC_NOT_FOUND,
                "Project not found.");
        return;
    }

    List<Employee> members = project.getMembers();

    if (members == null) {
        members = new ArrayList<Employee>();
    }

    // Exclude employees who are already members of this project.
    List<Employee> availableEmployees = new ArrayList<Employee>();

    if (employees != null) {
        for (Employee employee : employees) {
            if (employee == null || employee.getId() == null) {
                continue;
            }

            boolean alreadyMember = false;

            for (Employee member : members) {
                if (member != null
                        && member.getId() != null
                        && member.getId().equals(employee.getId())) {
                    alreadyMember = true;
                    break;
                }
            }

            if (!alreadyMember) {
                availableEmployees.add(employee);
            }
        }
    }

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Manage Project Members</title>

    <link rel="stylesheet"
          href="<%= escapeHtml(contextPath) %>/assets/css/app.css">

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f5f6f8;
            margin: 0;
            padding: 30px;
            color: #1f2937;
        }

        .container {
            width: 100%;
            max-width: 1000px;
            margin: 0 auto;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 25px;
        }

        .header h1 {
            margin: 0;
            font-size: 26px;
            overflow-wrap: anywhere;
        }

        .subtitle {
            color: #6b7280;
            margin-top: 6px;
            line-height: 1.5;
        }

        .back-btn {
            text-decoration: none;
            color: #374151;
            font-weight: 600;
            white-space: nowrap;
        }

        .back-btn:hover {
            color: #111827;
        }

        .card {
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            padding: 24px;
            margin-bottom: 20px;
            min-width: 0;
        }

        .card h2 {
            margin-top: 0;
            margin-bottom: 18px;
            font-size: 19px;
        }

        .project-info {
            display: flex;
            flex-wrap: wrap;
            gap: 24px 40px;
        }

        .info-label {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 4px;
        }

        .info-value {
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .form-row {
            display: flex;
            gap: 12px;
            align-items: center;
        }

        .form-row select {
            flex: 1;
            min-width: 0;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            background: #fff;
        }

        button {
            padding: 10px 18px;
            border: none;
            border-radius: 6px;
            background: #111827;
            color: #fff;
            font-weight: 600;
            cursor: pointer;
            font-size: 14px;
        }

        button:hover {
            background: #374151;
        }

        button:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }

        .member-list {
            display: flex;
            flex-direction: column;
        }

        .member-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            padding: 15px 0;
            border-bottom: 1px solid #e5e7eb;
        }

        .member-row:last-child {
            border-bottom: none;
        }

        .member-info {
            display: flex;
            flex-direction: column;
            gap: 4px;
            min-width: 0;
        }

        .member-name {
            font-weight: 600;
            overflow-wrap: anywhere;
        }

        .member-id {
            font-size: 12px;
            color: #6b7280;
        }

        .remove-form {
            margin: 0;
            flex-shrink: 0;
        }

        .remove-btn {
            background: #fee2e2;
            color: #b91c1c;
            padding: 8px 12px;
        }

        .remove-btn:hover {
            background: #fecaca;
            color: #991b1b;
        }

        .empty {
            color: #6b7280;
            padding: 10px 0;
            line-height: 1.5;
        }

        @media (max-width: 600px) {
            body {
                padding: 16px;
            }

            .header {
                align-items: flex-start;
                flex-direction: column;
            }

            .header h1 {
                font-size: 23px;
            }

            .card {
                padding: 18px;
            }

            .form-row {
                align-items: stretch;
                flex-direction: column;
            }

            .form-row button {
                width: 100%;
            }
        }
    </style>
</head>

<body>

<div class="container">

    <div class="header">
        <div>
            <h1>Manage Project Members</h1>

            <div class="subtitle">
                Add or remove employees from this project.
            </div>
        </div>

        <a class="back-btn"
           href="<%= escapeHtml(contextPath) %>/projects">
            &larr; Back to Projects
        </a>
    </div>

    <!-- PROJECT INFORMATION -->
    <div class="card">

        <h2>Project Information</h2>

        <div class="project-info">

            <div>
                <div class="info-label">Project Code</div>
                <div class="info-value">
                    <%= escapeHtml(project.getProjectCode()) %>
                </div>
            </div>

            <div>
                <div class="info-label">Project Name</div>
                <div class="info-value">
                    <%= escapeHtml(project.getName()) %>
                </div>
            </div>

            <div>
                <div class="info-label">Status</div>
                <div class="info-value">
                    <%= escapeHtml(project.getStatus()) %>
                </div>
            </div>

        </div>
    </div>

    <!-- ADD MEMBER -->
    <div class="card">

        <h2>Add Project Member</h2>

        <form method="post"
              action="<%= escapeHtml(contextPath) %>/projects">

            <input type="hidden" name="action" value="addMember">

            <input type="hidden"
                   name="projectId"
                   value="<%= project.getId() %>">

            <div class="form-row">

                <select name="employeeId" required
                        aria-label="Select an employee">

                    <option value="">Select an employee</option>

                    <% for (Employee employee : availableEmployees) { %>

                        <option value="<%= employee.getId() %>">
                            <%= escapeHtml(employee.getFirstName()) %>
                            <%= escapeHtml(employee.getLastName()) %>
                            (ID: <%= employee.getId() %>)
                        </option>

                    <% } %>

                </select>

                <button type="submit"
                        <%= availableEmployees.isEmpty() ? "disabled" : "" %>>
                    Add Member
                </button>

            </div>

            <% if (availableEmployees.isEmpty()) { %>
                <p class="empty">
                    There are no additional employees available to assign.
                </p>
            <% } %>

        </form>
    </div>

    <!-- CURRENT MEMBERS -->
    <div class="card">

        <h2>Current Members</h2>

        <div class="member-list">

            <% if (members.isEmpty()) { %>

                <div class="empty">
                    No employees are currently assigned to this project.
                </div>

            <% } else { %>

                <% for (Employee member : members) { %>

                    <% if (member != null) { %>

                        <div class="member-row">

                            <div class="member-info">

                                <div class="member-name">
                                    <%= escapeHtml(member.getFirstName()) %>
                                    <%= escapeHtml(member.getLastName()) %>
                                </div>

                                <div class="member-id">
                                    Employee ID:
                                    <%= escapeHtml(member.getId()) %>
                                </div>

                            </div>

                            <form class="remove-form"
                                  method="post"
                                  action="<%= escapeHtml(contextPath) %>/projects"
                                  onsubmit="return confirm('Remove this employee from the project?');">

                                <input type="hidden"
                                       name="action"
                                       value="removeMember">

                                <input type="hidden"
                                       name="projectId"
                                       value="<%= project.getId() %>">

                                <input type="hidden"
                                       name="employeeId"
                                       value="<%= member.getId() %>">

                                <button type="submit" class="remove-btn">
                                    Remove
                                </button>

                            </form>

                        </div>

                    <% } %>

                <% } %>

            <% } %>

        </div>
    </div>

</div>

</body>
</html>
