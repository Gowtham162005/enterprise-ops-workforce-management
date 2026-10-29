
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Manager Management</title>

<style>
* { box-sizing: border-box; }

:root {
    --primary: #2563eb;
    --primary-hover: #1d4ed8;
    --danger: #dc2626;
    --success: #15803d;
    --text: #1e293b;
    --muted: #64748b;
    --border: #e2e8f0;
    --background: #f5f7fb;
}

body {
    margin: 0;
    padding: 26px;
    font-family: "Segoe UI", Arial, sans-serif;
    font-size: 14px;
    color: var(--text);
    background: var(--background);
}

.container {
    max-width: 1150px;
    margin: auto;
}

.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
}

.page-header h1 {
    margin: 0 0 6px;
    font-size: 26px;
}

.page-header p {
    margin: 0;
    color: var(--muted);
    font-size: 13px;
}

.section {
    background: #fff;
    border: 1px solid var(--border);
    border-radius: 12px;
    padding: 22px;
    margin-bottom: 20px;
    box-shadow: 0 3px 12px rgba(15, 23, 42, .035);
}

.section-heading {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
    margin-bottom: 18px;
}

.section-heading h2 {
    margin: 0;
    font-size: 17px;
}

.count {
    padding: 5px 10px;
    border-radius: 20px;
    background: #eff6ff;
    color: #1d4ed8;
    font-size: 12px;
    font-weight: 600;
}

.form-row {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 16px;
    margin-bottom: 16px;
}

.form-row.three {
    grid-template-columns: repeat(3, minmax(0, 1fr));
}

label {
    display: block;
    margin-bottom: 7px;
    font-size: 12px;
    font-weight: 600;
    color: #475569;
}

input, select {
    width: 100%;
    min-height: 40px;
    padding: 9px 11px;
    border: 1px solid #cbd5e1;
    border-radius: 7px;
    background: #fff;
    color: var(--text);
    font: inherit;
    outline: none;
}

input:focus, select:focus {
    border-color: var(--primary);
    box-shadow: 0 0 0 3px rgba(37, 99, 235, .1);
}

button {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    min-height: 36px;
    padding: 8px 13px;
    border: 1px solid transparent;
    border-radius: 7px;
    background: var(--primary);
    color: #fff;
    font: inherit;
    font-weight: 600;
    cursor: pointer;
}

button:hover { background: var(--primary-hover); }

button.secondary {
    color: #334155;
    background: #fff;
    border-color: var(--border);
}

