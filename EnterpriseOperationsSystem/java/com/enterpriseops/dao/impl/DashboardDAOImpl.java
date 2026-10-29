package com.enterpriseops.dao.impl;

import org.hibernate.Session;

import com.enterpriseops.dao.DashboardDAO;
import com.enterpriseops.dto.DashboardDTO;
import com.enterpriseops.util.HibernateUtil;

public class DashboardDAOImpl implements DashboardDAO {

    @Override
    public DashboardDTO getDashboardData() {

        DashboardDTO dashboard = new DashboardDTO();

        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            // Total active employees
            Long totalEmployees = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE UPPER(e.status) = 'ACTIVE'",
                    Long.class)
                    .uniqueResult();

            // Active projects
            Long activeProjects = session.createQuery(
                    "SELECT COUNT(p) " +
                    "FROM Project p " +
                    "WHERE UPPER(p.status) = 'ACTIVE'",
                    Long.class)
                    .uniqueResult();

            // Open tasks
            Long openTasks = session.createQuery(
                    "SELECT COUNT(t) " +
                    "FROM Task t " +
                    "WHERE t.status IN ('TODO', 'IN_PROGRESS')",
                    Long.class)
                    .uniqueResult();

            // Pending leave requests
         // Pending leave requests awaiting manager or admin review
            Long pendingLeaves = session.createQuery(
                "SELECT COUNT(l) FROM LeaveRequest l " +
                "WHERE UPPER(l.status) IN " +
                "('PENDING', 'PENDING_MANAGER', 'PENDING_ADMIN')",
                Long.class
            ).uniqueResult();

            // TODO tasks
            Long todoTasks = session.createQuery(
                    "SELECT COUNT(t) " +
                    "FROM Task t " +
                    "WHERE t.status = 'TODO'",
                    Long.class)
                    .uniqueResult();

            // In-progress tasks
            Long inProgressTasks = session.createQuery(
                    "SELECT COUNT(t) " +
                    "FROM Task t " +
                    "WHERE t.status = 'IN_PROGRESS'",
                    Long.class)
                    .uniqueResult();

            // Completed tasks
            Long completedTasks = session.createQuery(
                    "SELECT COUNT(t) " +
                    "FROM Task t " +
                    "WHERE t.status = 'COMPLETED'",
                    Long.class)
                    .uniqueResult();

            // Blocked tasks
            Long blockedTasks = session.createQuery(
                    "SELECT COUNT(t) " +
                    "FROM Task t " +
                    "WHERE t.status = 'BLOCKED'",
                    Long.class)
                    .uniqueResult();

            dashboard.setTotalEmployees(
                    totalEmployees != null ? totalEmployees : 0);

            dashboard.setActiveProjects(
                    activeProjects != null ? activeProjects : 0);

            dashboard.setOpenTasks(
                    openTasks != null ? openTasks : 0);

            dashboard.setPendingLeaves(
                    pendingLeaves != null ? pendingLeaves : 0);

            dashboard.setTodoTasks(
                    todoTasks != null ? todoTasks : 0);

            dashboard.setInProgressTasks(
                    inProgressTasks != null ? inProgressTasks : 0);

            dashboard.setCompletedTasks(
                    completedTasks != null ? completedTasks : 0);

            dashboard.setBlockedTasks(
                    blockedTasks != null ? blockedTasks : 0);

            return dashboard;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error loading dashboard data", e);
        }
    }
}