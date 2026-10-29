
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List"%>
<%@ page import="com.enterpriseops.model.User"%>
<%@ page import="com.enterpriseops.model.Role"%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Manage User Roles - Enterprise Ops</title>

<style>
body {
	margin: 0;
	font-family: Arial, sans-serif;
	background: #f5f7fb;
	color: #172033;
}

.container {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 25px;
}

.header {
	margin-bottom: 25px;
}

.header h1 {
	margin: 0 0 8px;
	font-size: 30px;
}

.header p {
	margin: 0;
	color: #64748b;
}

.panel {
	background: white;
	border-radius: 12px;
	padding: 25px;
	box-shadow: 0 4px 15px rgba(0, 0, 0, 0.06);
}

.success {
	background: #dcfce7;
	color: #166534;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
}

.error {
	background: #fee2e2;
	color: #991b1b;
	padding: 12px 15px;
	border-radius: 8px;
	margin-bottom: 20px;
}

table {
	width: 100%;
	border-collapse: collapse;
}

th {
	text-align: left;
	background: #f8fafc;
	padding: 14px;
	border-bottom: 1px solid #e2e8f0;
}

td {
	padding: 14px;
	border-bottom: 1px solid #e2e8f0;
	vertical-align: middle;
}

.username {
	font-weight: 600;
}

.role {
	color: #475569;
}

select {
	padding: 9px 12px;
	border: 1px solid #cbd5e1;
	border-radius: 6px;
	min-width: 150px;
	background: white;
}

button {
	border: none;
	background: #2563eb;
	color: white;
	padding: 9px 16px;
	border-radius: 6px;
	cursor: pointer;
	font-weight: 600;
}

button:hover {
	background: #1d4ed8;
}

.empty {
	text-align: center;
	color: #64748b;
	padding: 30px;
}
</style>

</head>

<body>

	<div class="container">

		<div class="header">

			<h1>Manage User Roles</h1>

			<p>Assign system roles to users. Role changes affect application
				access.</p>

		</div>

		<%
        String success =
                request.getParameter("success");

        String error =
                (String) request.getAttribute("error");

        if ("1".equals(success)) {
    %>

		<div class="success">User role updated successfully.</div>

		<%
        }

        if (error != null) {
    %>

		<div class="error">
			<%= error %>
		</div>

		<%
        }

        List<User> users =
                (List<User>) request.getAttribute("users");

        List<Role> roles =
                (List<Role>) request.getAttribute("roles");
    %>

		<div class="panel">

			<table>

				<thead>

					<tr>
						<th>ID</th>
						<th>Username</th>
						<th>Employee</th>
						<th>Current Role</th>
						<th>Change Role</th>
						<th>Action</th>
					</tr>

				</thead>

				<tbody>

					<%
                if (users == null || users.isEmpty()) {
            %>

					<tr>
						<td colspan="6" class="empty">No users found.</td>
					</tr>

					<%
                } else {

                    for (User user : users) {
            %>

					<tr>

						<td><%= user.getId() %></td>

						<td class="username"><%= user.getUsername() %></td>

						<td>
							<%
                            if (user.getEmployee() != null) {
                        %> <%= user.getEmployee().getFirstName() %> <%= user.getEmployee().getLastName() %>

							<%
                            } else {
                        %> - <%
                            }
                        %>

						</td>

						<td class="role">
							<%
                            if (user.getRole() != null) {
                        %> <%= user.getRole().getName() %> <%
                            } else {
                        %> NONE <%
                            }
                        %>

						</td>

						<td>

							<form method="post"
								action="<%= request.getContextPath() %>/admin/user-roles">

								<input type="hidden" name="userId" value="<%= user.getId() %>">

								<select name="roleId">

									<%
                                    for (Role role : roles) {

                                        boolean selected =
                                                user.getRole() != null &&
                                                user.getRole().getId()
                                                        .equals(role.getId());
                                %>

									<option value="<%= role.getId() %>"
										<%= selected ? "selected" : "" %>>

										<%= role.getName() %>

									</option>

									<%
                                    }
                                %>

								</select>
						</td>

						<td>

							<button type="submit">Save</button>

							</form>

						</td>

					</tr>

					<%
                    }
                }
            %>

				</tbody>

			</table>

		</div>

	</div>

</body>
</html>

