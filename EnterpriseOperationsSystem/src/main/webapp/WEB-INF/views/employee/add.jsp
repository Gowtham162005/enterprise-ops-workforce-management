
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Department" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Employee</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        /* Styles are included in this JSP only. */

        .add-employee-page {
            padding: 95px 30px 30px;
            min-width: 0;
            width: 100%;
            box-sizing: border-box;
        }

        .add-employee-page .form-container {
            width: 100%;
            max-width: 900px;
            min-width: 0;
            margin: 0 auto;
            padding: 30px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, .08);
            box-sizing: border-box;
        }

        .add-employee-page .form-title {
            margin-bottom: 25px;
        }

        .add-employee-page .form-title h2 {
            margin: 0;
            color: #111827;
        }

        .add-employee-page .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        .add-employee-page .form-group {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .add-employee-page .form-group label {
            margin-bottom: 7px;
            font-weight: 600;
        }

        .add-employee-page .form-group input,
        .add-employee-page .form-group select {
            width: 100%;
            min-width: 0;
            max-width: 100%;
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-family: inherit;
            font-size: 14px;
            background: #fff;
            box-sizing: border-box;
        }

        .add-employee-page .form-group input:focus,
        .add-employee-page .form-group select:focus {
            outline: none;
            border-color: #2563eb;
        }

        .add-employee-page .field-help {
            font-size: 12px;
            color: #6b7280;
            margin-top: 6px;
            line-height: 1.5;
        }

        .add-employee-page .button-row {
            margin-top: 25px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
        }

        .add-employee-page .btn {
            display: inline-block;
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            box-sizing: border-box;
        }

        .add-employee-page .btn-primary {
            background: #2563eb;
            color: #fff;
        }

        .add-employee-page .btn-primary:hover {
            background: #1d4ed8;
        }

        .add-employee-page .btn-secondary {
            background: #6b7280;
            color: #fff;
        }

        .add-employee-page .error-message {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            overflow-wrap: anywhere;
        }

        .add-employee-page .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 16px;
            border-radius: 8px;
            margin-bottom: 22px;
            overflow-wrap: anywhere;
        }

        .add-employee-page .credentials {
            background: #fff;
            border: 1px solid #86efac;
            border-radius: 6px;
            padding: 12px;
            margin-top: 12px;
        }

        .add-employee-page .credential-row {
            margin: 10px 0;
            overflow-wrap: anywhere;
        }

        .add-employee-page .credential-value {
            font-family: monospace;
            font-size: 16px;
            font-weight: bold;
            user-select: text;
        }

        .add-employee-page .notice {
            font-size: 13px;
            margin-top: 12px;
            line-height: 1.5;
        }

        /* Keep the main content clear of the sidebar on this page. */
        .main-content {
            margin-left: 250px;
            width: calc(100% - 250px);
            min-width: 0;
            box-sizing: border-box;
        }

        @media (max-width: 900px) {
            .add-employee-page {
                padding-left: 18px;
                padding-right: 18px;
            }

            .add-employee-page .form-grid {
                grid-template-columns: minmax(0, 1fr);
            }
        }

        @media (max-width: 600px) {
            .add-employee-page {
                padding: 95px 12px 20px;
            }

            .add-employee-page .form-container {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

<%@ include file="../sidebar.jspf" %>

<div class="main-content">

    <%@ include file="../topbar.jspf" %>

    <main class="add-employee-page">

        <div class="form-container">

            <div class="form-title">
                <h2>Add Employee</h2>
            </div>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="success-message">
                    <strong><c:out value="${success}" /></strong>

                    <c:if test="${not empty createdUsername and not empty temporaryPassword}">
                        <div class="credentials">
                            <h3>Employee Login Credentials</h3>

                            <div class="credential-row">
                                <strong>Username:</strong>
                                <span class="credential-value"
                                      id="createdUsername"><c:out value="${createdUsername}" /></span>
                            </div>

                            <div class="credential-row">
                                <strong>Temporary password:</strong>
                                <span class="credential-value"
                                      id="temporaryPassword"><c:out value="${temporaryPassword}" /></span>
                            </div>

                            <button type="button"
                                    class="btn btn-primary"
                                    onclick="copyCredentials()">
                                Copy Credentials
                            </button>

                            <p class="notice">
                                Share these credentials securely with the employee.
                                The employee must change the temporary password after
                                logging in. Save them now; this page may not show them again.
                            </p>
                        </div>
                    </c:if>
                </div>
            </c:if>

            <form id="addEmployeeForm"
                  action="${pageContext.request.contextPath}/employees"
                  method="post">

                <input type="hidden" name="action" value="add">

                <div class="form-grid">

                    <div class="form-group">
                        <label for="employeeCode">Employee Code</label>
                        <input type="text"
                               id="employeeCode"
                               name="employeeCode"
                               maxlength="30"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="firstName">First Name</label>
                        <input type="text"
                               id="firstName"
                               name="firstName"
                               maxlength="100"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="lastName">Last Name</label>
                        <input type="text"
                               id="lastName"
                               name="lastName"
                               maxlength="100">
                    </div>

                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email"
                               id="email"
                               name="email"
                               maxlength="150"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="tel"
                               id="phone"
                               name="phone"
                               maxlength="20"
                               inputmode="tel"
                               autocomplete="tel"
                               pattern="[+]?[0-9][0-9 ()-]{5,18}[0-9]"
                               title="Enter a valid phone number using digits, an optional + country code, spaces, parentheses or hyphens. Letters are not allowed.">

                        <small class="field-help">
                            Use digits, an optional + country code, spaces,
                            parentheses or hyphens. Do not enter letters.
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="jobTitle">Job Title</label>
                        <input type="text"
                               id="jobTitle"
                               name="jobTitle"
                               maxlength="100">
                    </div>

                    <div class="form-group">
                        <label for="salary">Salary</label>
                        <input type="number"
                               id="salary"
                               name="salary"
                               step="0.01"
                               min="0">
                    </div>

                    <div class="form-group">
                        <label for="departmentId">Department</label>

                        <select id="departmentId"
                                name="departmentId"
                                onchange="loadManagers(this.value)"
                                required>

                            <option value="">-- Select Department --</option>

                            <%
                                List<Department> departments =
                                    (List<Department>) request.getAttribute("departments");

                                if (departments != null) {
                                    for (Department department : departments) {
                            %>
                                <option value="<%= department.getId() %>"><c:out value="<%= department.getName() %>" /></option>
                            <%
                                    }
                                }
                            %>

                        </select>
                    </div>

                    <div class="form-group">
                        <label for="managerId">Manager</label>

                        <!-- Required only when this department has managers. -->
                        <select id="managerId"
                                name="managerId">

                            <option value="">-- Select Department First --</option>

                        </select>

                        <small id="managerHelp" class="field-help">
                            Select a department to load its managers.
                        </small>
                    </div>

                    <div class="form-group">
                        <label for="joiningDate">Joining Date</label>
                        <input type="date"
                               id="joiningDate"
                               name="joiningDate">
                    </div>

                    <div class="form-group">
                        <label for="status">Status</label>

                        <select id="status" name="status">
                            <option value="ACTIVE" selected>ACTIVE</option>
                            <option value="INACTIVE">INACTIVE</option>
                        </select>
                    </div>

                </div>

                <div class="button-row">
                    <button type="submit" class="btn btn-primary">
                        Add Employee
                    </button>

                    <a href="${pageContext.request.contextPath}/employees"
                       class="btn btn-secondary">
                        Cancel
                    </a>
                </div>

            </form>

        </div>
    </main>
</div>

<script>
    "use strict";

    const managerSelect = document.getElementById("managerId");
    const managerHelp = document.getElementById("managerHelp");
    const departmentSelect = document.getElementById("departmentId");
    const employeeForm = document.getElementById("addEmployeeForm");
    const phoneInput = document.getElementById("phone");

    /*
     * Track whether the manager request is still running or failed.
     * A failed request must not be mistaken for a department with no managers.
     */
    let managerRequestNumber = 0;
    let managerLoadFailed = false;

    function resetManagerField(message) {
        managerSelect.innerHTML = "";

        const option = document.createElement("option");
        option.value = "";
        option.textContent = message;

        managerSelect.appendChild(option);
        managerSelect.required = false;
        managerSelect.setCustomValidity("");
    }

    function loadManagers(departmentId) {
        const currentRequest = ++managerRequestNumber;

        managerLoadFailed = false;
        managerSelect.disabled = false;
        managerSelect.required = false;
        managerSelect.setCustomValidity("");

        if (!departmentId) {
            resetManagerField("-- Select Department First --");
            managerHelp.textContent =
                "Select a department to load its managers.";
            return;
        }

        resetManagerField("Loading managers...");
        managerSelect.disabled = true;
        managerHelp.textContent = "Loading managers...";

        const url =
            '${pageContext.request.contextPath}/employees'
            + '?action=managersByDepartment&departmentId='
            + encodeURIComponent(departmentId);

        fetch(url, {
            method: "GET",
            headers: {
                "Accept": "application/json"
            }
        })
        .then(function(response) {
            if (!response.ok) {
                throw new Error("Failed to load managers.");
            }

            return response.json();
        })
        .then(function(managers) {
            /*
             * Ignore stale responses if the user changes departments
             * before an earlier request finishes.
             */
            if (currentRequest !== managerRequestNumber) {
                return;
            }

            if (!Array.isArray(managers)) {
                throw new Error("Invalid manager response.");
            }

            managerSelect.disabled = false;
            managerSelect.innerHTML = "";
            managerSelect.setCustomValidity("");

            if (managers.length === 0) {
                /*
                 * No managers for this department:
                 * the employee can be added without a manager.
                 */
                managerSelect.required = false;

                const option = document.createElement("option");
                option.value = "";
                option.textContent = "-- No Managers Available --";
                managerSelect.appendChild(option);

                managerHelp.textContent =
                    "No manager is assigned to this department. "
                    + "Manager selection is optional.";

                return;
            }

            /*
             * Managers exist:
             * the user must select one.
             */
            managerSelect.required = true;

            const placeholder = document.createElement("option");
            placeholder.value = "";
            placeholder.textContent = "-- Select Manager --";
            managerSelect.appendChild(placeholder);

            managers.forEach(function(manager) {
                const option = document.createElement("option");

                option.value = manager.id;
                option.textContent = manager.name
                    + (manager.code ? " (" + manager.code + ")" : "");

                managerSelect.appendChild(option);
            });

            managerHelp.textContent =
                "Select a manager for this department.";

        })
        .catch(function(error) {
            if (currentRequest !== managerRequestNumber) {
                return;
            }

            console.error("Manager loading error:", error);

            managerLoadFailed = true;
            managerSelect.disabled = false;
            managerSelect.required = false;

            resetManagerField("-- Unable to Load Managers --");

            /*
             * Prevent submission until the request can be retried.
             * A network error is not proof that no managers exist.
             */
            managerSelect.setCustomValidity(
                "Managers could not be loaded. Please select the department again and retry."
            );

            managerHelp.textContent =
                "The manager list could not be loaded. "
                + "Please retry before submitting the form.";
        });
    }

    /*
     * Phone validation: letters and other unsupported characters are rejected.
     * An empty phone field is allowed.
     */
    function validatePhone() {
        const value = phoneInput.value.trim();

        if (value === "") {
            phoneInput.setCustomValidity("");
            return true;
        }

        const phonePattern = /^\+?[0-9][0-9 ()-]{5,18}[0-9]$/;

        if (!phonePattern.test(value)) {
            phoneInput.setCustomValidity(
                "Enter a valid phone number. Letters are not allowed."
            );
            return false;
        }

        const digitCount = value.replace(/\D/g, "").length;

        if (digitCount < 7 || digitCount > 15) {
            phoneInput.setCustomValidity(
                "The phone number must contain between 7 and 15 digits."
            );
            return false;
        }

        phoneInput.setCustomValidity("");
        return true;
    }

    phoneInput.addEventListener("input", validatePhone);
    phoneInput.addEventListener("blur", validatePhone);

    managerSelect.addEventListener("change", function() {
        managerSelect.setCustomValidity("");
    });

    employeeForm.addEventListener("submit", function(event) {
        validatePhone();

        if (managerLoadFailed) {
            event.preventDefault();

            managerSelect.setCustomValidity(
                "Managers could not be loaded. Please retry before submitting."
            );

            managerSelect.reportValidity();
            return;
        }

        if (!validatePhone()) {
            event.preventDefault();
            phoneInput.reportValidity();
        }
    });

    /*
     * Copy the credentials shown after successful employee creation.
     */
    function copyCredentials() {
        const usernameElement = document.getElementById("createdUsername");
        const passwordElement = document.getElementById("temporaryPassword");

        if (!usernameElement || !passwordElement) {
            return;
        }

        const username = usernameElement.textContent.trim();
        const password = passwordElement.textContent.trim();

        const text = "Username: " + username
            + "\nTemporary password: " + password;

        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text)
                .then(function() {
                    alert("Credentials copied. Store them securely.");
                })
                .catch(function() {
                    window.prompt("Copy credentials:", text);
                });
        } else {
            window.prompt("Copy credentials:", text);
        }
    }
</script>

</body>
</html>
