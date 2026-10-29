<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Enterprise Operations System - Login</title>

<style>
* {
	box-sizing: border-box;
}

body {
	margin: 0;
	min-height: 100vh;
	display: flex;
	justify-content: center;
	align-items: center;
	font-family: Arial, sans-serif;
	background: #f4f6f9;
}

.login-container {
	width: 400px;
	background: white;
	padding: 35px;
	border-radius: 10px;
	box-shadow: 0 8px 25px rgba(0, 0, 0, 0.12);
}

h1 {
	margin: 0 0 8px;
	text-align: center;
	font-size: 26px;
}

.subtitle {
	text-align: center;
	color: #777;
	margin-bottom: 28px;
}

.form-group {
	margin-bottom: 18px;
}

label {
	display: block;
	margin-bottom: 7px;
	font-weight: bold;
}

input {
	width: 100%;
	padding: 12px;
	border: 1px solid #ccc;
	border-radius: 6px;
	font-size: 14px;
}

input:focus {
	outline: none;
	border-color: #555;
}

button {
	width: 100%;
	padding: 12px;
	border: none;
	border-radius: 6px;
	background: #1f2937;
	color: white;
	font-size: 15px;
	cursor: pointer;
}

button:hover {
	background: #111827;
}

.error {
	background: #fee2e2;
	color: #991b1b;
	padding: 10px;
	border-radius: 6px;
	margin-bottom: 18px;
	text-align: center;
}
</style>

</head>

<body>

	<div class="login-container">

		<h1>Enterprise Operations</h1>

		<div class="subtitle">Workforce Management System</div>

		<% if (request.getAttribute("error") != null) { %>

		<div class="error">
			<%= request.getAttribute("error") %>
		</div>

		<% } %>

		<form action="${pageContext.request.contextPath}/login" method="post">

			<div class="form-group">

				<label for="username"> Username </label> <input type="text"
					id="username" name="username" placeholder="Enter username" required>

			</div>

			<div class="form-group">

				<label for="password"> Password </label> <input type="password"
					id="password" name="password" placeholder="Enter password" required>

			</div>

			<button type="submit">Login</button>

		</form>

	</div>

</body>
</html>