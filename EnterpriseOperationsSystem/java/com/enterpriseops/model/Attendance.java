package com.enterpriseops.model;

import javax.persistence.*;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(
    name = "attendance",
    uniqueConstraints = {
        @UniqueConstraint(
            name = "uk_attendance_employee_date",
            columnNames = {"employee_id", "attendance_date"}
        )
    }
)
public class Attendance {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "employee_id", nullable = false)
    private Employee employee;

    @Column(name = "attendance_date", nullable = false)
    private LocalDate attendanceDate;

    @Column(name = "status", nullable = false, length = 20)
    private String status;

    @Column(name = "check_in")
    private LocalTime checkIn;

    @Column(name = "check_out")
    private LocalTime checkOut;

    @Column(name = "notes", length = 500)
    private String notes;


    /*
     * ==========================================
     * CONSTRUCTOR
     * ==========================================
     */

    public Attendance() {
    }


    /*
     * ==========================================
     * ID
     * ==========================================
     */

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }


    /*
     * ==========================================
     * EMPLOYEE
     * ==========================================
     */

    public Employee getEmployee() {
        return employee;
    }

    public void setEmployee(Employee employee) {
        this.employee = employee;
    }


    /*
     * ==========================================
     * ATTENDANCE DATE
     * ==========================================
     */

    public LocalDate getAttendanceDate() {
        return attendanceDate;
    }

    public void setAttendanceDate(LocalDate attendanceDate) {
        this.attendanceDate = attendanceDate;
    }


    /*
     * ==========================================
     * STATUS
     * ==========================================
     */

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }


    /*
     * ==========================================
     * CHECK IN
     * ==========================================
     */

    public LocalTime getCheckIn() {
        return checkIn;
    }

    public void setCheckIn(LocalTime checkIn) {
        this.checkIn = checkIn;
    }


    /*
     * ==========================================
     * CHECK OUT
     * ==========================================
     */

    public LocalTime getCheckOut() {
        return checkOut;
    }

    public void setCheckOut(LocalTime checkOut) {
        this.checkOut = checkOut;
    }


    /*
     * ==========================================
     * NOTES
     * ==========================================
     */

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }


    /*
     * ==========================================
     * WORKING HOURS
     *
     * This is not stored in the database.
     * It is calculated from check-in and
     * check-out times.
     * ==========================================
     */

    @Transient
    public String getWorkingHours() {

        if (checkIn == null || checkOut == null) {
            return "—";
        }

        Duration duration =
                Duration.between(checkIn, checkOut);

        /*
         * Handle overnight attendance.
         * Example:
         * Check in 22:00
         * Check out 06:00
         */
        if (duration.isNegative()) {
            duration = duration.plusDays(1);
        }

        long hours = duration.toHours();

        long minutes =
                (duration.toMinutes() % 60);

        return hours + "h " + minutes + "m";
    }


    /*
     * ==========================================
     * STRING REPRESENTATION
     * ==========================================
     */

    @Override
    public String toString() {

        return "Attendance{" +
                "id=" + id +
                ", employee=" +
                (employee != null
                        ? employee.getId()
                        : null) +
                ", attendanceDate=" +
                attendanceDate +
                ", status='" +
                status +
                '\'' +
                ", checkIn=" +
                checkIn +
                ", checkOut=" +
                checkOut +
                '}';
    }
}
