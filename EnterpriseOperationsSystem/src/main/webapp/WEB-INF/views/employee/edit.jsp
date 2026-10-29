
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.enterpriseops.model.Employee" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    Employee employee = (Employee) request.getAttribute("employee");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Employee | Enterprise Operations</title>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/assets/css/app.css">

    <style>
        .app-layout {
            width: 100%;
            min-height: 100vh;
        }

        .main-content {
            margin-left: 240px;
            width: calc(100% - 240px);
            max-width: calc(100% - 240px);
            min-height: 100vh;
            min-width: 0;
            box-sizing: border-box;
            position: relative;
        }

        .employee-form-page {
            display: block;
            width: 100%;
            max-width: 100%;
            min-width: 0;
            padding: 95px 30px 30px;
            box-sizing: border-box;
        }

        .form-card {
            width: 100%;
            max-width: 900px;
            min-width: 0;
            margin: 0 auto 0 0;
            padding: 30px;
            background: #ffffff;
            border: 1px solid #e5e7eb;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.06);
            box-sizing: border-box;
        }

        .form-card h1 {
            margin: 0;
            color: #111827;
            font-size: 28px;
            font-weight: 700;
            overflow-wrap: anywhere;
        }

        .form-description {
            margin: 8px 0 25px;
            color: #6b7280;
            font-size: 14px;
            line-height: 1.5;
        }

        .error-message {
            margin-bottom: 20px;
            padding: 12px 15px;
            border: 1px solid #fecaca;
            border-radius: 6px;
            background: #fee2e2;
            color: #991b1b;
            font-size: 14px;
            line-height: 1.5;
            overflow-wrap: anywhere;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            width: 100%;
            min-width: 0;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            min-width: 0;
        }

        .form-group label {
            margin-bottom: 7px;
            color: #374151;
            font-size: 14px;
            font-weight: 600;
        }

        .form-group input,
        .form-group select {
            display: block;
            width: 100%;
            min-width: 0;
            min-height: 42px;
            padding: 10px 11px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            background: #ffffff;
            color: #111827;
            font-family: inherit;
            font-size: 14px;
            box-sizing: border-box;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .form-actions {
            display: flex;
            flex-wrap: wrap;
            align-items: center;
            gap: 10px;
            margin-top: 25px;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 40px;
            padding: 10px 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            text-decoration: none;
            font-family: inherit;
            font-size: 14px;
            font-weight: 600;
            box-sizing: border-box;
            transition: background 0.2s ease;
        }

        .btn-primary {
            background: #2563eb;
            color: #ffffff;
        }

        .btn-primary:hover {
            background: #1d4ed8;
        }

        .btn-secondary {
            background: #6b7280;
            color: #ffffff;
        }

        .btn-secondary:hover {
            background: #4b5563;
        }

        @media (max-width: 768px) {
            .employee-form-page {
                padding: 85px 20px 25px;
            }

            .form-card {
                padding: 24px;
            }

            .form-card h1 {
                font-size: 25px;
            }

            .form-grid {
                gap: 18px;
            }
        }

        @media (max-width: 600px) {
            .main-content {
                margin-left: 220px;
                width: calc(100% - 220px);
                max-width: calc(100% - 220px);
            }

            .employee-form-page {
                padding: 80px 12px 20px;
            }

            .form-card {
                padding: 18px;
            }

            .form-card h1 {
                font-size: 23px;
            }

            .form-grid {
                grid-template-columns: minmax(0, 1fr);
                gap: 16px;
            }

            .form-actions {
                flex-direction: column;
                align-items: stretch;
            }

            .form-actions .btn {
                width: 100%;
            }
        }
    </style>
</head>

<body>
<div class="app-layout">

    <%@ include file="../sidebar.jspf" %>

    <div class="main-content">

        <%@ include file="../topbar.jspf" %>

        <main class="employee-form-page content-layout">
            <div class="form-card">

                <h1>Edit Employee</h1>
                <p class="form-description">
                    Update employee information and assign a manager.
                </p>

                <c:if test="${not empty error}">
                    <div class="error-message">
                        <c:out value="${error}"/>
                    </div>
                </c:if>

                <% if (employee == null) { %>

                    <div class="error-message">
                        Employee information could not be loaded.
                        Please return to the employee list and try again.
                    </div>

                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/employees"
                           class="btn btn-secondary">
                            Back to Employees
                        </a>
                    </div>

                <% } else { %>

                    <form method="post"
                          action="${pageContext.request.contextPath}/employees">

                        <input type="hidden" name="action" value="update">

                        <input type="hidden"
                               name="id"
                               value="<%= employee.getId() %>">

                        <div class="form-grid">

                            <div class="form-group">
                                <label for="employeeCode">Employee Code</label>
                                <input type="text"
                                       id="employeeCode"
                                       name="employeeCode"
                                       maxlength="30"
                                       value="<c:out value='${employee.employeeCode}'/>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="firstName">First Name</label>
                                <input type="text"
                                       id="firstName"
                                       name="firstName"
                                       maxlength="100"
                                       value="<c:out value='${employee.firstName}'/>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="lastName">Last Name</label>
                                <input type="text"
                                       id="lastName"
                                       name="lastName"
                                       maxlength="100"
                                       value="<c:out value='${employee.lastName}'/>">
                            </div>

                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email"
                                       id="email"
                                       name="email"
                                       maxlength="150"
                                       value="<c:out value='${employee.email}'/>"
                                       required>
                            </div>

                            <div class="form-group">
                                <label for="phone">Phone</label>
                                <input type="text"
                                       id="phone"
                                       name="phone"
                                       maxlength="20"
                                       value="<c:out value='${employee.phone}'/>">
                            </div>

                            <div class="form-group">
                                <label for="jobTitle">Job Title</label>
                                <input type="text"
                                       id="jobTitle"
                                       name="jobTitle"
                                       maxlength="100"
                                       value="<c:out value='${employee.jobTitle}'/>">
                            </div>

                            <div class="form-group">
                                <label for="salary">Salary</label>
                                <input type="number"
                                       id="salary"
                                       name="salary"
                                       min="0"
                                       step="0.01"
                                       value="${employee.salary}">
                            </div>

                            <!-- Department -->
                            <div class="form-group">
                                <label for="departmentId">Department</label>

                                <select id="departmentId"
                                        name="departmentId"
                                        required>

                                    <option value="">-- Select Department --</option>

                                    <c:forEach var="department"
                                               items="${departments}">
                                        <option value="${department.id}"
                                            <c:if test="${not empty employee.department
                                                and employee.department.id == department.id}">
                                                selected
                                            </c:if>>
                                            <c:out value="${department.name}"/>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <!-- Manager: part of the existing edit form -->
                            <div class="form-group">
                                <label for="managerId">Manager</label>

                                <select id="managerId" name="managerId">
                                    <option value="">-- No Manager Assigned --</option>

                                    <c:forEach var="manager"
                                               items="${departmentManagers}">
                                        <option value="${manager.id}"
                                            <c:if test="${not empty employee.manager
                                                and employee.manager.id == manager.id}">
                                                selected
                                            </c:if>>
                                            <c:out value="${manager.firstName}"/>
                                            <c:if test="${not empty manager.lastName}">
                                                <c:out value=" ${manager.lastName}"/>
                                            </c:if>
                                            <c:if test="${not empty manager.employeeCode}">
                                                (<c:out value="${manager.employeeCode}"/>)
                                            </c:if>
                                        </option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="form-group">
                                <label for="joiningDate">Joining Date</label>
                                <input type="date"
                                       id="joiningDate"
                                       name="joiningDate"
                                       value="${employee.joiningDate}">
                            </div>

                            <div class="form-group">
                                <label for="status">Status</label>

                                <select id="status" name="status">
                                    <option value="ACTIVE"
                                        <c:if test="${employee.status == 'ACTIVE'}">
                                            selected
                                        </c:if>>
                                        ACTIVE
                                    </option>

                                    <option value="INACTIVE"
                                        <c:if test="${employee.status == 'INACTIVE'}">
                                            selected
                                        </c:if>>
                                        INACTIVE
                                    </option>
                                </select>
                            </div>

                        </div>

                        <div class="form-actions">
                            <button type="submit" class="btn btn-primary">
                                Update Employee
                            </button>

                            <a href="${pageContext.request.contextPath}/employees"
                               class="btn btn-secondary">
                                Cancel
                            </a>
                        </div>

                    </form>

                <% } %>
            </div>
        </main>
    </div>
