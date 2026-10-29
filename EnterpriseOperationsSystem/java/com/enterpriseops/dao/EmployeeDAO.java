package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.Employee;

public interface EmployeeDAO {

    void save(Employee employee);

    Employee findById(Integer id);

    List<Employee> findAll();

    void update(Employee employee);

    void deactivate(Integer id);

    List<Employee> search(String keyword);

    List<Employee> findByDepartment(Integer departmentId);

    List<Employee> findByStatus(String status);

    long countEmployees();

    boolean existsByEmployeeCode(String employeeCode);

    boolean existsByEmail(String email);

    boolean existsByEmployeeCodeExceptId(
            String employeeCode,
            Integer id);

    boolean existsByEmailExceptId(
            String email,
            Integer id);

    // Manager methods
    List<Employee> findManagers();

    List<Employee> findManagersByDepartment(
            Integer departmentId);

    List<Employee> findByManager(
            Integer managerId);
}