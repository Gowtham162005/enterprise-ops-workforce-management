<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Edit Task | Enterprise Operations</title>

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: Arial, Helvetica, sans-serif;
	background: #f4f6f9;
	color: #263238;
}

.page {
	max-width: 1000px;
	margin: 40px auto;
	padding: 0 20px;
}

.header {
	margin-bottom: 25px;
}

.header h1 {
	margin: 0 0 8px;
	font-size: 28px;
}

.header p {
	margin: 0;
	color: #6b7280;
}

.card {
	background: white;
	border-radius: 10px;
	padding: 30px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
}

.section-title {
	font-size: 18px;
	font-weight: bold;
	margin: 0 0 20px;
	padding-bottom: 12px;
	border-bottom: 1px solid #e5e7eb;
}

.form-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.full {
	grid-column: 1/-1;
}

.form-group {
	display: flex;
	flex-direction: column;
}

label {
	font-weight: 600;
	margin-bottom: 7px;
	font-size: 14px;
}

.required {
	color: #dc2626;
}

input, select, textarea {
	width: 100%;
	padding: 11px 12px;
	border: 1px solid #d1d5db;
	border-radius: 6px;
	font-size: 14px;
	outline: none;
	background: white;
}

input:focus, select:focus, textarea:focus {
	border-color: #2563eb;
	box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.12);
}

textarea {
	min-height: 110px;
	resize: vertical;
}

.hint {
	margin-top: 5px;
	font-size: 12px;
	color: #6b7280;
}

.actions {
	display: flex;
	justify-content: flex-end;
	gap: 12px;
	margin-top: 30px;
	padding-top: 20px;
	border-top: 1px solid #e5e7eb;
}

.btn {
	padding: 11px 22px;
	border-radius: 6px;
	text-decoration: none;
	border: none;
	cursor: pointer;
	font-size: 14px;
	font-weight: 600;
}

.btn-primary {
	background: #2563eb;
	color: white;
}

.btn-primary:hover {
	background: #1d4ed8;
}

.btn-secondary {
	background: #e5e7eb;
	color: #374151;
}

.btn-secondary:hover {
	background: #d1d5db;
}

@media ( max-width : 700px) {
	.form-grid {
		grid-template-columns: 1fr;
	}
	.full {
		grid-column: auto;
	}
	.card {
		padding: 20px;
	}
}
</style>

</head>

