<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.enterpriseops.model.Employee" %>

<%
List<Employee> employees =
(List<Employee>) request.getAttribute("employees");
%>

<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mark Attendance</title>

```
<style>
    * {
        box-sizing: border-box;
    }

    html,
    body {
        margin: 0;
        min-height: 100%;
        font-family: Arial, sans-serif;
        background: #f5f6f8;
        color: #1f2937;
    }

    .app-layout {
        width: 100%;
        min-height: 100vh;
    }

    /* Match the shared sidebar layout */
    .main-content {
        margin-left: 240px;
        width: calc(100% - 240px);
        min-height: 100vh;
        min-width: 0;
        position: relative;
        box-sizing: border-box;
    }

    .attendance-page {
        display: block;
        width: 100%;
        min-width: 0;
        padding: 95px 30px 30px;
        box-sizing: border-box;
    }

    .attendance-container {
        width: 100%;
        max-width: 850px;
        min-width: 0;
        margin: 0 auto;
    }

    .attendance-card {
        width: 100%;
        min-width: 0;
        padding: 28px;
        background: #ffffff;
        border: 1px solid #e5e7eb;
        border-radius: 10px;
        box-shadow: 0 2px 8px rgba(15, 23, 42, 0.04);
    }

    .page-header {
        margin-bottom: 25px;
    }

    h1 {
        margin: 0 0 8px;
        font-size: 26px;
        line-height: 1.3;
        color: #111827;
    }

    .subtitle {
        margin: 0;
        color: #6b7280;
        font-size: 14px;
        line-height: 1.5;
    }

    .form-group {
        min-width: 0;
        margin-bottom: 18px;
    }

    label {
        display: block;
        margin-bottom: 7px;
        font-size: 13px;
        font-weight: 600;
        color: #374151;
    }

    input,
    select,
    textarea {
        display: block;
        width: 100%;
        max-width: 100%;
        min-width: 0;
        padding: 10px 12px;
        border: 1px solid #d1d5db;
        border-radius: 6px;
        font-family: inherit;
        font-size: 14px;
        color: #1f2937;
        background: #ffffff;
        outline: none;
    }

    input,
    select {
        min-height: 42px;
    }

    input:focus,
    select:focus,
    textarea:focus {
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }

    textarea {
        min-height: 100px;
        resize: vertical;
    }

    .row {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .buttons {
        display: flex;
        flex-wrap: wrap;
        align-items: center;
        gap: 12px;
        margin-top: 25px;
        padding-top: 20px;
        border-top: 1px solid #e5e7eb;
    }

    .btn {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-height: 42px;
        padding: 11px 20px;
        border: 1px solid transparent;
        border-radius: 6px;
        font-family: inherit;
        font-size: 14px;
        font-weight: 600;
        text-decoration: none;
        cursor: pointer;
    }

    .btn-save {
        background: #111827;
        color: #ffffff;
    }

    .btn-save:hover {
        background: #374151;
    }

    .btn-cancel {
        background: #ffffff;
        color: #374151;
        border-color: #d1d5db;
    }

    .btn-cancel:hover {
        background: #f9fafb;
    }

    @media (max-width: 768px) {
        .attendance-page {
            padding: 85px 20px 25px;
        }

        .attendance-card {
            padding: 24px;
        }

        h1 {
            font-size: 23px;
        }
    }

    @media (max-width: 600px) {
        .main-content {
            margin-left: 220px;
            width: calc(100% - 220px);
        }

        .attendance-page {
            padding: 80px 12px 20px;
        }

        .attendance-card {
            padding: 18px 14px;
        }

        .row {
            grid-template-columns: minmax(0, 1fr);
            gap: 0;
        }

        h1 {
            font-size: 21px;
        }

        .buttons {
            flex-direction: column;
            align-items: stretch;
        }

        .btn {
            width: 100%;
        }
    }
</style>
```

</head>

<body>

<div class="app-layout">

```
<%@ include file="../sidebar.jspf" %>

<div class="main-content">

    <%@ include file="../topbar.jspf" %>

    <main class="attendance-page">

        <div class="attendance-container">

            <section class="attendance-card">

                <header class="page-header">
                    <h1>Mark Attendance</h1>
                    <p class="subtitle">
                        Record attendance details for an employee.
                    </p>
                </header>

                <form method="post"
                      action="${pageContext.request.contextPath}/attendance">

                    <input type="hidden" name="action" value="add">

                    <div class="form-group">
                        <label for="employeeId">Employee</label>

                        <select id="employeeId"
                                name="employeeId"
                                required>
                            <option value="">Select employee</option>

                            <%
                                if (employees != null) {
                                    for (Employee employee : employees) {
                                        if (employee != null) {
                            %>
                            <option value="<%= employee.getId() %>"><%= employee.getFirstName() %> <%= employee.getLastName() %></option>
                            <%
                                        }
                                    }
                                }
                            %>
                        </select>
                    </div>

                    <div class="row">

                        <div class="form-group">
                            <label for="attendanceDate">Attendance Date</label>
                            <input type="date"
                                   id="attendanceDate"
                                   name="attendanceDate"
                                   required>
                        </div>

                        <div class="form-group">
                            <label for="status">Status</label>

                            <select id="status" name="status" required>
                                <option value="">Select status</option>
                                <option value="PRESENT">Present</option>
                                <option value="ABSENT">Absent</option>
                                <option value="HALF_DAY">Half Day</option>
                                <option value="LEAVE">Leave</option>
                            </select>
                        </div>

                    </div>

                    <div class="row">

                        <div class="form-group">
                            <label for="checkIn">Check In</label>
                            <input type="time"
                                   id="checkIn"
                                   name="checkIn">
                        </div>

                        <div class="form-group">
                            <label for="checkOut">Check Out</label>
                            <input type="time"
                                   id="checkOut"
                                   name="checkOut">
                        </div>

                    </div>

                    <div class="form-group">
                        <label for="notes">Notes</label>
                        <textarea id="notes"
                                  name="notes"
                                  placeholder="Optional notes"></textarea>
                    </div>

                    <div class="buttons">
                        <button type="submit" class="btn btn-save">
                            Save Attendance
                        </button>

                        <a class="btn btn-cancel"
                           href="${pageContext.request.contextPath}/attendance">
                            Cancel
                        </a>
                    </div>

                </form>

            </section>

        </div>

    </main>

</div>
```

</div>

</body>
</html>
