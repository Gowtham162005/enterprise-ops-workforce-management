
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Projects - Manager</title>

    <style>
        * {
            box-sizing: border-box;
        }

        html, body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: Arial, Helvetica, sans-serif;
            background: #f5f7fb;
            color: #1f2937;
        }

        .main-content {
            width: calc(100% - 240px);
            min-height: 100vh;
            margin-left: 240px;
            padding: 95px 30px 50px;
        }

        .page-content {
            width: min(1400px, 100%);
            margin: 0 auto;
        }

        .page-header {
            margin-bottom: 26px;
        }

        .page-header h1 {
            margin: 0 0 8px;
            color: #111827;
            font-size: 30px;
        }

        .page-header p {
            margin: 0;
            color: #6b7280;
            font-size: 15px;
        }

        .card {
            overflow: hidden;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
        }

        .card-header {
            padding: 22px 24px;
            border-bottom: 1px solid #e5e7eb;
        }

        .card-header h2 {
            margin: 0 0 7px;
            color: #111827;
            font-size: 20px;
        }

        .card-header p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            min-width: 700px;
            border-collapse: collapse;
        }

        th, td {
            padding: 15px 18px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            vertical-align: middle;
            overflow-wrap: anywhere;
        }

        th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
        }

        td {
            color: #374151;
            font-size: 14px;
        }

        tbody tr:hover {
            background: #f9fafb;
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .project-name {
            color: #111827;
            font-weight: 700;
        }

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status-active {
            background: #dcfce7;
            color: #166534;
        }

        .status-other {
            background: #f3f4f6;
            color: #4b5563;
        }

        .empty {
            padding: 55px 20px;
            text-align: center;
        }

        .empty h3 {
            margin: 0 0 8px;
            color: #374151;
        }

        .empty p {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
        }

        @media (max-width: 600px) {
            .main-content {
                width: 100%;
                margin-left: 0;
                padding: 85px 12px 30px;
            }

            .page-header h1 {
                font-size: 25px;
            }

            .card-header {
                padding: 18px;
            }
        }
    </style>
</head>

<body>
<div class="page">

    <%@ include file="/WEB-INF/views/sidebar.jspf" %>
    <%@ include file="/WEB-INF/views/topbar.jspf" %>

    <main class="main-content">
        <div class="page-content">

            <header class="page-header">
                <h1>My Projects</h1>
                <p>View the projects managed by you.</p>
            </header>

            <section class="card">
                <div class="card-header">
                    <h2>Projects Assigned to Me</h2>
                    <p>Projects assigned to your manager account.</p>
                </div>

                <div class="table-container">
                    <c:choose>
                        <c:when test="${not empty projects}">
                            <table>
                                <thead>
                                    <tr>
                                        <th>Project ID</th>
                                        <th>Project Name</th>
                                        <th>Description</th>
                                        <th>Manager</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="project" items="${projects}">
                                        <tr>
                                            <td>${project.id}</td>

                                            <td>
                                                <span class="project-name">
                                                    <c:out value="${project.name}" />
                                                </span>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty project.description}">
                                                        <c:out value="${project.description}" />
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty project.manager}">
                                                        <c:out value="${project.manager.firstName}" />
                                                        <c:out value="${project.manager.lastName}" />
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${project.status eq 'ACTIVE'}">
                                                        <span class="status status-active">
                                                            ACTIVE
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status status-other">
                                                            <c:out value="${project.status}" />
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>

                        <c:otherwise>
                            <div class="empty">
                                <h3>No Projects Found</h3>
                                <p>No projects are currently assigned to you.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>

        </div>
    </main>
</div>
</body>
</html>