<body>

	<div class="page">

		<div class="header">

			<h1>Edit Task</h1>

			<p>Update task information and assignment details.</p>

		</div>

		<div class="card">

			<h2 class="section-title">Task Information</h2>

			<form action="${pageContext.request.contextPath}/tasks" method="post">

				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="id"
					value="<%= request.getAttribute("task") != null
                           ? ((com.enterpriseops.model.Task) request.getAttribute("task")).getId()
                           : "" %>">

				<%
                com.enterpriseops.model.Task task =
                    (com.enterpriseops.model.Task)
                    request.getAttribute("task");
            %>

				<div class="form-grid">

					<!-- Task Code -->

					<div class="form-group">

						<label> Task Code <span class="required">*</span>
						</label> <input type="text" name="taskCode"
							value="<%= task.getTaskCode() %>" required>

					</div>


					<!-- Task Title -->

					<div class="form-group">

						<label> Task Title <span class="required">*</span>
						</label> <input type="text" name="title" value="<%= task.getTitle() %>"
							required>

					</div>


					<!-- Project -->

					<div class="form-group">

						<label> Project <span class="required">*</span>
						</label> <select name="projectId" required>

							<option value="">Select Project</option>

							<%
                            java.util.List<com.enterpriseops.model.Project> projects =
                                (java.util.List<com.enterpriseops.model.Project>)
                                request.getAttribute("projects");

                            if (projects != null) {

                                for (com.enterpriseops.model.Project project : projects) {

                                    boolean selected =
                                        task.getProject() != null
                                        && project.getId().equals(
                                            task.getProject().getId()
                                        );
                        %>

							<option value="<%= project.getId() %>"
								<%= selected ? "selected" : "" %>>

								<%= project.getProjectCode() %> -
								<%= project.getName() %>

							</option>

							<%
                                }
                            }
                        %>

						</select>

					</div>


					<!-- Employee -->

					<div class="form-group">

						<label> Assign Employee </label> <select name="assignedEmployeeId">

							<option value="">Unassigned</option>

							<%
                            java.util.List<com.enterpriseops.model.Employee> employees =
                                (java.util.List<com.enterpriseops.model.Employee>)
                                request.getAttribute("employees");

                            if (employees != null) {

                                for (com.enterpriseops.model.Employee employee : employees) {

                                    boolean selected =
                                        task.getAssignedEmployee() != null
                                        && employee.getId().equals(
                                            task.getAssignedEmployee().getId()
                                        );
                        %>

							<option value="<%= employee.getId() %>"
								<%= selected ? "selected" : "" %>>

								<%= employee.getEmployeeCode() %> -
								<%= employee.getFirstName() %>

								<%
                                if (employee.getLastName() != null) {
                            %>

								<%= employee.getLastName() %>

								<%
                                }
                            %>

							</option>

							<%
                                }
                            }
                        %>

						</select>

					</div>


					<!-- Priority -->

					<div class="form-group">

						<label> Priority </label> <select name="priority">

							<option value="LOW"
								<%= "LOW".equals(task.getPriority()) ? "selected" : "" %>>
								Low</option>

							<option value="MEDIUM"
								<%= "MEDIUM".equals(task.getPriority()) ? "selected" : "" %>>
								Medium</option>

							<option value="HIGH"
								<%= "HIGH".equals(task.getPriority()) ? "selected" : "" %>>
								High</option>

							<option value="CRITICAL"
								<%= "CRITICAL".equals(task.getPriority()) ? "selected" : "" %>>
								Critical</option>

						</select>

					</div>


					<!-- Status -->

					<div class="form-group">

						<label> Status </label> <select name="status">

							<option value="TODO"
								<%= "TODO".equals(task.getStatus()) ? "selected" : "" %>>
								To Do</option>

							<option value="IN_PROGRESS"
								<%= "IN_PROGRESS".equals(task.getStatus()) ? "selected" : "" %>>
								In Progress</option>

							<option value="COMPLETED"
								<%= "COMPLETED".equals(task.getStatus()) ? "selected" : "" %>>
								Completed</option>

							<option value="BLOCKED"
								<%= "BLOCKED".equals(task.getStatus()) ? "selected" : "" %>>
								Blocked</option>

						</select>

					</div>


					<!-- Start Date -->

					<div class="form-group">

						<label> Start Date </label> <input type="date" name="startDate"
							value="<%= task.getStartDate() != null
                                   ? task.getStartDate()
                                   : "" %>">

					</div>


					<!-- Due Date -->

					<div class="form-group">

						<label> Due Date </label> <input type="date" name="dueDate"
							value="<%= task.getDueDate() != null
                                   ? task.getDueDate()
                                   : "" %>">

					</div>


					<!-- Progress -->

					<div class="form-group">

						<label> Progress (%) </label> <input type="number" name="progress"
							min="0" max="100"
							value="<%= task.getProgress() != null
                                   ? task.getProgress()
                                   : 0 %>">

					</div>


					<!-- Description -->

					<div class="form-group full">

						<label> Description </label>

						<textarea name="description"><%= task.getDescription() != null
                            ? task.getDescription()
                            : "" %></textarea>

					</div>

				</div>


				<div class="actions">

					<a href="${pageContext.request.contextPath}/tasks"
						class="btn btn-secondary"> Cancel </a>

					<button type="submit" class="btn btn-primary">Update Task
					</button>

				</div>

			</form>

		</div>

	</div>

</body>
</html>