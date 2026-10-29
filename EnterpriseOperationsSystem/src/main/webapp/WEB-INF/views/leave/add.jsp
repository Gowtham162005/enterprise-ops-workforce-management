<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Leave</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, Helvetica, sans-serif;
            background: #f3f4f6;
            color: #111827;
        }

        .main-content {
            margin-left: 240px;
            padding: 95px 30px 40px;
            min-height: 100vh;
        }

        .form-card {
            max-width: 700px;
            margin: 0 auto;
            padding: 28px;
            background: #fff;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
        }

        h1 {
            margin: 0 0 8px;
            font-size: 26px;
        }

        .description {
            margin-bottom: 25px;
            color: #6b7280;
            font-size: 14px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            font-weight: 600;
        }

        input, select, textarea {
            width: 100%;
            padding: 11px 12px;
            border: 1px solid #d1d5db;
            border-radius: 7px;
            font: inherit;
            background: #fff;
        }

        textarea {
            min-height: 120px;
            resize: vertical;
        }

        .date-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 12px;
            margin-top: 25px;
        }

        .button {
            display: inline-block;
            padding: 11px 18px;
            border: 0;
            border-radius: 7px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
        }

        .submit-button {
            background: #2563eb;
            color: #fff;
        }

        .submit-button:hover {
            background: #1d4ed8;
        }

        .cancel-button {
            background: #e5e7eb;
            color: #111827;
        }

        .error-message {
            margin-bottom: 18px;
            padding: 12px;
            border-radius: 7px;
            background: #fee2e2;
            color: #991b1b;
        }

        @media (max-width: 768px) {
            .main-content {
                margin-left: 0;
                padding: 85px 15px 25px;
            }

            .date-grid {
                grid-template-columns: 1fr;
            }

            .form-card {
                padding: 20px;
            }
        }
    </style>
</head>

<body>

    <%@ include file="/WEB-INF/views/sidebar.jspf" %>
    <%@ include file="/WEB-INF/views/topbar.jspf" %>

    <main class="main-content">
        <div class="form-card">

            <h1>Apply for Leave</h1>

            <p class="description">
                Complete the form below to submit your leave request.
            </p>

            <c:if test="${not empty error}">
                <div class="error-message">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/leaves"
                  method="post">

                <input type="hidden" name="action" value="add">

                <div class="form-group">
                    <label for="leaveType">Leave Type</label>

                    <select id="leaveType" name="leaveType" required>
                        <option value="">-- Select leave type --</option>
                        <option value="CASUAL">Casual Leave</option>
                        <option value="SICK">Sick Leave</option>
                        <option value="ANNUAL">Annual Leave</option>
                        <option value="MATERNITY">Maternity Leave</option>
                        <option value="PATERNITY">Paternity Leave</option>
                        <option value="UNPAID">Unpaid Leave</option>
                    </select>
                </div>

                <div class="date-grid">
                    <div class="form-group">
                        <label for="startDate">Start Date</label>
                        <input type="date"
                               id="startDate"
                               name="startDate"
                               required>
                    </div>

                    <div class="form-group">
                        <label for="endDate">End Date</label>
                        <input type="date"
                               id="endDate"
                               name="endDate"
                               required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="reason">Reason for Leave</label>
                    <textarea id="reason"
                              name="reason"
                              maxlength="1000"
                              placeholder="Enter the reason for your leave"
                              required></textarea>
                </div>

                <div class="actions">
                    <button type="submit"
                            class="button submit-button">
                        Submit Request
                    </button>

                    <a class="button cancel-button"
                       href="${pageContext.request.contextPath}/leaves">
                        Cancel
                    </a>
                </div>

            </form>
        </div>
    </main>

</body>
</html>
