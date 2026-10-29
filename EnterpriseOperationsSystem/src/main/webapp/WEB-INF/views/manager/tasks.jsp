
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Tasks - Manager</title>

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
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 20px;
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
            line-height: 1.5;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
            flex-shrink: 0;
        }

        .back-btn,
        .create-task-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 10px 16px;
            border-radius: 6px;
            color: #fff;
            text-decoration: none;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s ease;
        }

        .back-btn {
            background: #6b7280;
            border: 1px solid #6b7280;
        }

        .back-btn:hover {
            background: #4b5563;
        }

        .create-task-btn {
            background: #2563eb;
            border: 1px solid #2563eb;
        }

        .create-task-btn:hover {
            background: #1d4ed8;
        }

        .card {
            overflow: hidden;
            background: #fff;
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
            line-height: 1.5;
        }

        .table-container {
            width: 100%;
            overflow-x: auto;
        }

        .task-table {
            width: 100%;
            min-width: 1100px;
            border-collapse: collapse;
        }

        .task-table th,
        .task-table td {
            padding: 15px 18px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            vertical-align: middle;
        }

        .task-table th {
            background: #f8fafc;
            color: #475569;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            white-space: nowrap;
        }

        .task-table td {
            color: #374151;
            font-size: 14px;
            line-height: 1.5;
        }

        .task-table tbody tr:hover {
            background: #f9fafb;
        }

        .task-table tbody tr:last-child td {
            border-bottom: none;
        }

        .task-code {
            color: #475569;
            font-weight: 700;
            white-space: nowrap;
        }

        .task-title {
            color: #111827;
            font-weight: 700;
        }

        .description {
            max-width: 240px;
            color: #6b7280;
            overflow-wrap: anywhere;
        }

        .badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
            white-space: nowrap;
        }

        .status-todo {
            background: #f3f4f6;
            color: #4b5563;
        }

        .status-progress {
            background: #fef3c7;
            color: #92400e;
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
            background: #e5e7eb;
            color: #374151;
        }

        .priority-high,
        .priority-critical {
            background: #fee2e2;
            color: #991b1b;
        }

        .priority-medium {
            background: #fef3c7;
            color: #92400e;
        }

        .priority-low {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .progress-container {
            width: 120px;
        }

        .progress-bar {
            width: 100%;
            height: 8px;
            overflow: hidden;
            background: #e5e7eb;
            border-radius: 10px;
        }

        .progress-fill {
            height: 100%;
            background: #2563eb;
            border-radius: 10px;
        }

        .progress-text {
            margin-top: 5px;
            color: #6b7280;
            font-size: 12px;
        }

        .date-value {
            white-space: nowrap;
        }

        .empty {
            padding: 55px 20px;
            text-align: center;
        }

        .empty h3 {
            margin: 0 0 8px;
            color: #374151;
            font-size: 20px;
        }

        .empty p {
            margin: 0 0 18px;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.6;
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

        .notice-error {
            color: #991b1b;
            background: #fee2e2;
            border: 1px solid #fecaca;
        }

        /* Modal */

        .modal-overlay {
            display: none;
            position: fixed;
            inset: 0;
            z-index: 10000;
            padding: 20px;
            overflow-y: auto;
            background: rgba(15, 23, 42, 0.55);
            align-items: center;
            justify-content: center;
        }

        .modal-overlay.open {
            display: flex;
        }

        .task-modal {
            width: 100%;
            max-width: 680px;
            margin: auto;
            overflow: hidden;
            border-radius: 12px;
            background: #fff;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.2);
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            padding: 22px 25px;
            border-bottom: 1px solid #e5e7eb;
        }

        .modal-header h2 {
            margin: 0;
            color: #111827;
            font-size: 20px;
        }

        .modal-close {
            border: 0;
            background: transparent;
            color: #6b7280;
            font-size: 28px;
            line-height: 1;
            cursor: pointer;
        }

        .task-form {
            padding: 25px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 7px;
            min-width: 0;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            color: #374151;
            font-size: 13px;
            font-weight: 600;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            background: #fff;
            color: #111827;
            font-family: inherit;
            font-size: 14px;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: 2px solid #bfdbfe;
            border-color: #2563eb;
        }

        .form-group textarea {
            min-height: 90px;
            resize: vertical;
        }

        .form-help {
            color: #6b7280;
            font-size: 12px;
            line-height: 1.4;
        }

        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 24px;
        }

        .cancel-btn,
        .submit-btn {
            padding: 10px 16px;
            border-radius: 7px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
        }

        .cancel-btn {
            border: 1px solid #d1d5db;
            background: #fff;
            color: #374151;
        }

        .submit-btn {
            border: 1px solid #2563eb;
            background: #2563eb;
            color: #fff;
        }

        .submit-btn:disabled {
            opacity: 0.55;
            cursor: not-allowed;
        }

        @media (max-width: 900px) {
            .main-content {
                padding-right: 20px;
                padding-left: 20px;
            }

            .page-header h1 {
                font-size: 27px;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                width: calc(100% - 220px);
                margin-left: 220px;
                padding: 85px 12px 30px;
            }

            .page-header {
                align-items: flex-start;
                flex-direction: column;
                gap: 15px;
            }

            .header-actions {
                width: 100%;
            }

            .page-header h1 {
                font-size: 25px;
            }

            .page-header p {
                font-size: 14px;
            }

            .card-header {
                padding: 18px;
            }

            .task-table th,
            .task-table td {
                padding: 12px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.full-width {
                grid-column: auto;
            }

            .task-form {
                padding: 18px;
            }

            .modal-header {
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

            <!-- Page heading -->
            <header class="page-header">
                <div>
                    <h1>My Tasks</h1>
                    <p>Tasks belonging to projects managed by you.</p>
                </div>

                <div class="header-actions">
                    <button type="button"
                            class="create-task-btn"
                            onclick="openCreateTaskModal()">
                        + Create Task
                    </button>

                    <a href="${pageContext.request.contextPath}/manager/dashboard"
                       class="back-btn">
                        Back to Dashboard
                    </a>
                </div>
            </header>

            <!-- Feedback messages -->
            <c:if test="${param.success eq 'created'}">
                <div class="notice notice-success">
                    Task created successfully.
                </div>
            </c:if>

            <c:if test="${param.success eq 'updated'}">
                <div class="notice notice-success">
                    Task updated successfully.
                </div>
            </c:if>

            <c:if test="${param.error eq 'createFailed'}">
                <div class="notice notice-error">
                    The task could not be created. Please check your input and try again.
                </div>
            </c:if>

            <!-- Tasks card -->
            <section class="card">

                <div class="card-header">
                    <h2>Tasks Assigned to My Projects</h2>
                    <p>View task details, priorities, status, progress, and deadlines.</p>
                </div>

                <div class="table-container">
                    <c:choose>

                        <c:when test="${not empty tasks}">
                            <table class="task-table">
                                <thead>
                                    <tr>
                                        <th>Task Code</th>
                                        <th>Title</th>
                                        <th>Description</th>
                                        <th>Project</th>
                                        <th>Assigned Employee</th>
                                        <th>Priority</th>
                                        <th>Status</th>
                                        <th>Progress</th>
                                        <th>Start Date</th>
                                        <th>Due Date</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="task" items="${tasks}">
                                        <tr>
                                            <td>
                                                <span class="task-code">
                                                    <c:out value="${task.taskCode}" default="-" />
                                                </span>
                                            </td>

                                            <td>
                                                <span class="task-title">
                                                    <c:out value="${task.title}" default="Untitled Task" />
                                                </span>
                                            </td>

                                            <td>
                                                <div class="description">
                                                    <c:choose>
                                                        <c:when test="${not empty task.description}">
                                                            <c:out value="${task.description}" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.project ne null}">
                                                        <c:out value="${task.project.name}" default="-" />
                                                    </c:when>
                                                    <c:otherwise>-</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.assignedEmployee ne null}">
                                                        <c:out value="${task.assignedEmployee.firstName}" />
                                                        <c:out value="${task.assignedEmployee.lastName}" />
                                                    </c:when>
                                                    <c:otherwise>Unassigned</c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.priority eq 'HIGH'}">
                                                        <span class="badge priority-high">HIGH</span>
                                                    </c:when>
                                                    <c:when test="${task.priority eq 'CRITICAL'}">
                                                        <span class="badge priority-critical">CRITICAL</span>
                                                    </c:when>
                                                    <c:when test="${task.priority eq 'LOW'}">
                                                        <span class="badge priority-low">LOW</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge priority-medium">
                                                            <c:out value="${task.priority}" default="MEDIUM" />
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:choose>
                                                    <c:when test="${task.status eq 'TODO'}">
                                                        <span class="badge status-todo">TODO</span>
                                                    </c:when>
                                                    <c:when test="${task.status eq 'IN_PROGRESS'}">
                                                        <span class="badge status-progress">IN PROGRESS</span>
                                                    </c:when>
                                                    <c:when test="${task.status eq 'COMPLETED'}">
                                                        <span class="badge status-completed">COMPLETED</span>
                                                    </c:when>
                                                    <c:when test="${task.status eq 'BLOCKED'}">
                                                        <span class="badge status-blocked">BLOCKED</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge status-default">
                                                            <c:out value="${task.status}" default="UNKNOWN" />
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>

                                            <td>
                                                <c:set var="taskProgress"
                                                       value="${task.progress ne null ? task.progress : 0}" />

                                                <c:set var="safeProgress"
                                                       value="${taskProgress lt 0 ? 0 : (taskProgress gt 100 ? 100 : taskProgress)}" />

                                                <div class="progress-container">
                                                    <div class="progress-bar">
                                                        <div class="progress-fill"
                                                             style="width: ${safeProgress}%;"></div>
                                                    </div>
                                                    <div class="progress-text">
                                                        <c:out value="${safeProgress}" />%
                                                    </div>
                                                </div>
                                            </td>

                                            <td>
                                                <span class="date-value">
                                                    <c:choose>
                                                        <c:when test="${task.startDate ne null}">
                                                            <c:out value="${task.startDate}" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>

                                            <td>
                                                <span class="date-value">
                                                    <c:choose>
                                                        <c:when test="${task.dueDate ne null}">
                                                            <c:out value="${task.dueDate}" />
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:when>

                        <c:otherwise>
                            <div class="empty">
                                <h3>No Tasks Found</h3>
                                <p>
                                    There are currently no tasks assigned to
                                    projects managed by you.
                                </p>
                                <button type="button"
                                        class="create-task-btn"
                                        onclick="openCreateTaskModal()">
                                    Create Your First Task
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </section>
        </div>
    </main>
</div>

<!-- CREATE TASK MODAL -->
<div id="createTaskModal"
     class="modal-overlay"
     role="dialog"
     aria-modal="true"
     aria-labelledby="createTaskTitle"
     onclick="handleModalOverlayClick(event)">

    <div class="task-modal">

        <div class="modal-header">
            <h2 id="createTaskTitle">Create Task</h2>

            <button type="button"
                    class="modal-close"
                    aria-label="Close modal"
                    onclick="closeCreateTaskModal()">
                &times;
            </button>
        </div>

        <form id="createTaskForm"
              class="task-form"
              method="post"
              action="${pageContext.request.contextPath}/manager/tasks">

            <input type="hidden" name="action" value="create">
            <input type="hidden" name="progress" value="0">

            <div class="form-grid">

                <div class="form-group">
                    <label for="taskCode">Task Code *</label>
                    <input type="text"
                           id="taskCode"
                           name="taskCode"
                           maxlength="50"
                           required>
                </div>

                <div class="form-group">
                    <label for="title">Task Title *</label>
                    <input type="text"
                           id="title"
                           name="title"
                           maxlength="150"
                           required>
                </div>

                <div class="form-group full-width">
                    <label for="description">Description</label>
                    <textarea id="description"
                              name="description"
                              maxlength="2000"
                              placeholder="Describe the task..."></textarea>
                </div>

                <div class="form-group">
                    <label for="projectId">Project *</label>
                    <select id="projectId"
                            name="projectId"
                            required>
                        <option value="">Select a project</option>

                        <c:forEach var="project" items="${projects}">
                            <option value="${project.id}">
                                <c:out value="${project.name}" />
                            </option>
                        </c:forEach>
                    </select>

                    <c:if test="${empty projects}">
                        <span class="form-help">
                            No projects are currently assigned to you.
                        </span>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="assignedEmployeeId">Assign Employee *</label>
                    <select id="assignedEmployeeId"
                            name="assignedEmployeeId"
                            required>
                        <option value="">Select an employee</option>

                        <c:forEach var="employee" items="${employees}">
                            <option value="${employee.id}">
                                <c:out value="${employee.firstName}" />
                                <c:out value="${employee.lastName}" />
                            </option>
                        </c:forEach>
                    </select>

                    <c:if test="${empty employees}">
                        <span class="form-help">
                            No employees were found in your department.
                        </span>
                    </c:if>
                </div>

                <div class="form-group">
                    <label for="priority">Priority *</label>
                    <select id="priority" name="priority" required>
                        <option value="LOW">Low</option>
                        <option value="MEDIUM" selected>Medium</option>
                        <option value="HIGH">High</option>
                        <option value="CRITICAL">Critical</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="status">Status *</label>
                    <select id="status" name="status" required>
                        <option value="TODO" selected>To Do</option>
                        <option value="IN_PROGRESS">In Progress</option>
                        <option value="BLOCKED">Blocked</option>
                        <option value="COMPLETED">Completed</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="startDate">Start Date</label>
                    <input type="date" id="startDate" name="startDate">
                </div>

                <div class="form-group">
                    <label for="dueDate">Due Date</label>
                    <input type="date" id="dueDate" name="dueDate">
                </div>
            </div>

            <div class="form-actions">
                <button type="button"
                        class="cancel-btn"
                        onclick="closeCreateTaskModal()">
                    Cancel
                </button>

                <button type="submit"
                        class="submit-btn"
                        <c:if test="${empty projects or empty employees}">
                            disabled
                        </c:if>>
                    Create Task
                </button>
            </div>
        </form>
    </div>
</div>

<script>
    function openCreateTaskModal() {
        var modal = document.getElementById("createTaskModal");

        if (!modal) {
            return;
        }

        modal.classList.add("open");
        document.body.style.overflow = "hidden";

        var taskCodeInput = document.getElementById("taskCode");

        if (taskCodeInput) {
            taskCodeInput.focus();
        }
    }

    function closeCreateTaskModal() {
        var modal = document.getElementById("createTaskModal");

        if (!modal) {
            return;
        }

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

                if (dueDate.value && startDate.value &&
                    dueDate.value < startDate.value) {
                    dueDate.value = "";
                }
            });

            dueDate.addEventListener("change", function() {
                if (startDate.value && dueDate.value &&
                    dueDate.value < startDate.value) {
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
