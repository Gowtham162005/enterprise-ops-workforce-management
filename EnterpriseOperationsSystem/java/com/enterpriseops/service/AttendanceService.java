
package com.enterpriseops.service;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.Arrays;
import java.util.List;

import com.enterpriseops.dao.AttendanceDAO;
import com.enterpriseops.dao.impl.AttendanceDAOImpl;
import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Employee;

public class AttendanceService {

    private final AttendanceDAO attendanceDAO;
    private final AuditLogService auditLogService;

    public AttendanceService() {
        this.attendanceDAO = new AttendanceDAOImpl();
        this.auditLogService = new AuditLogService();
    }

    /*
     * EMPLOYEE / MANAGER PERSONAL ATTENDANCE
     */

    public Attendance getTodayAttendance(Integer employeeId) {
        validateEmployeeId(employeeId);

        return attendanceDAO.findByEmployeeAndDate(
                employeeId, LocalDate.now());
    }

    public Attendance checkIn(Integer employeeId) {
        validateEmployeeId(employeeId);

        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now().withNano(0);

        Attendance existing =
                attendanceDAO.findByEmployeeAndDate(
                        employeeId, today);

        if (existing != null) {
            // Allow check-in if an administrator created a
            // PRESENT record without recording a check-in.
            if ("PRESENT".equalsIgnoreCase(existing.getStatus())
                    && existing.getCheckIn() == null
                    && existing.getCheckOut() == null) {

                existing.setCheckIn(now);
                attendanceDAO.update(existing);

                logAttendance(
                        "UPDATE", existing,
                        "Check-in recorded");

                return existing;
            }

            throw new IllegalStateException(
                    "An attendance record already exists for today, "
                    + "or you have already checked in.");
        }

        Employee employee = new Employee();
        employee.setId(employeeId);

        Attendance attendance = new Attendance();
        attendance.setEmployee(employee);
        attendance.setAttendanceDate(today);
        attendance.setStatus("PRESENT");
        attendance.setCheckIn(now);

        // DAO enforces the database's unique employee/date constraint.
        attendanceDAO.save(attendance);

        logAttendance(
                "CREATE", attendance,
                "Employee checked in");

        return attendance;
    }

    public Attendance checkOut(Integer employeeId) {
        validateEmployeeId(employeeId);

        LocalDate today = LocalDate.now();
        LocalTime now = LocalTime.now().withNano(0);

        Attendance attendance =
                attendanceDAO.findByEmployeeAndDate(
                        employeeId, today);

        if (attendance == null
                || attendance.getCheckIn() == null) {
            throw new IllegalStateException(
                    "Please check in before checking out.");
        }

        if (attendance.getCheckOut() != null) {
            throw new IllegalStateException(
                    "You have already checked out today.");
        }

        if (!"PRESENT".equalsIgnoreCase(
                attendance.getStatus())) {
            throw new IllegalStateException(
                    "Your attendance status does not allow check-out.");
        }

        if (now.isBefore(attendance.getCheckIn())) {
            throw new IllegalStateException(
                    "Check-out time cannot be before check-in time.");
        }

        attendance.setCheckOut(now);
        attendanceDAO.update(attendance);

        logAttendance(
                "UPDATE", attendance,
                "Employee checked out");

        return attendance;
    }

    /*
     * EXISTING ATTENDANCE OPERATIONS
     */

    public void addAttendance(Attendance attendance) {
        validateAttendance(attendance);

        Integer employeeId =
                attendance.getEmployee().getId();

        Attendance existing =
                attendanceDAO.findByEmployeeAndDate(
                        employeeId,
                        attendance.getAttendanceDate());

        if (existing != null) {
            throw new IllegalArgumentException(
                    "Attendance already exists for this employee on this date");
        }

        attendanceDAO.save(attendance);

        logAttendance(
                "CREATE", attendance,
                "Attendance created for employee " + employeeId);
    }

    public Attendance getAttendance(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid attendance ID");
        }

        return attendanceDAO.findById(id);
    }

    public List<Attendance> getAllAttendance() {
        return attendanceDAO.findAll();
    }

    public List<Attendance> getEmployeeAttendance(
            Integer employeeId) {
        validateEmployeeId(employeeId);
        return attendanceDAO.findByEmployee(employeeId);
    }

    public List<Attendance> getTeamAttendance(
            Integer managerId) {
        validateEmployeeId(managerId);
        return attendanceDAO.findByManager(managerId);
    }

    public List<Attendance> getTeamAttendanceByDate(
            Integer managerId,
            LocalDate attendanceDate) {

        validateEmployeeId(managerId);

        if (attendanceDate == null) {
            throw new IllegalArgumentException(
                    "Attendance date is required");
        }

        return attendanceDAO.findByManagerAndDate(
                managerId, attendanceDate);
    }

    public void updateAttendance(Attendance attendance) {
        if (attendance == null
                || attendance.getId() == null
                || attendance.getId() <= 0) {
            throw new IllegalArgumentException(
                    "Invalid attendance");
        }

        validateAttendance(attendance);

        Attendance existing =
                attendanceDAO.findByEmployeeAndDate(
                        attendance.getEmployee().getId(),
                        attendance.getAttendanceDate());

        if (existing != null
                && !existing.getId().equals(attendance.getId())) {
            throw new IllegalArgumentException(
                    "Attendance already exists for this employee on this date");
        }

        attendanceDAO.update(attendance);

        logAttendance(
                "UPDATE", attendance,
                "Attendance updated");
    }

    public void deleteAttendance(Integer id) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid attendance ID");
        }

        Attendance existing = attendanceDAO.findById(id);
        attendanceDAO.delete(id);

        logAttendance(
                "DELETE", existing,
                "Attendance deleted: ID " + id);
    }

    /*
     * VALIDATION AND AUDIT HELPERS
     */

    private void validateEmployeeId(Integer employeeId) {
        if (employeeId == null || employeeId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid employee ID");
        }
    }

    private void validateAttendance(Attendance attendance) {
        if (attendance == null) {
            throw new IllegalArgumentException(
                    "Attendance cannot be null");
        }

        Employee employee = attendance.getEmployee();

        if (employee == null
                || employee.getId() == null
                || employee.getId() <= 0) {
            throw new IllegalArgumentException(
                    "Employee is required");
        }

        LocalDate date = attendance.getAttendanceDate();

        if (date == null) {
            throw new IllegalArgumentException(
                    "Attendance date is required");
        }

        if (date.isAfter(LocalDate.now())) {
            throw new IllegalArgumentException(
                    "Attendance date cannot be in the future");
        }

        String status = attendance.getStatus();

        if (status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Attendance status is required");
        }

        status = status.trim().toUpperCase();

        if (!Arrays.asList(
                "PRESENT", "ABSENT", "HALF_DAY", "LEAVE"
        ).contains(status)) {
            throw new IllegalArgumentException(
                    "Invalid attendance status");
        }

        attendance.setStatus(status);

        if (attendance.getNotes() != null) {
            attendance.setNotes(
                    attendance.getNotes().trim());
        }

        // Do not compare LocalTime values here: an overnight
        // shift can legitimately finish after midnight.
    }

    private void logAttendance(
            String action,
            Attendance attendance,
            String description) {

        try {
            auditLogService.log(
                    null,
                    action,
                    "ATTENDANCE",
                    attendance != null ? attendance.getId() : null,
                    description);
        } catch (Exception e) {
            System.err.println(
                    "Warning: Attendance audit failed.");
            e.printStackTrace();
        }
    }
}
