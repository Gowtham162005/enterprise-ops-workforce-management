<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>${empty department ? 'Add Department' : 'Edit Department'}
</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f4f6f9;
}

.header {
	background: #1f2937;
	color: white;
	padding: 20px 30px;
}

.container {
	width: 90%;
	max-width: 700px;
	margin: 30px auto;
}

.form-container {
	background: white;
	padding: 30px;
	border-radius: 8px;
	box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

.form-group {
	margin-bottom: 20px;
}

label {
	display: block;
	margin-bottom: 7px;
	font-weight: bold;
}

input, textarea {
	width: 100%;
	padding: 10px;
	border: 1px solid #ccc;
	border-radius: 5px;
	font-size: 14px;
}

textarea {
	height: 100px;
	resize: vertical;
}

button, a {
	padding: 10px 18px;
	border-radius: 5px;
	border: none;
	text-decoration: none;
	cursor: pointer;
}

button {
	background: #2563eb;
	color: white;
}

.cancel {
	background: #6b7280;
	color: white;
	margin-left: 10px;
}
</style>

</head>

<body>

	<div class="header">

		<h1>Enterprise Operations System</h1>

	</div>


	<div class="container">

		<div class="form-container">

			<h2>${empty department
                    ? 'Add Department'
                    : 'Edit Department'}
			</h2>


			<form method="post"
				action="${pageContext.request.contextPath}/departments">


				<input type="hidden" name="action"
					value="${empty department
                                ? 'add'
                                : 'update'}">


				<c:if test="${not empty department}">

					<input type="hidden" name="id" value="${department.id}">

				</c:if>


				<div class="form-group">

					<label>Department Name</label> <input type="text" name="name"
						value="${department.name}" required>

				</div>


				<div class="form-group">

					<label>Description</label>

					<textarea name="description">${department.description}</textarea>

				</div>


				<button type="submit">${empty department
                        ? 'Save Department'
                        : 'Update Department'}

				</button>


				<a class="cancel"
					href="${pageContext.request.contextPath}/departments"> Cancel </a>

			</form>

		</div>

	</div>

</body>

</html>