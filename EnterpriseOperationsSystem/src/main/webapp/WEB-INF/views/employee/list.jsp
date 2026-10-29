
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Employee" %>

<%
    List<Employee> employees =
            (List<Employee>) request.getAttribute("employees");

    String keyword = (String) request.getAttribute("keyword");
    if (keyword == null) {
        keyword = "";
    }

    String success = (String) request.getAttribute("success");
    String error = (String) request.getAttribute("error");
    String resetUsername = (String) request.getAttribute("resetUsername");
    String temporaryPassword =
            (String) request.getAttribute("temporaryPassword");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Employee Management</title>

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

        .employee-page {
            display: block;
            width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 26px;
            color: #111827;
        }

        .page-header p {
            margin: 7px 0 0;
            color: #6b7280;
            font-size: 14px;
        }

        .btn {
            display: inline-block;
            padding: 10px 16px;
            border-radius: 6px;
            border: none;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            box-sizing: border-box;
        }

        .btn-primary {
            background: #2563eb;
            color: white;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-danger {
            background: #dc2626;
            color: white;
        }

        .btn-danger:hover {
            background: #b91c1c;
        }

        .btn-secondary {
            background: #6b7280;
            color: white;
        }

        .btn-secondary:hover {
            background: #4b5563;
        }

        .btn-warning {
            background: #d97706;
            color: white;
        }

        .btn-warning:hover {
            background: #b45309;
        }

        .btn-small {
            padding: 7px 11px;
            font-size: 13px;
        }

        .search-box {
            display: flex;
            gap: 10px;
            align-items: center;
            margin-bottom: 20px;
        }

        .search-box input {
            width: 320px;
            max-width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            box-sizing: border-box;
        }

        .search-box input:focus {
            outline: none;
            border-color: #2563eb;
        }

        .table-container {
            width: 100%;
            background: white;
            border-radius: 10px;
            overflow-x: auto;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
        }

        table {
            width: 100%;
            min-width: 1000px;
            border-collapse: collapse;
        }

        th, td {
            padding: 14px 16px;
            text-align: left;
            border-bottom: 1px solid #eee;
        }

        th {
            background: #f8fafc;
            color: #374151;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.03em;
        }

        td {
            color: #374151;
            font-size: 14px;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        .status {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-inactive {
            background: #fee2e2;
            color: #991b1b;
        }

        .actions {
            display: flex;
            gap: 7px;
            align-items: center;
            flex-wrap: wrap;
        }

        .actions form {
            margin: 0;
        }

        .alert {
            padding: 14px 16px;
            margin-bottom: 18px;
            border-radius: 7px;
            font-size: 14px;
            overflow-wrap: anywhere;
        }

        .alert-success {
            background: #dcfce7;
            border: 1px solid #86efac;
            color: #166534;
        }

        .alert-error {
            background: #fee2e2;
            border: 1px solid #fca5a5;
            color: #991b1b;
        }

        .temporary-password {
            display: inline-block;
            padding: 8px 10px;
            margin: 8px 0;
            border-radius: 5px;
            background: white;
            border: 1px solid #bbf7d0;
            font-family: monospace;
            font-size: 15px;
            font-weight: bold;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6b7280;
        }

        @media (max-width: 768px) {
            .employee-page {
                padding: 85px 20px 25px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .search-box {
                flex-wrap: wrap;
            }

            .search-box input {
                width: 100%;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
            }

            .employee-page {
                padding: 80px 12px 20px;
            }
        }
    </style>
</head>

<body>
<div class="app-layout">

    <%@ include file="../sidebar.jspf" %>

    <div class="main-content">

        <%@ include file="../topbar.jspf" %>

        <main class="employee-page content-layout">

            <div class="page-header">
                <div>
                    <h1>Employee Management</h1>
                    <p>Manage employees and workforce information</p>
                </div>

                <a href="${pageContext.request.contextPath}/employees?action=add"
                   class="btn btn-primary">
                    + Add Employee
                </a>
            </div>

            <%-- Success message --%>
            <% if (success != null) { %>
                <div class="alert alert-success">
                    <strong><%= success %></strong>

                    <% if (resetUsername != null
                            && temporaryPassword != null) { %>

                        <p>
                            Username:
                            <strong><%= resetUsername %></strong>
                        </p>

                        <p>Temporary password:</p>

                        <div class="temporary-password"
                             id="temporaryPassword">
                            <%= temporaryPassword %>
                        </div>

                        <p>
                            Share these credentials securely.
                            The employee must change the password after
                            logging in. This password will not be shown
                            again after you leave or refresh this page.
                        </p>

                        <button type="button"
                                class="btn btn-secondary btn-small"
                                onclick="copyTemporaryPassword()">
                            Copy Temporary Password
                        </button>

                    <% } %>
                </div>
            <% } %>

            <%-- Error message --%>
            <% if (error != null) { %>
                <div class="alert alert-error">
                    <strong><%= error %></strong>
                </div>
            <% } %>

            <%-- Search --%>
            <form method="get"
                  action="${pageContext.request.contextPath}/employees"
                  class="search-box">

                <input type="hidden" name="action" value="search">

                <input type="text"
                       name="keyword"
                       value="<%= keyword %>"
                       placeholder="Search employee...">

                <button type="submit" class="btn btn-primary">
                    Search
                </button>

                <a href="${pageContext.request.contextPath}/employees"
                   class="btn btn-secondary">
                    Reset
                </a>
            </form>

            <%-- Employee table --%>
            <div class="table-container">
                <table>
                    <thead>
                    <tr>
                        <th>Code</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Job Title</th>
                        <th>Department</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>

                    <tbody>
                    <%
                        if (employees != null && !employees.isEmpty()) {
                            for (Employee employee : employees) {

                                String status = employee.getStatus();

                                boolean active =
                                        "ACTIVE".equalsIgnoreCase(status);
                    %>

                    <tr>
                        <td><%= employee.getEmployeeCode() %></td>

                        <td>
                            <%= employee.getFirstName() %>
                            <%
                                if (employee.getLastName() != null
                                        && !employee.getLastName()
                                                   .trim().isEmpty()) {
                            %>
                                <%= employee.getLastName() %>
                            <%
                                }
                            %>
                        </td>

                        <td>
                            <%= employee.getEmail() != null
                                    ? employee.getEmail() : "-" %>
                        </td>

                        <td>
                            <%= employee.getJobTitle() != null
                                    ? employee.getJobTitle() : "-" %>
                        </td>

                        <td>
                            <%
                                if (employee.getDepartment() != null) {
                            %>
                                <%= employee.getDepartment().getName() %>
                            <%
                                } else {
                            %>
                                -
                            <%
                                }
                            %>
                        </td>

                        <td>
                            <span class="status <%= active
                                    ? "status-active"
                                    : "status-inactive" %>">
                                <%= status != null ? status : "UNKNOWN" %>
                            </span>
                        </td>

                        <td>
                            <div class="actions">

                                <a href="${pageContext.request.contextPath}/employees?action=edit&id=<%= employee.getId() %>"
                                   class="btn btn-secondary btn-small">
                                    Edit
                                </a>

                                <%-- Reset login password --%>
                                <form method="post"
                                      action="${pageContext.request.contextPath}/employees"
                                      onsubmit="return confirm('Reset this employee password? The current password will stop working.');">

                                    <input type="hidden"
                                           name="action"
                                           value="resetPassword">

                                    <input type="hidden"
                                           name="id"
                                           value="<%= employee.getId() %>">

                                    <button type="submit"
                                            class="btn btn-warning btn-small">
                                        Reset Password
                                    </button>
                                </form>

                                <% if (active) { %>

                                    <form method="post"
                                          action="${pageContext.request.contextPath}/employees"
                                          onsubmit="return confirm('Are you sure you want to deactivate this employee?');">

                                        <input type="hidden"
                                               name="action"
                                               value="deactivate">

                                        <input type="hidden"
                                               name="id"
                                               value="<%= employee.getId() %>">

                                        <button type="submit"
                                                class="btn btn-danger btn-small">
                                            Deactivate
                                        </button>
                                    </form>

                                <% } %>

                            </div>
                        </td>
                    </tr>

                    <%
                            }
                        } else {
                    %>

                    <tr>
                        <td colspan="7" class="empty-state">
                            No employees found.
                        </td>
                    </tr>

                    <%
                        }
                    %>
                    </tbody>
                </table>
            </div>

        </main>
    </div>
</div>

<script>
    function copyTemporaryPassword() {
        var passwordElement =
            document.getElementById("temporaryPassword");

        if (!passwordElement) {
            return;
        }

        var password = passwordElement.textContent.trim();

        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(password)
                .then(function () {
                    alert("Temporary password copied.");
                })
                .catch(function () {
                    alert("Copy failed. Please copy the password manually.");
                });
        } else {
            alert("Automatic copy is unavailable. Please copy the password manually.");
        }
    }
</script>

</body>
</html>