button.secondary:hover { background: #f8fafc; }

button.danger {
    min-height: 29px;
    padding: 5px 9px;
    color: #b91c1c;
    background: #fff;
    border-color: #fecaca;
    font-size: 12px;
}

button.danger:hover { background: #fef2f2; }

button.success { background: var(--success); }
button.success:hover { background: #166534; }

.muted {
    color: var(--muted);
    font-size: 12px;
    line-height: 1.6;
}

.message {
    padding: 12px 15px;
    margin-bottom: 16px;
    border: 1px solid #bbf7d0;
    border-radius: 8px;
    background: #f0fdf4;
    color: #166534;
}

.message.error {
    border-color: #fecaca;
    background: #fef2f2;
    color: #991b1b;
}

.hidden { display: none !important; }

.form-actions {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 12px;
    flex-wrap: wrap;
}

.account-fields {
    margin-top: 16px;
    padding: 16px;
    border: 1px solid var(--border);
    border-radius: 9px;
    background: #f8fafc;
}

.table-wrapper { overflow-x: auto; }

table {
    width: 100%;
    border-collapse: collapse;
}

th {
    padding: 11px 13px;
    background: #f8fafc;
    color: var(--muted);
    font-size: 11px;
    text-align: left;
    text-transform: uppercase;
    letter-spacing: .4px;
    white-space: nowrap;
}

td {
    padding: 13px;
    border-bottom: 1px solid #edf0f5;
    vertical-align: top;
}

tbody tr:last-child td { border-bottom: none; }

.department-name { font-weight: 650; }

.department-description {
    max-width: 250px;
    color: var(--muted);
    font-size: 12px;
    line-height: 1.5;
}

.manager-list {
    display: flex;
    flex-direction: column;
    gap: 8px;
    min-width: 205px;
}

.manager-item {
    display: flex;
    align-items: center;
    justify-content: space-between;
    gap: 10px;
    padding: 8px;
    border: 1px solid #edf0f5;
    border-radius: 8px;
}

.manager-name {
    font-size: 12px;
    font-weight: 600;
}

.manager-id {
    margin-top: 3px;
    color: var(--muted);
    font-size: 11px;
}

.empty-state {
    padding: 16px;
    border: 1px dashed var(--border);
    border-radius: 8px;
    color: var(--muted);
    text-align: center;
}

.account-card {
    padding: 13px 0;
    border-bottom: 1px solid #edf0f5;
}

.account-card:first-of-type { padding-top: 0; }
.account-card:last-child { border-bottom: none; padding-bottom: 0; }

.account-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 12px;
}

.account-username {
    font-size: 14px;
    font-weight: 650;
    overflow-wrap: anywhere;
}

.account-editor {
    display: none;
    margin-top: 14px;
    padding: 16px;
    border: 1px solid var(--border);
    border-radius: 9px;
    background: #f8fafc;
}

.account-editor.open { display: block; }

.account-editor h3 {
    margin: 0 0 13px;
    font-size: 13px;
}

.account-editor hr {
    margin: 18px 0;
    border: 0;
    border-top: 1px solid var(--border);
}

.account-grid {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 12px;
}

.account-grid .full { grid-column: 1 / -1; }

@media (max-width: 760px) {
    body { padding: 14px; }
    .section { padding: 16px; }

    .form-row,
    .form-row.three,
    .account-grid {
        grid-template-columns: 1fr;
    }

    .account-grid .full { grid-column: auto; }
    .department-description { min-width: 160px; }
    .page-header h1 { font-size: 22px; }
}
</style>
</head>

<body>
<div class="container">

    <header class="page-header">
        <div>
            <h1>Manager Management</h1>
            <p>Manage department assignments and manager login accounts.</p>
        </div>
    </header>

    <c:if test="${not empty sessionScope.successMessage}">
        <div class="message" role="status">
            <c:out value="${sessionScope.successMessage}" />
        </div>
        <c:remove var="successMessage" scope="session" />
    </c:if>

    <c:if test="${not empty sessionScope.errorMessage}">
        <div class="message error" role="alert">
            <c:out value="${sessionScope.errorMessage}" />
        </div>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

    <!-- Assign Manager -->
    <section class="section">
        <div class="section-heading">
            <h2>Assign a Manager</h2>
        </div>

        <form id="assignForm"
              action="${pageContext.request.contextPath}/admin/managers"
              method="post">

            <input type="hidden" name="action" value="assign">

            <div class="form-row">
                <div>
                    <label for="departmentId">Department</label>
                    <select id="departmentId"
                            name="departmentId"
                            required
                            onchange="filterEmployees()">
                        <option value="">Select department</option>

                        <c:forEach var="department" items="${departments}">
                            <option value="${department.id}">
                                <c:out value="${department.name}" />
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="employeeId">Employee</label>
                    <select id="employeeId" name="employeeId" required>
                        <option value="">Select employee</option>

                        <c:forEach var="employee" items="${employees}">
                            <option value="${employee.id}"
                                    data-department="${employee.department.id}">
                                <c:out value="${employee.firstName}" />
                                <c:out value=" ${employee.lastName}" />
                                (ID: <c:out value="${employee.id}" />)
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <span class="muted">
                    Existing accounts can be promoted to MANAGER.
                </span>

                <button type="button"
                        class="secondary"
                        id="accountFieldsButton"
                        aria-expanded="false"
                        onclick="toggleNewAccount()">
                    + New Login Details
                </button>
            </div>

            <div id="newAccountFields" class="account-fields hidden">
                <p class="muted">
                    Fill these fields only when the employee does not
                    already have a login account.
                </p>

                <div class="form-row three">
                    <div>
                        <label for="newUsername">New username</label>
                        <input type="text"
                               id="newUsername"
                               name="username"
                               autocomplete="off"
                               placeholder="Enter username">
                    </div>

                    <div>
                        <label for="newPassword">New password</label>
                        <input type="password"
                               id="newPassword"
                               name="password"
                               minlength="8"
                               autocomplete="new-password"
                               placeholder="At least 8 characters">
                    </div>

                    <div>
                        <label for="newConfirmPassword">Confirm password</label>
                        <input type="password"
                               id="newConfirmPassword"
                               name="confirmPassword"
                               minlength="8"
                               autocomplete="new-password"
                               placeholder="Repeat password">
                    </div>
                </div>
            </div>

            <div style="display:flex;justify-content:flex-end;margin-top:16px">
                <button type="submit">Assign Manager</button>
            </div>
        </form>
    </section>

    <!-- Department Managers -->
    <section class="section">
        <div class="section-heading">
            <h2>Department Managers</h2>
            <span class="count">
                <c:out value="${departments.size()}" /> departments
            </span>
        </div>

        <c:if test="${empty departments}">
            <div class="empty-state">No departments found.</div>
        </c:if>

        <c:if test="${not empty departments}">
            <div class="table-wrapper">
                <table>
                    <thead>
                    <tr>
                        <th>Department</th>
                        <th>Description</th>
                        <th>Assigned Managers</th>
                    </tr>
                    </thead>

                    <tbody>
                    <c:forEach var="department" items="${departments}">
                        <tr>
                            <td>
                                <div class="department-name">
                                    <c:out value="${department.name}" />
                                </div>
                            </td>

                            <td>
                                <div class="department-description">
                                    <c:out value="${department.description}" />
                                </div>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty department.managers}">
                                        <div class="manager-list">
                                            <c:forEach var="manager"
                                                       items="${department.managers}">
                                                <div class="manager-item">
                                                    <div>
                                                        <div class="manager-name">
                                                            <c:out value="${manager.firstName}" />
                                                            <c:out value=" ${manager.lastName}" />
                                                        </div>

                                                        <div class="manager-id">
                                                            ID:
                                                            <c:out value="${manager.id}" />
                                                        </div>
                                                    </div>

                                                    <form action="${pageContext.request.contextPath}/admin/managers"
                                                          method="post"
                                                          onsubmit="return confirm('Remove this manager from the department?');">

                                                        <input type="hidden"
                                                               name="action"
                                                               value="remove">

                                                        <input type="hidden"
                                                               name="departmentId"
                                                               value="${department.id}">

                                                        <input type="hidden"
                                                               name="employeeId"
                                                               value="${manager.id}">

                                                        <button type="submit"
                                                                class="danger">
                                                            Remove
                                                        </button>
                                                    </form>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="muted">
                                            No managers assigned
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>
    </section>

    <!-- Manager Login Accounts -->
    <section class="section">
        <div class="section-heading">
            <h2>Manager Login Accounts</h2>
            <span class="count">
                <c:out value="${managerUsers.size()}" /> accounts
            </span>
        </div>

        <c:if test="${empty managerUsers}">
            <div class="empty-state">
                No manager login accounts found.
            </div>
        </c:if>

        <c:forEach var="user" items="${managerUsers}">
            <div class="account-card">

                <div class="account-row">
                    <div class="account-username">
                        <c:out value="${user.username}" />
                    </div>

                    <button type="button"
                            class="secondary"
                            aria-expanded="false"
                            aria-controls="managerEditor-${user.id}"
                            onclick="toggleAccountEditor('${user.id}', this)">
                        Edit
                    </button>
                </div>

                <div class="account-editor"
                     id="managerEditor-${user.id}">

                    <!-- Update Username -->
                    <h3>Update Username</h3>

                    <form action="${pageContext.request.contextPath}/admin/managers"
                          method="post">

                        <input type="hidden"
                               name="action"
                               value="updateUsername">

                        <input type="hidden"
                               name="userId"
                               value="${user.id}">

                        <div class="account-grid">
                            <div>
                                <label for="username-${user.id}">
                                    New username
                                </label>

                                <input type="text"
                                       id="username-${user.id}"
                                       name="username"
                                       value="<c:out value='${user.username}'/>"
                                       minlength="3"
                                       required
                                       autocomplete="off">
                            </div>

                            <div style="display:flex;align-items:flex-end">
                                <button type="submit">
                                    Update Username
                                </button>
                            </div>
                        </div>
                    </form>

                    <hr>

                    <!-- Reset Password -->
                    <h3>Reset Password</h3>

                    <form action="${pageContext.request.contextPath}/admin/managers"
                          method="post"
                          onsubmit="return validatePasswordForm(this)">

                        <input type="hidden"
                               name="action"
                               value="resetPassword">

                        <input type="hidden"
                               name="userId"
                               value="${user.id}">

                        <div class="account-grid">
                            <div>
                                <label for="password-${user.id}">
                                    New password
                                </label>

                                <!-- IMPORTANT: must match servlet parameter -->
                                <input type="password"
                                       id="password-${user.id}"
                                       name="newPassword"
                                       minlength="8"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <div>
                                <label for="confirm-${user.id}">
                                    Confirm password
                                </label>

                                <input type="password"
                                       id="confirm-${user.id}"
                                       name="confirmPassword"
                                       minlength="8"
                                       autocomplete="new-password"
                                       required>
                            </div>

                            <div class="full">
                                <button type="submit" class="success">
                                    Reset Password
                                </button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </c:forEach>
    </section>

</div>

<script>
function filterEmployees() {
    const departmentSelect =
        document.getElementById("departmentId");

    const employeeSelect =
        document.getElementById("employeeId");

    const selectedDepartment = departmentSelect.value;

    employeeSelect.value = "";

    Array.from(employeeSelect.options).forEach(function(option, index) {
        if (index === 0) {
            option.hidden = false;
            option.disabled = false;
            return;
        }

        const matches =
            selectedDepartment !== "" &&
            option.dataset.department === selectedDepartment;

        option.hidden = !matches;
        option.disabled = !matches;
    });
}

function toggleNewAccount() {
    const fields = document.getElementById("newAccountFields");
    const button = document.getElementById("accountFieldsButton");

    const opening = fields.classList.contains("hidden");

    fields.classList.toggle("hidden", !opening);

    button.setAttribute("aria-expanded", String(opening));

    button.textContent = opening
        ? "− Hide Login Details"
        : "+ New Login Details";

    if (!opening) {
        document.getElementById("newUsername").value = "";
        document.getElementById("newPassword").value = "";
        document.getElementById("newConfirmPassword").value = "";
    }
}

function toggleAccountEditor(userId, button) {
    const editor =
        document.getElementById("managerEditor-" + userId);

    if (!editor) {
        alert("Could not find the edit section for this manager.");
        return;
    }

    const opening = !editor.classList.contains("open");

    document.querySelectorAll(".account-editor.open").forEach(function(item) {
        item.classList.remove("open");
    });

    document.querySelectorAll("[aria-controls^='managerEditor-']")
        .forEach(function(item) {
            item.setAttribute("aria-expanded", "false");
            item.textContent = "Edit";
        });

    if (opening) {
        editor.classList.add("open");
        button.setAttribute("aria-expanded", "true");
        button.textContent = "Close";
    }
}

function validatePasswordForm(form) {
    const passwordInput =
        form.querySelector('[name="newPassword"]');

    const confirmationInput =
        form.querySelector('[name="confirmPassword"]');

    if (!passwordInput || !confirmationInput) {
        alert("Password fields could not be found.");
        return false;
    }

    const password = passwordInput.value;
    const confirmation = confirmationInput.value;

    if (password.length < 8) {
        alert("Password must be at least 8 characters long.");
        return false;
    }

    if (password !== confirmation) {
        alert("Passwords do not match.");
        return false;
    }

    return true;
}

document.getElementById("assignForm").addEventListener(
    "submit",
    function(event) {
        const fields =
            document.getElementById("newAccountFields");

        const username =
            document.getElementById("newUsername").value.trim();

        const password =
            document.getElementById("newPassword").value;

        const confirmation =
            document.getElementById("newConfirmPassword").value;

        if (fields.classList.contains("hidden")) {
            return;
        }

        const anyFilled =
            username !== "" ||
            password !== "" ||
            confirmation !== "";

        if (anyFilled && (!username || !password || !confirmation)) {
            event.preventDefault();

            alert(
                "Complete all three login fields, or leave all of them empty."
            );
            return;
        }

        if (anyFilled && password.length < 8) {
            event.preventDefault();
            alert("Password must be at least 8 characters long.");
            return;
        }

        if (anyFilled && password !== confirmation) {
            event.preventDefault();
            alert("Passwords do not match.");
        }
    }
);

// Initialize employee filtering when the page loads.
document.addEventListener("DOMContentLoaded", function() {
    filterEmployees();
});
</script>

</body>
</html>