</div>

<script>
document.addEventListener("DOMContentLoaded", function () {
    const departmentSelect = document.getElementById("departmentId");
    const managerSelect = document.getElementById("managerId");

    if (!departmentSelect || !managerSelect) {
        return;
    }

    departmentSelect.addEventListener("change", function () {
        const departmentId = departmentSelect.value;

        managerSelect.innerHTML = "";

        const emptyOption = document.createElement("option");
        emptyOption.value = "";
        emptyOption.textContent = "-- No Manager Assigned --";
        managerSelect.appendChild(emptyOption);

        if (!departmentId) {
            return;
        }

        const url =
            "${pageContext.request.contextPath}/employees" +
            "?action=managersByDepartment&departmentId=" +
            encodeURIComponent(departmentId);

        fetch(url)
            .then(function (response) {
                if (!response.ok) {
                    throw new Error("Unable to load department managers.");
                }
                return response.json();
            })
            .then(function (managers) {
                managers.forEach(function (manager) {
                    const option = document.createElement("option");
                    option.value = manager.id;
                    option.textContent = manager.name +
                        (manager.code ? " (" + manager.code + ")" : "");
                    managerSelect.appendChild(option);
                });
            })
            .catch(function (error) {
                console.error(error);
                alert("Unable to load managers for this department.");
            });
    });
});
</script>

</body>
</html>
