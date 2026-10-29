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


<title>Employee Dashboard | Enterprise Operations</title>

<style>
    * {
        box-sizing: border-box;
    }

    html,
    body {
        margin: 0;
        min-height: 100%;
        font-family: Arial, sans-serif;
        background: #f3f6fb;
        color: #1f2937;
    }

    body {
        min-height: 100vh;
    }

    #employee-dashboard {
        position: relative;
        margin-left: 240px;
        width: calc(100% - 240px);
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        background: #f3f6fb;
        color: #1f2937;
    }

    #employee-dashboard,
    #employee-dashboard * {
        box-sizing: border-box;
    }

    #employee-dashboard .employee-topbar {
        position: relative;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 14px;
        padding: 20px 30px;
        background: #172554;
        color: #ffffff;
    }

    #employee-dashboard .employee-topbar h2 {
        margin: 0;
        font-size: 22px;
    }

    #employee-dashboard .topbar-actions {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: wrap;
    }

    #employee-dashboard .topbar-btn {
        display: inline-block;
        padding: 10px 16px;
        border-radius: 7px;
        color: #ffffff;
        text-decoration: none;
        font-size: 14px;
        font-weight: 600;
    }

    #employee-dashboard .apply-leave-btn {
        background: #2563eb;
    }

    #employee-dashboard .apply-leave-btn:hover {
        background: #1d4ed8;
    }

    #employee-dashboard .logout-btn {
        background: #dc2626;
    }

    #employee-dashboard .logout-btn:hover {
        background: #b91c1c;
    }

    #employee-dashboard .dashboard-container {
        display: block;
        width: 100%;
        max-width: 1100px;
        margin: 30px auto;
        padding: 0 24px;
        flex: 1;
    }

    #employee-dashboard .welcome {
        margin-bottom: 26px;
    }

    #employee-dashboard .welcome h1 {
        margin: 0 0 8px;
        font-size: 28px;
        line-height: 1.4;
        overflow-wrap: anywhere;
    }

    #employee-dashboard .welcome p,
    #employee-dashboard .card p {
        color: #64748b;
    }

    #employee-dashboard .profile,
    #employee-dashboard .card {
        background: #ffffff;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 3px 12px rgba(15, 23, 42, 0.06);
    }

    #employee-dashboard .profile {
        margin-bottom: 24px;
    }

    #employee-dashboard .profile h3 {
        margin: 0 0 18px;
        font-size: 20px;
    }

    #employee-dashboard .profile p {
        margin: 12px 0;
        line-height: 1.6;
        overflow-wrap: anywhere;
    }

    #employee-dashboard .cards {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 20px;
    }

    #employee-dashboard .card {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        min-width: 0;
    }

    #employee-dashboard .card h3 {
        margin: 0 0 10px;
        font-size: 19px;
    }

    #employee-dashboard .card p {
        line-height: 1.6;
        margin: 0;
        flex: 1;
    }

    #employee-dashboard .card a {
        display: inline-block;
        margin-top: 16px;
        padding: 10px 15px;
        border-radius: 6px;
        background: #2563eb;
        color: #ffffff;
        text-decoration: none;
        overflow-wrap: anywhere;
    }

    #employee-dashboard .card a:hover {
        background: #1d4ed8;
    }

    #employee-dashboard .topbar-btn:focus-visible,
    #employee-dashboard .card a:focus-visible {
        outline: 3px solid #93c5fd;
        outline-offset: 3px;
    }

    #employee-dashboard .employee-footer {
        text-align: center;
        color: #64748b;
        padding: 24px 15px;
        margin-top: auto;
    }

    @media (max-width: 900px) {
        #employee-dashboard .employee-topbar {
            padding: 20px;
        }

        #employee-dashboard .dashboard-container {
            padding: 0 18px;
        }

        #employee-dashboard .cards {
            gap: 16px;
        }
    }

    @media (max-width: 600px) {
        #employee-dashboard {
            margin-left: 0;
            width: 100%;
        }

        #employee-dashboard .employee-topbar {
            padding: 18px 15px;
            align-items: flex-start;
        }

        #employee-dashboard .employee-topbar h2 {
            font-size: 19px;
        }

        #employee-dashboard .topbar-actions {
            width: 100%;
            gap: 8px;
        }

        #employee-dashboard .topbar-btn {
            padding: 10px 12px;
            font-size: 13px;
        }

        #employee-dashboard .dashboard-container {
            padding: 0 14px;
            margin: 22px auto;
        }

        #employee-dashboard .welcome h1 {
            font-size: 23px;
        }

        #employee-dashboard .profile,
        #employee-dashboard .card {
            padding: 18px;
        }

        #employee-dashboard .cards {
            grid-template-columns: minmax(0, 1fr);
        }
    }
