package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.LeaveRequest;

public interface LeaveDAO {

    void save(LeaveRequest leaveRequest);

    LeaveRequest findById(Integer id);

    List<LeaveRequest> findAll();

    List<LeaveRequest> findByManager(Integer managerId);

    LeaveRequest findByIdAndManager(
            Integer leaveId,
            Integer managerId);

    void update(LeaveRequest leaveRequest);

    void delete(Integer id);
    
    List<LeaveRequest> findByEmployee(Integer employeeId);
}