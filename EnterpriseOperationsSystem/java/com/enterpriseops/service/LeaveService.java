
package com.enterpriseops.service;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;

import com.enterpriseops.dao.LeaveDAO;
import com.enterpriseops.dao.impl.LeaveDAOImpl;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.User;

public class LeaveService {

    private final LeaveDAO leaveDAO;
    private final AuditLogService auditLogService;

    private static final List<String> ALLOWED_LEAVE_TYPES =
            Arrays.asList(
                    "CASUAL",
                    "SICK",
                    "ANNUAL",
                    "MATERNITY",
                    "PATERNITY",
                    "UNPAID"
            );

    public LeaveService() {
        this.leaveDAO = new LeaveDAOImpl();
        this.auditLogService = new AuditLogService();
    }

    // =========================================================
    // ADD LEAVE REQUEST

 // ADD LEAVE REQUEST
    public void addLeaveRequest(LeaveRequest leaveRequest) {
    	
    	System.out.println("STATUS RECEIVED BY SERVICE = "
    	        + (leaveRequest == null ? "NULL" : leaveRequest.getStatus()));

        if (leaveRequest == null) {
            throw new IllegalArgumentException(
                    "Leave request cannot be null");
        }

        System.out.println(
                "=== SERVICE STATUS: "
                + leaveRequest.getStatus()
                + " ===");

        validateLeaveRequest(leaveRequest);

        String initialStatus = leaveRequest.getStatus();

        if (initialStatus == null) {
            throw new IllegalArgumentException(
                    "Initial leave status is missing. "
                    + "Please check LeaveServlet.java.");
        }

        initialStatus = initialStatus.trim().toUpperCase(Locale.ROOT);

        if (!"PENDING_MANAGER".equals(initialStatus)
                && !"PENDING_ADMIN".equals(initialStatus)) {

            throw new IllegalArgumentException(
                    "Invalid initial leave status: " + initialStatus
                    + ". Employee leave must start at PENDING_MANAGER"
                    + " and manager leave at PENDING_ADMIN.");
        }

        leaveRequest.setStatus(initialStatus);


        // Clear previous review information for a new request.
        leaveRequest.setReviewedBy(null);
        leaveRequest.setReviewedAt(null);

        leaveRequest.setManagerDecision(null);
        leaveRequest.setManagerReviewedBy(null);
        leaveRequest.setManagerReviewedAt(null);

        leaveRequest.setAdminDecision(null);
        leaveRequest.setAdminReviewedBy(null);
        leaveRequest.setAdminReviewedAt(null);

        leaveDAO.save(leaveRequest);

        try {
            auditLogService.log(
                    null,
                    "CREATE",
                    "LEAVE_REQUEST",
                    leaveRequest.getId(),
                    "Leave request created for employee "
                            + getEmployeeId(leaveRequest)
                            + ": " + leaveRequest.getLeaveType()
                            + " from " + leaveRequest.getStartDate()
                            + " to " + leaveRequest.getEndDate()
                            + ", initial status " + initialStatus
            );
        } catch (Exception e) {
            logAuditWarning("created", e);
        }
    }

    // =========================================================
    // GET LEAVE REQUESTS
    // =========================================================

