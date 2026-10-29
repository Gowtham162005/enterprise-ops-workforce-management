package com.enterpriseops.dao.impl;

import org.hibernate.Session;

import com.enterpriseops.dao.ReportDAO;
import com.enterpriseops.dto.ReportDTO;
import com.enterpriseops.util.HibernateUtil;

public class ReportDAOImpl implements ReportDAO {

    @Override
    public ReportDTO getReportData() {

        ReportDTO report = new ReportDTO();

        try (Session session = HibernateUtil.getSessionFactory().openSession()) {

            Long totalEmployees = session.createQuery(
                    "SELECT COUNT(e) FROM Employee e",
                    Long.class
            ).uniqueResult();

            Long activeEmployees = session.createQuery(
                    "SELECT COUNT(e) FROM Employee e WHERE UPPER(e.status) = 'ACTIVE'",
                    Long.class
            ).uniqueResult();

            Long totalDepartments = session.createQuery(
                    "SELECT COUNT(d) FROM Department d",
                    Long.class
            ).uniqueResult();

            Long totalProjects = session.createQuery(
                    "SELECT COUNT(p) FROM Project p",
                    Long.class
            ).uniqueResult();

            Long activeProjects = session.createQuery(
                    "SELECT COUNT(p) FROM Project p WHERE UPPER(p.status) = 'ACTIVE'",
                    Long.class
            ).uniqueResult();

            Long totalTasks = session.createQuery(
                    "SELECT COUNT(t) FROM Task t",
                    Long.class
            ).uniqueResult();

            Long todoTasks = session.createQuery(
                    "SELECT COUNT(t) FROM Task t WHERE UPPER(t.status) = 'TODO'",
                    Long.class
            ).uniqueResult();

            Long inProgressTasks = session.createQuery(
                    "SELECT COUNT(t) FROM Task t WHERE UPPER(t.status) = 'IN_PROGRESS'",
                    Long.class
            ).uniqueResult();

            Long completedTasks = session.createQuery(
                    "SELECT COUNT(t) FROM Task t WHERE UPPER(t.status) = 'COMPLETED'",
                    Long.class
            ).uniqueResult();

            Long blockedTasks = session.createQuery(
                    "SELECT COUNT(t) FROM Task t WHERE UPPER(t.status) = 'BLOCKED'",
                    Long.class
            ).uniqueResult();

            Long totalLeaveRequests = session.createQuery(
                    "SELECT COUNT(l) FROM LeaveRequest l",
                    Long.class
            ).uniqueResult();

            Long pendingLeaves = session.createQuery(
                    "SELECT COUNT(l) FROM LeaveRequest l WHERE UPPER(l.status) = 'PENDING'",
                    Long.class
            ).uniqueResult();

            Long approvedLeaves = session.createQuery(
                    "SELECT COUNT(l) FROM LeaveRequest l WHERE UPPER(l.status) = 'APPROVED'",
                    Long.class
            ).uniqueResult();

            Long rejectedLeaves = session.createQuery(
                    "SELECT COUNT(l) FROM LeaveRequest l WHERE UPPER(l.status) = 'REJECTED'",
                    Long.class
            ).uniqueResult();

            Long totalAttendance = session.createQuery(
                    "SELECT COUNT(a) FROM Attendance a",
                    Long.class
            ).uniqueResult();

            Long presentAttendance = session.createQuery(
                    "SELECT COUNT(a) FROM Attendance a WHERE UPPER(a.status) = 'PRESENT'",
                    Long.class
            ).uniqueResult();

            Long absentAttendance = session.createQuery(
                    "SELECT COUNT(a) FROM Attendance a WHERE UPPER(a.status) = 'ABSENT'",
                    Long.class
            ).uniqueResult();

            Long lateAttendance = session.createQuery(
                    "SELECT COUNT(a) FROM Attendance a WHERE UPPER(a.status) = 'LATE'",
                    Long.class
            ).uniqueResult();

            report.setTotalEmployees(value(totalEmployees));
            report.setActiveEmployees(value(activeEmployees));

            report.setTotalDepartments(value(totalDepartments));

            report.setTotalProjects(value(totalProjects));
            report.setActiveProjects(value(activeProjects));

            report.setTotalTasks(value(totalTasks));
            report.setTodoTasks(value(todoTasks));
            report.setInProgressTasks(value(inProgressTasks));
            report.setCompletedTasks(value(completedTasks));
            report.setBlockedTasks(value(blockedTasks));

            report.setTotalLeaveRequests(value(totalLeaveRequests));
            report.setPendingLeaves(value(pendingLeaves));
            report.setApprovedLeaves(value(approvedLeaves));
            report.setRejectedLeaves(value(rejectedLeaves));

            report.setTotalAttendance(value(totalAttendance));
            report.setPresentAttendance(value(presentAttendance));
            report.setAbsentAttendance(value(absentAttendance));
            report.setLateAttendance(value(lateAttendance));

            return report;

        } catch (Exception e) {
            throw new RuntimeException("Error loading report data", e);
        }
    }

    private long value(Long value) {
        return value != null ? value : 0L;
    }
}