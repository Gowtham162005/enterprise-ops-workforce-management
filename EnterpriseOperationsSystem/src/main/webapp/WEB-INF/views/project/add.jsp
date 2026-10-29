<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Project</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 30px;
            background: #f5f7fb;
        }

        .form-container {
            max-width: 650px;
            margin: auto;
            padding: 25px;
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0, 0, 0, .08);
        }

        h2 {
            margin-top: 0;
        }

        .form-group {
            margin-bottom: 16px;
        }

        label {
            display: block;
            margin-bottom: 6px;
            font-weight: bold;
        }

        input, textarea, select {
            box-sizing: border-box;
            width: 100%;
            padding: 10px;
            border: 1px solid #ccd2dc;
            border-radius: 5px;
            font-size: 14px;
        }

        textarea {
            min-height: 90px;
            resize: vertical;
        }

        .buttons {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }

        button, .cancel-link {
            display: inline-block;
            padding: 10px 16px;
            border: 0;
            border-radius: 5px;
            text-decoration: none;
            cursor: pointer;
            font-size: 14px;
        }

        button {
            color: white;
            background: #1769aa;
        }

        .cancel-link {
            color: #222;
            background: #e5e7eb;
        }

        .hint {
            margin-top: 5px;
            color: #666;
            font-size: 12px;
        }
    </style>
</head>

<body>
<div class="form-container">
    <h2>Add Project</h2>

    <form method="post"
          action="${pageContext.request.contextPath}/projects">

        <input type="hidden" name="action" value="add">

        <div class="form-group">
            <label for="projectCode">Project Code *</label>
            <input type="text"
                   id="projectCode"
                   name="projectCode"
                   maxlength="30"
                   required>
        </div>

        <div class="form-group">
            <label for="name">Project Name *</label>
            <input type="text"
                   id="name"
                   name="name"
                   maxlength="150"
                   required>
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description"
                      name="description"
                      maxlength="500"></textarea>
        </div>

        <div class="form-group">
            <label for="departmentId">Department *</label>
            <select id="departmentId"
                    name="departmentId"
                    required>
                <option value="">-- Select Department --</option>

                <c:forEach var="department" items="${departments}">
                    <option value="${department.id}">
                        <c:out value="${department.name}"/>
                    </option>
                </c:forEach>
            </select>
        </div>

        <div class="form-group">
            <label for="managerId">Project Manager</label>
            <select id="managerId" name="managerId">
                <option value="">-- Select Manager (Optional) --</option>

                <c:forEach var="department" items="${departments}">
                    <c:forEach var="employee"
                               items="${department.employees}">
                        <option value="${employee.id}"
                                data-department-id="${department.id}">
                            <c:out value="${employee.firstName}"/>
                            <c:if test="${not empty employee.lastName}">
                                <c:out value=" ${employee.lastName}"/>
                            </c:if>
                            <c:out value=" (${employee.employeeCode})"/>
                        </option>
                    </c:forEach>
                </c:forEach>
            </select>
            <div class="hint">
                Only employees in the selected department are shown.
            </div>
        </div>

        <div class="form-group">
            <label for="startDate">Start Date</label>
            <input type="date" id="startDate" name="startDate">
        </div>

        <div class="form-group">
            <label for="endDate">End Date</label>
            <input type="date" id="endDate" name="endDate">
        </div>

        <div class="form-group">
            <label for="status">Status</label>
            <select id="status" name="status">
                <option value="PLANNED" selected>Planned</option>
                <option value="ACTIVE">Active</option>
                <option value="ON_HOLD">On Hold</option>
                <option value="COMPLETED">Completed</option>
                <option value="CANCELLED">Cancelled</option>
            </select>
        </div>

        <div class="buttons">
            <button type="submit">Save Project</button>
            <a class="cancel-link"
               href="${pageContext.request.contextPath}/projects">
                Cancel
            </a>
        </div>
    </form>
</div>

<script>
(function () {
    const departmentSelect = document.getElementById("departmentId");
    const managerSelect = document.getElementById("managerId");

    function filterManagers() {
        const departmentId = departmentSelect.value;

        Array.from(managerSelect.options).forEach(function (option) {
            if (option.value === "") {
                option.hidden = false;
                option.disabled = false;
                return;
            }

            const matches =
                departmentId !== "" &&
                option.dataset.departmentId === departmentId;

            option.hidden = !matches;
            option.disabled = !matches;

            if (!matches && option.selected) {
                option.selected = false;
            }
        });

        if (managerSelect.selectedOptions.length === 0 ||
                (managerSelect.value !== "" &&
                 managerSelect.selectedOptions[0].disabled)) {
            managerSelect.value = "";
        }
    }

    departmentSelect.addEventListener("change", filterManagers);
    filterManagers();
})();
</script>
</body>
</html>