</style>


</head>

<body>


<%-- Keep the shared role-based sidebar unchanged. --%>
<%@ include file="../sidebar.jspf" %>

<div id="employee-dashboard">

    <header class="employee-topbar">

        <h2>Enterprise Operations</h2>

        <div class="topbar-actions">

            <a class="topbar-btn apply-leave-btn"
               href="${pageContext.request.contextPath}/employee/leaves">
                Apply Leave
            </a>

            <a class="topbar-btn logout-btn"
               href="${pageContext.request.contextPath}/logout">
                Logout
            </a>

        </div>

    </header>

    <main class="dashboard-container">

        <section class="welcome">

            <h1>
                Welcome,
                <c:out value="${employee.firstName}"
                       default="Employee"/>
                <c:out value="${employee.lastName}"/>!
            </h1>

            <p>Welcome to your employee dashboard.</p>

        </section>

        <section class="profile">

            <h3>My Profile</h3>

            <p>
                <strong>Employee Code:</strong>
                <c:out value="${employee.employeeCode}"
                       default="Not assigned"/>
            </p>

            <p>
                <strong>Job Title:</strong>
                <c:out value="${employee.jobTitle}"
                       default="Not specified"/>
            </p>

            <p>
                <strong>Username:</strong>
                <c:out value="${username}"
                       default="Not available"/>
            </p>

            <p>
                <strong>Status:</strong>
                <c:out value="${employee.status}"
                       default="Not specified"/>
            </p>

            <p>
                <strong>Department:</strong>

                <c:choose>
                    <c:when test="${not empty employee.department}">
                        <c:out value="${employee.department.name}"
                               default="Not assigned"/>
                    </c:when>

                    <c:otherwise>
                        Not assigned
                    </c:otherwise>
                </c:choose>
            </p>

            <a href="${pageContext.request.contextPath}/profile">
                View Full Profile
            </a>

        </section>

        <section class="cards">

            <!-- My Profile -->
            <article class="card">

                <h3>My Profile</h3>

                <p>
                    View your employee code, job title,
                    department, and account information.
                </p>

                <a href="${pageContext.request.contextPath}/profile">
                    View Profile
                </a>

            </article>

            <!-- My Projects -->
            <article class="card">

                <h3>My Projects</h3>

                <p>
                    View projects assigned to you and
                    check your project details.
                </p>

                <a href="${pageContext.request.contextPath}/employee/projects">
                    View Projects
                </a>

            </article>

            <!-- My Attendance -->
            <article class="card">

                <h3>My Attendance</h3>

                <p>
                    Record your daily check-in and check-out
                    and review your attendance.
                </p>

                <a href="${pageContext.request.contextPath}/employee/attendance">
                    Open Attendance
                </a>

            </article>

            <!-- My Tasks -->
            <article class="card">

                <h3>My Tasks</h3>

                <p>
                    Access your assigned work and track task progress.
                </p>

                <a href="${pageContext.request.contextPath}/employee/tasks">
                    View Tasks
                </a>

            </article>

            <!-- My Leave -->
            <article class="card">

                <h3>My Leave</h3>

                <p>
                    Apply for leave and review your leave requests.
                </p>

                <a href="${pageContext.request.contextPath}/employee/leaves">
                    Apply Leave
                </a>

            </article>

        </section>

    </main>

    <footer class="employee-footer">
        Enterprise Operations System
    </footer>

</div>


</body>
</html>
