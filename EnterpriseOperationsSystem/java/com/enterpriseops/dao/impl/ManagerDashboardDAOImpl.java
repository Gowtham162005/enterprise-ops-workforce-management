
package com.enterpriseops.dao.impl;

import org.hibernate.Session;

import com.enterpriseops.dao.ManagerDashboardDAO;
import com.enterpriseops.dto.ManagerDashboardDTO;
import com.enterpriseops.model.Employee;
import com.enterpriseops.util.HibernateUtil;

public class ManagerDashboardDAOImpl implements ManagerDashboardDAO {

    @Override
    public ManagerDashboardDTO getDashboardData(
            Integer managerEmployeeId) {

        ManagerDashboardDTO dashboard =
                new ManagerDashboardDTO();

        try (Session session =
                     HibernateUtil.getSessionFactory()
                             .openSession()) {

            /*
             * Find logged-in manager
             */
            Employee manager =
                    session.get(
                            Employee.class,
                            managerEmployeeId);

            if (manager == null) {

                throw new IllegalArgumentException(
                        "Manager employee not found: "
                        + managerEmployeeId);
            }


            /*
             * ============================
             * MY TEAM
             * ============================
             *
             * Only employees whose
             * manager_id = logged-in manager ID.
             *
             * Example:
             *
             * Gowtham ID = 2
             *
             * manager_id = 2
             *
             * Gowtham
             * Harish
             * dineshsridhar
             */
            Long myTeam =
                    session.createQuery(
                            "SELECT COUNT(e) " +
                            "FROM Employee e " +
                            "WHERE e.manager.id = :managerEmployeeId " +
                            "AND UPPER(e.status) = 'ACTIVE'",
                            Long.class)
                    .setParameter(
                            "managerEmployeeId",
                            managerEmployeeId)
                    .uniqueResult();


            /*
             * ============================
             * DEPARTMENT
             * ============================
             *
             * Keep the existing department
             * based logic for the remaining
             * dashboard cards for now.
             */
            Integer departmentId = null;

            if (manager.getDepartment() != null) {

                departmentId =
                        manager.getDepartment().getId();
            }


            /*
             * If manager has no department,
             * return the dashboard with My Team.
             */
            if (departmentId == null) {

                dashboard.setMyTeam(
                        myTeam != null ? myTeam : 0);

                dashboard.setActiveProjects(0);
                dashboard.setOpenTasks(0);
                dashboard.setPendingLeaves(0);

                dashboard.setTodoTasks(0);
                dashboard.setInProgressTasks(0);
                dashboard.setCompletedTasks(0);
                dashboard.setBlockedTasks(0);

                return dashboard;
            }


            /*
             * ============================
             * ACTIVE PROJECTS
             * ============================
             *
             * Existing working logic.
             */
            Long activeProjects =
                    session.createQuery(
                            "SELECT COUNT(DISTINCT p) " +
                            "FROM Project p " +
                            "LEFT JOIN p.members m " +
                            "WHERE UPPER(p.status) = 'ACTIVE' " +
                            "AND (" +
                            "p.manager.id = :managerEmployeeId " +
                            "OR m.department.id = :departmentId" +
                            ")",
                            Long.class)
                    .setParameter(
                            "managerEmployeeId",
                            managerEmployeeId)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * OPEN TASKS
             * ============================
             */
            Long openTasks =
                    session.createQuery(
                            "SELECT COUNT(t) " +
                            "FROM Task t " +
                            "WHERE t.status IN " +
                            "('TODO', 'IN_PROGRESS') " +
                            "AND t.assignedEmployee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * PENDING LEAVE APPROVALS
             * ============================
             */
            Long pendingLeaves =
                    session.createQuery(
                            "SELECT COUNT(l) " +
                            "FROM LeaveRequest l " +
                            "WHERE UPPER(l.status) = 'PENDING' " +
                            "AND l.employee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * TODO TASKS
             * ============================
             */
            Long todoTasks =
                    session.createQuery(
                            "SELECT COUNT(t) " +
                            "FROM Task t " +
                            "WHERE t.status = 'TODO' " +
                            "AND t.assignedEmployee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * IN PROGRESS TASKS
             * ============================
             */
            Long inProgressTasks =
                    session.createQuery(
                            "SELECT COUNT(t) " +
                            "FROM Task t " +
                            "WHERE t.status = 'IN_PROGRESS' " +
                            "AND t.assignedEmployee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * COMPLETED TASKS
             * ============================
             */
            Long completedTasks =
                    session.createQuery(
                            "SELECT COUNT(t) " +
                            "FROM Task t " +
                            "WHERE t.status = 'COMPLETED' " +
                            "AND t.assignedEmployee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * BLOCKED TASKS
             * ============================
             */
            Long blockedTasks =
                    session.createQuery(
                            "SELECT COUNT(t) " +
                            "FROM Task t " +
                            "WHERE t.status = 'BLOCKED' " +
                            "AND t.assignedEmployee.department.id " +
                            "= :departmentId",
                            Long.class)
                    .setParameter(
                            "departmentId",
                            departmentId)
                    .uniqueResult();


            /*
             * ============================
             * SET DTO VALUES
             * ============================
             */

            dashboard.setMyTeam(
                    myTeam != null
                            ? myTeam
                            : 0);

            dashboard.setActiveProjects(
                    activeProjects != null
                            ? activeProjects
                            : 0);

            dashboard.setOpenTasks(
                    openTasks != null
                            ? openTasks
                            : 0);

            dashboard.setPendingLeaves(
                    pendingLeaves != null
                            ? pendingLeaves
                            : 0);

            dashboard.setTodoTasks(
                    todoTasks != null
                            ? todoTasks
                            : 0);

            dashboard.setInProgressTasks(
                    inProgressTasks != null
                            ? inProgressTasks
                            : 0);

            dashboard.setCompletedTasks(
                    completedTasks != null
                            ? completedTasks
                            : 0);

            dashboard.setBlockedTasks(
                    blockedTasks != null
                            ? blockedTasks
                            : 0);


            return dashboard;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error loading manager dashboard data",
                    e);
        }
    }
}