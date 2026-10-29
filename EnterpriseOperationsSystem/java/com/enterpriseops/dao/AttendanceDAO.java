package com.enterpriseops.dao;

import java.time.LocalDate;
import java.util.List;

import com.enterpriseops.model.Attendance;

public interface AttendanceDAO {

    void save(Attendance attendance);

    Attendance findById(Integer id);

    List<Attendance> findAll();

    List<Attendance> findByEmployee(Integer employeeId);

    List<Attendance> findByManager(Integer managerId);

    List<Attendance> findByManagerAndDate(
            Integer managerId,
            LocalDate attendanceDate);

    Attendance findByEmployeeAndDate(
            Integer employeeId,
            LocalDate attendanceDate);

    void update(Attendance attendance);

    void delete(Integer id);
}