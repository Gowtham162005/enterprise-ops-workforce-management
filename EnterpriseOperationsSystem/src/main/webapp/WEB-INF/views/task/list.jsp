<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="com.enterpriseops.model.Task"%>
<%@ page import="com.enterpriseops.model.Project"%>
<%@ page import="com.enterpriseops.model.Employee"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Tasks | Enterprise Operations</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        * {
            box-sizing: border-box;
        }

        .task-page {
            width: 100%;
            min-width: 0;
            min-height: 100vh;
            padding: 95px 30px 30px;
            position: relative;
        }

        .task-page-header {
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 20px;
            margin-bottom: 25px;
            min-width: 0;
        }

        .task-page-header > div:first-child {
            min-width: 0;
        }

        .task-page-title {
            margin: 0 0 7px;
            font-size: 28px;
            font-weight: 700;
            color: #111827;
            letter-spacing: -0.5px;
            overflow-wrap: anywhere;
        }

        .task-page-subtitle {
            margin: 0;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        .create-task-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 11px 18px;
            border: 0;
            border-radius: 7px;
            background: #2563eb;
            color: #ffffff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            white-space: nowrap;
            flex-shrink: 0;
            cursor: pointer;
            transition: background 0.15s ease, transform 0.15s ease;
        }

        .create-task-btn:hover {
            background: #1d4ed8;
            color: #ffffff;
            transform: translateY(-1px);
        }

        .task-card {
            width: 100%;
            min-width: 0;
            background: #ffffff;
            border-radius: 10px;
            border: 1px solid #eef0f3;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            overflow: hidden;
        }

        .task-table-wrapper {
            width: 100%;
            min-width: 0;
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
        }

        .task-table {
            width: 100%;
            min-width: 950px;
            border-collapse: collapse;
        }

        .task-table th {
            padding: 15px;
            background: #f9fafb;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
            white-space: nowrap;
        }

        .task-table td {
            padding: 15px;
            border-bottom: 1px solid #eef0f2;
            font-size: 14px;
            color: #263238;
            vertical-align: middle;
        }

        .task-table tbody tr:last-child td {
            border-bottom: none;
        }

        .task-table tbody tr:hover {
            background: #fafafa;
        }

        .task-code {
            margin-bottom: 4px;
            font-weight: 700;
            color: #2563eb;
            white-space: nowrap;
        }

        .task-title {
            font-weight: 600;
            color: #111827;
            overflow-wrap: anywhere;
        }

        .muted {
            color: #9ca3af;
        }

        .badge {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
            white-space: nowrap;
        }

        .priority-low {
            background: #dcfce7;
            color: #166534;
        }

        .priority-medium {
            background: #fef3c7;
            color: #92400e;
        }

        .priority-high {
            background: #ffedd5;
            color: #c2410c;
        }

        .priority-critical {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-todo {
            background: #e5e7eb;
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

        .status-default {
            background: #f3f4f6;
            color: #374151;
        }

        .progress-container {
            width: 100px;
        }

        .progress-bar {
            width: 100%;
            height: 7px;
            background: #e5e7eb;
            border-radius: 10px;
            overflow: hidden;
            margin-bottom: 5px;
        }

        .progress-fill {
            height: 100%;
            background: #2563eb;
            border-radius: 10px;
        }

        .progress-text {
            font-size: 11px;
            color: #6b7280;
        }

        .actions {
            white-space: nowrap;
        }

        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 11px;
            margin-right: 5px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 12px;
            font-weight: 600;
        }

        .action-edit {
            background: #eef2ff;
            color: #4338ca;
        }

        .action-edit:hover {
            background: #e0e7ff;
            color: #312e81;
        }

        .empty {
            text-align: center;
            padding: 55px 20px;
            color: #6b7280;
        }

        .empty h3 {
            margin: 0 0 8px;
            color: #374151;
            font-size: 18px;
        }

        .empty p {
            margin: 0 0 20px;
            font-size: 14px;
            line-height: 1.5;
        }

        .notice {
            margin-bottom: 18px;
            padding: 12px 16px;
            border-radius: 7px;
            font-size: 14px;
        }

        .notice-success {
            color: #166534;
            background: #dcfce7;
            border: 1px solid #bbf7d0;
        }

        /* Create-task modal */

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 10000;
            background: rgba(15, 23, 42, 0.55);
            padding: 20px;
            overflow-y: auto;
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }

        .task-modal {
            width: 100%;
            max-width: 680px;
            background: #ffffff;
            border-radius: 12px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
            overflow: hidden;
            margin: auto;
        }

        .task-modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 22px 25px;
            border-bottom: 1px solid #e5e7eb;
        }

        .task-modal-header h2 {
            margin: 0;
            font-size: 20px;
            color: #111827;
        }

        .modal-close {
            border: 0;
            background: transparent;
            color: #6b7280;
            font-size: 26px;
            cursor: pointer;
            line-height: 1;
        }

        .task-form {
            padding: 25px;
        }

        .task-form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .task-form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
            min-width: 0;
        }

        .task-form-group.full-width {
            grid-column: 1 / -1;
        }

        .task-form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #374151;
        }

        .task-form-group input,
        .task-form-group select,
        .task-form-group textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            background: #ffffff;
            color: #111827;
            font: inherit;
            font-size: 14px;
        }

        .task-form-group textarea {
            min-height: 90px;
            resize: vertical;
        }

        .task-form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
        }

        .modal-cancel-btn,
        .modal-submit-btn {
            padding: 10px 16px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .modal-cancel-btn {
            border: 1px solid #d1d5db;
            background: #ffffff;
            color: #374151;
        }

        .modal-submit-btn {
            border: 1px solid #2563eb;
            background: #2563eb;
            color: #ffffff;
        }

        @media (max-width: 900px) {
            .task-page {
                padding: 85px 24px 24px;
            }

            .task-page-header {
                flex-direction: column;
                align-items: stretch;
            }

            .create-task-btn {
                width: fit-content;
                max-width: 100%;
            }
        }

        @media (max-width: 600px) {
            .task-page {
                padding: 80px 18px 20px;
            }

            .task-page-title {
                font-size: 24px;
            }

            .task-page-subtitle {
                font-size: 13px;
            }

            .task-table th,
            .task-table td {
                padding: 12px 10px;
            }

            .task-form-grid {
                grid-template-columns: 1fr;
            }

            .task-form-group.full-width {
                grid-column: auto;
            }

            .task-form {
                padding: 18px;
            }

            .task-modal-header {
                padding: 18px;
            }
        }
    </style>
</head>

<body>

<div class="app-layout">

    <%@ include file="../sidebar.jspf"%>

    <div class="main-content">

        <%@ include file="../topbar.jspf"%>

        <main class="task-page">

            <div class="task-page-header">
                <div>
                    <h1 class="task-page-title">My Tasks</h1>
                    <p class="task-page-subtitle">
                        Manage tasks for your projects and assign work to employees in your department.
                    </p>
                </div>

                <button type="button"
                        class="create-task-btn"
                        onclick="openCreateTaskModal()">
                    + Create Task
                </button>
            </div>

            <% if ("created".equals(request.getParameter("success"))) { %>
                <div class="notice notice-success">
                    Task created successfully.
                </div>
            <% } %>

            <% if ("updated".equals(request.getParameter("success"))) { %>
                <div class="notice notice-success">
                    Task updated successfully.
                </div>
            <% } %>

            <%
                List<Task> tasks =
                    (List<Task>) request.getAttribute("tasks");

                List<Project> projects =
                    (List<Project>) request.getAttribute("projects");

                List<Employee> employees =
                    (List<Employee>) request.getAttribute("employees");
            %>

            <div class="task-card">

                <% if (tasks == null || tasks.isEmpty()) { %>

                    <div class="empty">
                        <h3>No tasks found</h3>
                        <p>
                            Create a task for one of your assigned projects to get started.
                        </p>

                        <button type="button"
                                class="create-task-btn"
                                onclick="openCreateTaskModal()">
                            Create Task
                        </button>
                    </div>

                <% } else { %>

                    <div class="task-table-wrapper">
                        <table class="task-table">
                            <thead>
                            <tr>
                                <th>Task</th>
                                <th>Project</th>
                                <th>Assigned To</th>
                                <th>Priority</th>
                                <th>Status</th>
                                <th>Progress</th>
                                <th>Due Date</th>
                                <th>Actions</th>
                            </tr>
                            </thead>

                            <tbody>
                            <% for (Task task : tasks) {
                                String priority = task.getPriority() == null
                                    ? "MEDIUM" : task.getPriority();

                                String priorityClass = priority
                                    .trim().toLowerCase(java.util.Locale.ROOT);

                                String status = task.getStatus() == null
                                    ? "TODO" : task.getStatus();

                                String normalizedStatus = status
                                    .trim().toUpperCase(java.util.Locale.ROOT);

                                String statusClass;

                                if ("TODO".equals(normalizedStatus)) {
                                    statusClass = "status-todo";
                                } else if ("IN_PROGRESS".equals(normalizedStatus)
                                        || "IN PROGRESS".equals(normalizedStatus)) {
                                    statusClass = "status-progress";
                                } else if ("COMPLETED".equals(normalizedStatus)
                                        || "DONE".equals(normalizedStatus)) {
                                    statusClass = "status-completed";
                                } else if ("BLOCKED".equals(normalizedStatus)) {
                                    statusClass = "status-blocked";
                                } else {
                                    statusClass = "status-default";
                                }

                                int progress = task.getProgress() == null
                                    ? 0 : task.getProgress();

                                progress = Math.max(0, Math.min(100, progress));
                            %>
                                <tr>
                                    <td>
                                        <div class="task-code">
                                            <c:out value="<%= task.getTaskCode() %>" />
                                        </div>
                                        <div class="task-title">
                                            <c:out value="<%= task.getTitle() %>" />
                                        </div>
                                        <% if (task.getDescription() != null
                                                && !task.getDescription().trim().isEmpty()) { %>
                                            <div class="muted">
                                                <c:out value="<%= task.getDescription() %>" />
                                            </div>
                                        <% } %>
                                    </td>

                                    <td>
                                        <% if (task.getProject() != null) { %>
                                            <c:out value="<%= task.getProject().getName() %>" />
                                        <% } else { %>
                                            <span class="muted">Not assigned</span>
                                        <% } %>
                                    </td>

                                    <td>
                                        <% if (task.getAssignedEmployee() != null) { %>
                                            <c:out value="<%= task.getAssignedEmployee().getFirstName() %>" />
                                            <c:out value="<%= task.getAssignedEmployee().getLastName() %>" />
                                        <% } else { %>
                                            <span class="muted">Unassigned</span>
                                        <% } %>
                                    </td>

                                    <td>
                                        <span class="badge priority-<%= priorityClass %>">
                                            <c:out value="<%= priority %>" />
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge <%= statusClass %>">
                                            <c:out value="<%= status %>" />
                                        </span>
                                    </td>

                                    <td>
                                        <div class="progress-container">
                                            <div class="progress-bar">
                                                <div class="progress-fill"
                                                     style="width: <%= progress %>%;">
                                                </div>
                                            </div>
                                            <div class="progress-text">
                                                <%= progress %>% complete
                                            </div>
                                        </div>
                                    </td>

                                    <td>
                                        <% if (task.getDueDate() != null) { %>
                                            <%= task.getDueDate() %>
                                        <% } else { %>
                                            <span class="muted">Not set</span>
                                        <% } %>
                                    </td>

                                    <td class="actions">
                                        <span class="muted">—</span>
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

<!-- CREATE TASK MODAL -->

<div id="createTaskModal"
     class="modal-overlay"
     role="dialog"
     aria-modal="true"
     aria-labelledby="createTaskTitle"
     onclick="handleModalOverlayClick(event)">

    <div class="task-modal">

        <div class="task-modal-header">
            <h2 id="createTaskTitle">Create Task</h2>

            <button type="button"
                    class="modal-close"
                    aria-label="Close modal"
                    onclick="closeCreateTaskModal()">
                &times;
            </button>
        </div>

        <form class="task-form"
              method="post"
              action="${pageContext.request.contextPath}/manager/tasks">

            <input type="hidden" name="action" value="create">
            <input type="hidden" name="progress" value="0">

            <div class="task-form-grid">

                <div class="task-form-group">
                    <label for="taskCode">Task Code *</label>
                    <input type="text"
                           id="taskCode"
                           name="taskCode"
                           maxlength="50"
                           required>
                </div>

                <div class="task-form-group">
                    <label for="title">Task Title *</label>
                    <input type="text"
                           id="title"
                           name="title"
                           maxlength="150"
                           required>
                </div>

                <div class="task-form-group full-width">
                    <label for="description">Description</label>
                    <textarea id="description"
                              name="description"
                              maxlength="2000"
                              placeholder="Describe the task..."></textarea>
                </div>

                <div class="task-form-group">
                    <label for="projectId">Project *</label>
                    <select id="projectId"
                            name="projectId"
                            required>
                        <option value="">Select a project</option>

                        <% if (projects != null) {
                            for (Project project : projects) {
                                if (project != null && project.getId() != null) { %>
                                    <option value="<%= project.getId() %>">
                                        <c:out value="<%= project.getName() %>" />
                                    </option>
                        <%      }
                            }
                        } %>
                    </select>

                    <% if (projects == null || projects.isEmpty()) { %>
                        <small class="muted">
                            No projects are assigned to you yet.
                        </small>
                    <% } %>
                </div>

                <div class="task-form-group">
                    <label for="assignedEmployeeId">Assign Employee *</label>
                    <select id="assignedEmployeeId"
                            name="assignedEmployeeId"
                            required>
                        <option value="">Select an employee</option>

                        <% if (employees != null) {
                            for (Employee employee : employees) {
                                if (employee != null && employee.getId() != null) { %>
                                    <option value="<%= employee.getId() %>">
                                        <c:out value="<%= employee.getFirstName() %>" />
                                        <c:out value="<%= employee.getLastName() %>" />
                                    </option>
                        <%      }
                            }
                        } %>
                    </select>

                    <% if (employees == null || employees.isEmpty()) { %>
                        <small class="muted">
                            No employees were found in your department.
                        </small>
                    <% } %>
                </div>

                <div class="task-form-group">
                    <label for="priority">Priority *</label>
                    <select id="priority"
                            name="priority"
                            required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM" selected>Medium</option>
                        <option value="HIGH">High</option>
                        <option value="CRITICAL">Critical</option>
                    </select>
                </div>

                <div class="task-form-group">
                    <label for="status">Status *</label>
                    <select id="status"
                            name="status"
                            required>
                        <option value="TODO" selected>To Do</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="BLOCKED">Blocked</option>
                        <option value="COMPLETED">Completed</option>
                    </select>
                </div>

                <div class="task-form-group">
                    <label for="startDate">Start Date</label>
                    <input type="date"
                           id="startDate"
                           name="startDate">
                </div>

                <div class="task-form-group">
                    <label for="dueDate">Due Date</label>
                    <input type="date"
                           id="dueDate"
                           name="dueDate">
                </div>

            </div>

            <div class="task-form-actions">
                <button type="button"
                        class="modal-cancel-btn"
                        onclick="closeCreateTaskModal()">
                    Cancel
                </button>

                <button type="submit"
                        class="modal-submit-btn"
                        <% if (projects == null || projects.isEmpty()
                                || employees == null || employees.isEmpty()) { %>
                            disabled
                        <% } %>>
                    Create Task
                </button>
            </div>

        </form>
    </div>
</div>

<script>
    function openCreateTaskModal() {
        var modal = document.getElementById("createTaskModal");
        if (!modal) return;

        modal.classList.add("open");
        document.body.style.overflow = "hidden";

        var firstField = document.getElementById("taskCode");
        if (firstField) {
            firstField.focus();
        }
    }

    function closeCreateTaskModal() {
        var modal = document.getElementById("createTaskModal");
        if (!modal) return;

        modal.classList.remove("open");
        document.body.style.overflow = "";
    }

    function handleModalOverlayClick(event) {
        if (event.target === event.currentTarget) {
            closeCreateTaskModal();
        }
    }

    document.addEventListener("keydown", function(event) {
        if (event.key === "Escape") {
            closeCreateTaskModal();
        }
    });

    (function() {
        var startDate = document.getElementById("startDate");
        var dueDate = document.getElementById("dueDate");

        if (startDate && dueDate) {
            startDate.addEventListener("change", function() {
                dueDate.min = startDate.value || "";
            });

            dueDate.addEventListener("change", function() {
                if (startDate.value && dueDate.value
                        && dueDate.value < startDate.value) {
                    dueDate.setCustomValidity(
                        "Due date cannot be earlier than the start date."
                    );
                } else {
                    dueDate.setCustomValidity("");
                }
            });
        }
    })();
</script>

</body>
</html>