    public List<LeaveRequest> getLeaveRequestsByManager(
            Integer managerId) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException("Invalid manager ID");
        }

        return leaveDAO.findByManager(managerId);
    }

    public LeaveRequest getLeaveRequest(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid leave request ID");
        }

        return leaveDAO.findById(id);
    }

    public List<LeaveRequest> getAllLeaveRequests() {
        return leaveDAO.findAll();
    }

    public List<LeaveRequest> getLeaveRequestsByEmployee(
            Integer employeeId) {

        if (employeeId == null || employeeId <= 0) {
            throw new IllegalArgumentException("Invalid employee ID");
        }

        return leaveDAO.findByEmployee(employeeId);
    }

    // =========================================================
    // UPDATE LEAVE REQUEST
    // =========================================================

    public void updateLeaveRequest(LeaveRequest leaveRequest) {

        if (leaveRequest == null
                || leaveRequest.getId() == null
                || leaveRequest.getId() <= 0) {

            throw new IllegalArgumentException("Invalid leave request");
        }

        LeaveRequest existing =
                leaveDAO.findById(leaveRequest.getId());

        if (existing == null) {
            throw new IllegalArgumentException(
                    "Leave request not found");
        }

        validateLeaveRequest(leaveRequest);

        // Preserve the existing workflow and review history.
        leaveRequest.setStatus(existing.getStatus());

        leaveRequest.setReviewedBy(existing.getReviewedBy());
        leaveRequest.setReviewedAt(existing.getReviewedAt());

        leaveRequest.setManagerDecision(
                existing.getManagerDecision());
        leaveRequest.setManagerReviewedBy(
                existing.getManagerReviewedBy());
        leaveRequest.setManagerReviewedAt(
                existing.getManagerReviewedAt());

        leaveRequest.setAdminDecision(
                existing.getAdminDecision());
        leaveRequest.setAdminReviewedBy(
                existing.getAdminReviewedBy());
        leaveRequest.setAdminReviewedAt(
                existing.getAdminReviewedAt());

        // Do not allow the employee owner to be changed.
        leaveRequest.setEmployee(existing.getEmployee());

        leaveDAO.update(leaveRequest);

        try {
            auditLogService.log(
                    null,
                    "UPDATE",
                    "LEAVE_REQUEST",
                    leaveRequest.getId(),
                    "Leave request details updated for employee "
                            + getEmployeeId(leaveRequest)
                            + ", status remains "
                            + existing.getStatus()
            );
        } catch (Exception e) {
            logAuditWarning("updated", e);
        }
    }

    // =========================================================
    // MANAGER APPROVAL
    // =========================================================

    public void approveLeaveForManager(
            Integer leaveId, Integer managerId) {

        reviewLeaveForManager(leaveId, managerId, "APPROVED");
    }

    public void rejectLeaveForManager(
            Integer leaveId, Integer managerId) {

        reviewLeaveForManager(leaveId, managerId, "REJECTED");
    }

    private void reviewLeaveForManager(
            Integer leaveId,
            Integer managerId,
            String decision) {

        if (leaveId == null || leaveId <= 0
                || managerId == null || managerId <= 0) {

            throw new IllegalArgumentException(
                    "Invalid leave request or manager ID");
        }

        // Only requests assigned to this manager can be reviewed.
        LeaveRequest leave =
                leaveDAO.findByIdAndManager(leaveId, managerId);

        if (leave == null) {
            throw new SecurityException(
                    "You are not authorized to review this leave request");
        }

        if (!"PENDING_MANAGER".equals(leave.getStatus())
                && !"PENDING".equals(leave.getStatus())) {

            throw new IllegalStateException(
                    "This request is not awaiting manager approval");
        }

        Employee manager = leave.getEmployee().getManager();

        if (manager == null
                || manager.getId() == null
                || !managerId.equals(manager.getId())) {

            throw new SecurityException(
                    "Manager authorization failed");
        }

        LocalDateTime now = LocalDateTime.now();
        String oldStatus = leave.getStatus();

        leave.setManagerDecision(decision);
        leave.setManagerReviewedBy(manager);
        leave.setManagerReviewedAt(now);

        if ("REJECTED".equals(decision)) {

            leave.setStatus("REJECTED");
            leave.setReviewedBy(manager);
            leave.setReviewedAt(now);

        } else {

            // Manager approval is not final approval.
            leave.setStatus("PENDING_ADMIN");
        }

        leaveDAO.update(leave);

        writeReviewAudit(
                leaveId,
                oldStatus,
                leave.getStatus(),
                managerId
        );
    }

    // =========================================================
    // ADMIN APPROVAL
    // =========================================================

    public void approveLeave(Integer leaveId, User admin) {
        reviewLeaveAsAdmin(leaveId, admin, "APPROVED");
    }

    public void rejectLeave(Integer leaveId, User admin) {
        reviewLeaveAsAdmin(leaveId, admin, "REJECTED");
    }

    private void reviewLeaveAsAdmin(
            Integer leaveId,
            User admin,
            String decision) {

        if (leaveId == null || leaveId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid leave request ID");
        }

        if (admin == null
                || admin.getId() == null
                || admin.getRole() == null
                || !"ADMIN".equalsIgnoreCase(
                        admin.getRole().getName())) {

            throw new SecurityException(
                    "An administrator account is required");
        }

        LeaveRequest leave = leaveDAO.findById(leaveId);

        if (leave == null) {
            throw new IllegalArgumentException(
                    "Leave request not found");
        }

        if (!"PENDING_ADMIN".equals(leave.getStatus())) {
            throw new IllegalStateException(
                    "This request is not awaiting admin approval");
        }

        // Prevent an administrator from approving their own leave.
        if (leave.getEmployee() != null
                && admin.getEmployee() != null
                && leave.getEmployee().getId().equals(
                        admin.getEmployee().getId())) {

            throw new SecurityException(
                    "You cannot approve your own leave request");
        }

        LocalDateTime now = LocalDateTime.now();
        String oldStatus = leave.getStatus();

        leave.setAdminDecision(decision);
        leave.setAdminReviewedBy(admin);
        leave.setAdminReviewedAt(now);
        leave.setStatus(decision);

        // Maintain legacy review fields where possible.
        if (admin.getEmployee() != null) {
            leave.setReviewedBy(admin.getEmployee());
        }

        leave.setReviewedAt(now);

        leaveDAO.update(leave);

        try {
            auditLogService.log(
                    null,
                    "REJECTED".equals(decision) ? "REJECT" : "APPROVE",
                    "LEAVE_REQUEST",
                    leaveId,
                    "Admin decision changed status from "
                            + oldStatus + " to " + decision
                            + " by user " + admin.getId()
            );
        } catch (Exception e) {
            logAuditWarning("reviewed", e);
        }
    }

    // =========================================================
    // AUDIT
    // =========================================================

    private void writeReviewAudit(
            Integer leaveId,
            String oldStatus,
            String newStatus,
            Integer reviewerId) {

        try {
            String action =
                    "REJECTED".equalsIgnoreCase(newStatus)
                            ? "REJECT" : "APPROVE";

            auditLogService.log(
                    null,
                    action,
                    "LEAVE_REQUEST",
                    leaveId,
                    "Leave request status changed from "
                            + oldStatus + " to " + newStatus
                            + " by reviewer employee " + reviewerId
            );
        } catch (Exception e) {
            logAuditWarning("reviewed", e);
        }
    }

    private void logAuditWarning(
            String operation, Exception e) {

        System.err.println(
                "Warning: Leave request was " + operation
                        + ", but audit logging failed.");

        e.printStackTrace();
    }

    // =========================================================
    // DELETE LEAVE REQUEST
    // =========================================================

    public void deleteLeaveRequest(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid leave request ID");
        }

        LeaveRequest leaveRequest = leaveDAO.findById(id);

        if (leaveRequest == null) {
            throw new IllegalArgumentException(
                    "Leave request not found");
        }

        leaveDAO.delete(id);

        try {
            auditLogService.log(
                    null,
                    "DELETE",
                    "LEAVE_REQUEST",
                    id,
                    "Leave request deleted: "
                            + leaveRequest.getLeaveType()
                            + " from " + leaveRequest.getStartDate()
                            + " to " + leaveRequest.getEndDate()
                            + " for employee "
                            + getEmployeeId(leaveRequest)
            );
        } catch (Exception e) {
            logAuditWarning("deleted", e);
        }
    }

    // =========================================================
    // VALIDATION
    // =========================================================

    private void validateLeaveRequest(
            LeaveRequest leaveRequest) {

        if (leaveRequest == null) {
            throw new IllegalArgumentException(
                    "Leave request cannot be null");
        }

        if (leaveRequest.getEmployee() == null
                || leaveRequest.getEmployee().getId() == null
                || leaveRequest.getEmployee().getId() <= 0) {

            throw new IllegalArgumentException(
                    "Employee is required");
        }

        if (leaveRequest.getLeaveType() == null
                || leaveRequest.getLeaveType().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Leave type is required");
        }

        if (leaveRequest.getStartDate() == null
                || leaveRequest.getEndDate() == null) {

            throw new IllegalArgumentException(
                    "Start date and end date are required");
        }

        LocalDate startDate = leaveRequest.getStartDate();
        LocalDate endDate = leaveRequest.getEndDate();

        if (endDate.isBefore(startDate)) {
            throw new IllegalArgumentException(
                    "End date cannot be before start date");
        }

        String leaveType = leaveRequest.getLeaveType()
                .trim()
                .toUpperCase(Locale.ROOT);

        if (!ALLOWED_LEAVE_TYPES.contains(leaveType)) {
            throw new IllegalArgumentException(
                    "Invalid leave type: " + leaveType);
        }

        leaveRequest.setLeaveType(leaveType);
    }

    // =========================================================
    // HELPER
    // =========================================================

    private Integer getEmployeeId(LeaveRequest leaveRequest) {

        if (leaveRequest == null
                || leaveRequest.getEmployee() == null) {

            return null;
        }

        return leaveRequest.getEmployee().getId();
    }
}
