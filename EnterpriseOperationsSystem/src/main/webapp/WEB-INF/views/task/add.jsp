<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Add Task | Enterprise Operations</title>

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

			<h1>Create New Task</h1>

			<p>Add a task and assign it to a project and employee.</p>

		</div>

		<div class="card">

			<h2 class="section-title">Task Information</h2>

			<form action="${pageContext.request.contextPath}/tasks" method="post">

				<input type="hidden" name="action" value="add">

				<div class="form-grid">

					<!-- Task Code -->

					<div class="form-group">

						<label> Task Code <span class="required">*</span>
						</label> <input type="text" name="taskCode" placeholder="Example: TSK001"
							required> <span class="hint"> Enter a unique task
							code. </span>

					</div>


					<!-- Task Title -->

					<div class="form-group">

						<label> Task Title <span class="required">*</span>
						</label> <input type="text" name="title" placeholder="Enter task title"
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
                        %>

							<option value="<%= project.getId() %>">
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
                        %>

							<option value="<%= employee.getId() %>">

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

							<option value="LOW">Low</option>

							<option value="MEDIUM" selected>Medium</option>

							<option value="HIGH">High</option>

							<option value="CRITICAL">Critical</option>

						</select>

					</div>


					<!-- Status -->

					<div class="form-group">

						<label> Status </label> <select name="status">

							<option value="TODO" selected>To Do</option>

							<option value="IN_PROGRESS">In Progress</option>

							<option value="COMPLETED">Completed</option>

							<option value="BLOCKED">Blocked</option>

						</select>

					</div>


					<!-- Start Date -->

					<div class="form-group">

						<label> Start Date </label> <input type="date" name="startDate">

					</div>


					<!-- Due Date -->

					<div class="form-group">

						<label> Due Date </label> <input type="date" name="dueDate">

					</div>


					<!-- Progress -->

					<div class="form-group">

						<label> Progress (%) </label> <input type="number" name="progress"
							min="0" max="100" value="0"> <span class="hint">
							Enter a value between 0 and 100. </span>

					</div>


					<!-- Description -->

					<div class="form-group full">

						<label> Description </label>

						<textarea name="description" placeholder="Describe the task..."></textarea>

					</div>

				</div>


				<div class="actions">

					<a href="${pageContext.request.contextPath}/tasks"
						class="btn btn-secondary"> Cancel </a>

					<button type="submit" class="btn btn-primary">Create Task
					</button>

				</div>

			</form>

		</div>

	</div>

</body>
</html>