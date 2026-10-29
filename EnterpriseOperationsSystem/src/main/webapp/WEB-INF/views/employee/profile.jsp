<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %>

<%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">


<title>My Profile | Enterprise Operations</title>

<style>
    body {
        margin: 0;
        padding: 30px;
        font-family: Arial, sans-serif;
        background: #f3f6fb;
        color: #1f2937;
    }

    .container {
        max-width: 850px;
        margin: 30px auto;
        padding: 28px;
        background: white;
        border-radius: 12px;
        box-shadow: 0 3px 12px rgba(15, 23, 42, 0.08);
    }

    h1 {
        color: #172554;
    }

    .profile-row {
        padding: 15px 0;
        border-bottom: 1px solid #e5e7eb;
        overflow-wrap: anywhere;
    }

    .label {
        display: inline-block;
        width: 180px;
        font-weight: bold;
    }

    .back-link {
        display: inline-block;
        margin-bottom: 18px;
        color: #2563eb;
        text-decoration: none;
    }

    @media (max-width: 600px) {
        body {
            padding: 12px;
        }

        .container {
            padding: 18px;
        }

        .label {
            display: block;
            width: auto;
            margin-bottom: 6px;
        }
    }
</style>


</head>

<body>
<div class="container">


<a class="back-link"
   href="${pageContext.request.contextPath}/employee/dashboard">
    &larr; Back to Dashboard
</a>

<h1>My Profile</h1>

<p>View your employee information below.</p>

<div class="profile-row">
    <span class="label">First Name</span>
    <c:out value="${employee.firstName}" default="Not available"/>
</div>

<div class="profile-row">
    <span class="label">Last Name</span>
    <c:out value="${employee.lastName}" default="Not available"/>
</div>

<div class="profile-row">
    <span class="label">Employee Code</span>
    <c:out value="${employee.employeeCode}" default="Not assigned"/>
</div>

<div class="profile-row">
    <span class="label">Username</span>
    <c:out value="${username}" default="Not available"/>
</div>

<div class="profile-row">
    <span class="label">Job Title</span>
    <c:out value="${employee.jobTitle}" default="Not specified"/>
</div>

<div class="profile-row">
    <span class="label">Department</span>
    <c:choose>
        <c:when test="${not empty employee.department}">
            <c:out value="${employee.department.name}"
                   default="Not assigned"/>
        </c:when>
        <c:otherwise>
            Not assigned
        </c:otherwise>
    </c:choose>
</div>

<div class="profile-row">
    <span class="label">Status</span>
    <c:out value="${employee.status}" default="Not specified"/>
</div>


</div>
</body>
</html>
