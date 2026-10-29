<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Apply Leave</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f4f7fb;
}

.container {
	max-width: 850px;
	margin: 40px auto;
	padding: 20px;
}

.card {
	background: white;
	padding: 30px;
	border-radius: 16px;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.08);
}

h1 {
	margin-top: 0;
}

.subtitle {
	color: #64748b;
	margin-bottom: 30px;
}

.info-box {
	background: #eff6ff;
	border: 1px solid #bfdbfe;
	color: #1e40af;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 25px;
	font-size: 13px;
}

.form-grid {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 20px;
}

.full {
	grid-column: 1/-1;
}

label {
	display: block;
	font-weight: bold;
	margin-bottom: 8px;
}

input, select, textarea {
	width: 100%;
	box-sizing: border-box;
	padding: 12px;
	border: 1px solid #cbd5e1;
	border-radius: 8px;
	font-size: 14px;
}

textarea {
	min-height: 110px;
	resize: vertical;
}

.actions {
	margin-top: 25px;
	display: flex;
	gap: 12px;
}

button, .cancel {
	padding: 12px 20px;
	border-radius: 8px;
	border: none;
	text-decoration: none;
	font-weight: bold;
	cursor: pointer;
}

button {
	background: #2563eb;
	color: white;
}

.cancel {
	background: #e2e8f0;
	color: #334155;
}

@media ( max-width :700px) {
	.form-grid {
		grid-template-columns: 1fr;
	}
	.full {
		grid-column: auto;
	}
}
</style>

</head>

<body>

	<div class="container">

		<div class="card">

			<h1>Apply for Leave</h1>

			<div class="subtitle">Submit a new employee leave request</div>

			<div class="info-box">
				New leave requests are automatically submitted with <strong>PENDING</strong>
				status and must be reviewed by a manager or administrator.
			</div>

			<form method="post"
				action="${pageContext.request.contextPath}/leaves">

				<input type="hidden" name="action" value="add">

				<div class="form-grid">

					<div class="full">

						<label>Employee</label> <select name="employeeId" required>

							<option value="">Select Employee</option>

							<c:forEach var="employee" items="${employees}">

								<option value="${employee.id}">${employee.firstName}
									${employee.lastName}</option>

							</c:forEach>

						</select>

					</div>

					<div>

						<label>Leave Type</label> <select name="leaveType" required>

							<option value="">Select Leave Type</option>

							<option value="CASUAL">Casual</option>

							<option value="SICK">Sick</option>

							<option value="ANNUAL">Annual</option>

							<option value="MATERNITY">Maternity</option>

							<option value="PATERNITY">Paternity</option>

							<option value="UNPAID">Unpaid</option>

						</select>

					</div>

					<div>

						<label>Start Date</label> <input type="date" name="startDate"
							required>

					</div>

					<div>

						<label>End Date</label> <input type="date" name="endDate" required>

					</div>

					<div class="full">

						<label>Reason</label>

						<textarea name="reason" placeholder="Enter reason for leave"></textarea>

					</div>

				</div>

				<div class="actions">

					<button type="submit">Submit Leave Request</button>

					<a class="cancel" href="${pageContext.request.contextPath}/leaves">
						Cancel </a>

				</div>

			</form>

		</div>

	</div>

</body>

</html>