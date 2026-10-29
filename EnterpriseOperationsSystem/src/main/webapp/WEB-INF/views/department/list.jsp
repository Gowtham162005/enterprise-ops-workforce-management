
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.enterpriseops.model.Department"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Department Management</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        /* ==============================
           MAIN LAYOUT
           ============================== */

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

        /* ==============================
           DEPARTMENT PAGE
           ============================== */

        .department-page {
            width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        .department-container {
            width: 100%;
            max-width: 1200px;
            min-width: 0;
            margin: 0 auto;
        }

        .page-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 25px;
        }

        .page-header h1 {
            margin: 0;
            font-size: 26px;
            color: #111827;
        }

        .page-header p {
            margin: 6px 0 0;
            color: #6b7280;
            font-size: 14px;
        }

        /* ==============================
           BUTTONS
           ============================== */

        .add-btn {
            display: inline-block;
            padding: 11px 18px;
            background: #2563eb;
            color: #ffffff;
            border-radius: 7px;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
            box-sizing: border-box;
        }

        .add-btn:hover {
            background: #1d4ed8;
        }

        .actions {
            display: flex;
            gap: 8px;
            align-items: center;
            flex-wrap: wrap;
        }

        .edit-btn,
        .delete-btn {
            display: inline-block;
            padding: 8px 14px;
            color: #ffffff;
            border-radius: 6px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 600;
            box-sizing: border-box;
        }

        .edit-btn {
            background: #f59e0b;
        }

        .edit-btn:hover {
            background: #d97706;
        }

        .delete-btn {
            background: #dc2626;
        }

        .delete-btn:hover {
            background: #b91c1c;
        }

        /* ==============================
           DEPARTMENT TABLE
           ============================== */

        .department-card {
            width: 100%;
            min-width: 0;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
            overflow: hidden;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        .department-table {
            width: 100%;
            min-width: 750px;
            border-collapse: collapse;
        }

        .department-table th {
            padding: 14px;
            background: #f9fafb;
            color: #6b7280;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            white-space: nowrap;
        }

        .department-table td {
            padding: 15px 14px;
            border-top: 1px solid #e5e7eb;
            font-size: 14px;
            color: #374151;
            vertical-align: middle;
        }

        .department-name {
            font-weight: 600;
            color: #111827;
        }

        .description {
            color: #4b5563;
            overflow-wrap: anywhere;
        }

        .empty {
            padding: 50px 20px;
            text-align: center;
            color: #6b7280;
        }

        /* ==============================
           RESPONSIVE LAYOUT
           ============================== */

        @media (max-width: 800px) {
            .department-page {
                padding: 85px 20px 25px;
            }

            .page-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 15px;
            }

            .department-card {
                overflow: hidden;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
            }

            .department-page {
                padding: 80px 12px 20px;
            }

            .page-header h1 {
                font-size: 22px;
            }

            .page-header p {
                line-height: 1.5;
            }

            .add-btn {
                max-width: 100%;
                white-space: normal;
            }

            .department-table {
                min-width: 750px;
            }
        }
    </style>
</head>

<body>

    <div class="app-layout">

        <%@ include file="../sidebar.jspf"%>

        <div class="main-content">

            <%@ include file="../topbar.jspf"%>

            <main class="department-page">

                <div class="department-container">

                    <%
                        List<Department> departments =
                            (List<Department>) request.getAttribute("departments");
                    %>

                    <!-- PAGE HEADER -->
                    <div class="page-header">
                        <div>
                            <h1>Department Management</h1>
                            <p>Manage organizational departments.</p>
                        </div>

                        <a class="add-btn"
                           href="${pageContext.request.contextPath}/departments?action=add">
                            + Add Department
                        </a>
                    </div>

                    <!-- DEPARTMENT TABLE -->
                    <div class="department-card">

                        <%
                            if (departments == null || departments.isEmpty()) {
                        %>

                            <div class="empty">
                                No departments found.
                            </div>

                        <%
                            } else {
                        %>

                            <div class="table-container">

                                <table class="department-table">

                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Name</th>
                                            <th>Description</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>

                                    <tbody>

                                        <%
                                            for (Department department : departments) {
                                        %>

                                            <tr>
                                                <td>
                                                    <%= department.getId() %>
                                                </td>

                                                <td>
                                                    <div class="department-name">
                                                        <%= department.getName() %>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div class="description">
                                                        <%= department.getDescription() != null
                                                            ? department.getDescription()
                                                            : "-" %>
                                                    </div>
                                                </td>

                                                <td>
                                                    <div class="actions">

                                                        <a class="edit-btn"
                                                           href="${pageContext.request.contextPath}/departments?action=edit&id=<%= department.getId() %>">
                                                            Edit
                                                        </a>

                                                        <a class="delete-btn"
                                                           href="${pageContext.request.contextPath}/departments?action=delete&id=<%= department.getId() %>"
                                                           onclick="return confirm('Delete this department?');">
                                                            Delete
                                                        </a>

                                                    </div>
                                                </td>
                                            </tr>

                                        <%
                                            }
                                        %>

                                    </tbody>

                                </table>

                            </div>

                        <%
                            }
                        %>

                    </div>

                </div>

            </main>

        </div>

    </div>

</body>
</html>

