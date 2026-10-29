package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.Task;

public interface TaskDAO {

    List<Task> findByManager(Integer managerId);

    List<Task> findByAssignedEmployee(Integer employeeId);

    List<Task> findAll();

    Task findById(Integer id);

    boolean isProjectManagedBy(Integer projectId, Integer managerId);

    void save(Task task);

    void update(Task task);

    void delete(Integer id);
}