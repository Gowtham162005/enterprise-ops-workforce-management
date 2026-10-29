
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Set Up Your Account</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
            background: #f3f4f6;
            font-family: Arial, sans-serif;
        }

        .account-card {
            width: 100%;
            max-width: 460px;
            padding: 32px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
        }

        h2 {
            margin-top: 0;
            color: #111827;
        }

        .description {
            color: #4b5563;
            line-height: 1.5;
            margin-bottom: 24px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            margin-bottom: 18px;
        }

        label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #374151;
        }

        input {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 15px;
        }

        input:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 2px rgba(37, 99, 235, 0.12);
        }

        input[readonly] {
            background: #f3f4f6;
            color: #6b7280;
            cursor: not-allowed;
        }

        .btn {
            width: 100%;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #2563eb;
            color: white;
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
        }

        .btn:hover {
            background: #1d4ed8;
        }

        .error {
            padding: 12px;
            margin-bottom: 18px;
            color: #991b1b;
            background: #fee2e2;
            border-radius: 6px;
        }

        .hint {
            margin-top: 16px;
            color: #6b7280;
            font-size: 13px;
            line-height: 1.5;
        }
    </style>
</head>

<body>

<div class="account-card">

    <h2>Set Up Your Account</h2>

    <p class="description">
        Choose your own username and password before continuing.
    </p>

    <!-- Display validation errors -->
    <c:if test="${not empty error}">
        <div class="error">
            <c:out value="${error}" />
        </div>
    </c:if>

    <form method="post"
          action="${pageContext.request.contextPath}/change-password">

        <!-- Display existing username without allowing edits -->
        <div class="form-group">
            <label for="currentUsername">Current Username</label>

            <input
                type="text"
                id="currentUsername"
                value="<c:out value='${sessionScope.loggedInUser.username}' />"
                readonly>
        </div>

        <!-- New username starts empty -->
        <div class="form-group">
            <label for="newUsername">New Username</label>

            <input
                type="text"
                id="newUsername"
                name="newUsername"
                minlength="3"
                maxlength="40"
                pattern="[A-Za-z0-9._-]{3,40}"
                title="Use 3-40 letters, numbers, dots, underscores, or hyphens."
                autocomplete="off"
                placeholder="Enter your new username"
                required>
        </div>

        <!-- Employee enters their temporary/current password -->
        <div class="form-group">
            <label for="currentPassword">
                Temporary / Current Password
            </label>

            <input
                type="password"
                id="currentPassword"
                name="currentPassword"
                autocomplete="current-password"
                placeholder="Enter your temporary password"
                required>
        </div>

        <!-- New password starts empty -->
        <div class="form-group">
            <label for="newPassword">New Password</label>

            <input
                type="password"
                id="newPassword"
                name="newPassword"
                minlength="8"
                autocomplete="new-password"
                placeholder="Create a new password"
                required>
        </div>

        <!-- Confirm password starts empty -->
        <div class="form-group">
            <label for="confirmPassword">Confirm New Password</label>

            <input
                type="password"
                id="confirmPassword"
                name="confirmPassword"
                minlength="8"
                autocomplete="new-password"
                placeholder="Re-enter your new password"
                required>
        </div>

        <button type="submit" class="btn">
            Update Username and Password
        </button>

    </form>

    <p class="hint">
        <strong>Username:</strong> 3-40 characters using letters,
        numbers, dots, underscores, or hyphens.<br>

        <strong>Password:</strong> At least 8 characters.
    </p>

</div>

<script>
    // Check that both new-password entries match before submitting.
    const form = document.querySelector("form");
    const newPassword = document.getElementById("newPassword");
    const confirmPassword = document.getElementById("confirmPassword");

    function checkPasswordsMatch() {
        if (confirmPassword.value !== newPassword.value) {
            confirmPassword.setCustomValidity(
                "The new password and confirmation do not match."
            );
        } else {
            confirmPassword.setCustomValidity("");
        }
    }

    newPassword.addEventListener("input", checkPasswordsMatch);
    confirmPassword.addEventListener("input", checkPasswordsMatch);

    form.addEventListener("submit", function(event) {
        checkPasswordsMatch();

        if (!form.checkValidity()) {
            event.preventDefault();
            form.reportValidity();
        }
    });
</script>

</body>
</html>

