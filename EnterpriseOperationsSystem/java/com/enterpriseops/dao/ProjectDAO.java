package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.Project;

public interface ProjectDAO {

    void save(Project project);

    Project findById(Integer id);

    List<Project> findAll();
    List<Project> findByManager(Integer managerId);
    List<Project> findByEmployee(Integer employeeId);

    void update(Project project);

    void delete(Integer id);
    void addMember(Integer projectId, Integer employeeId);

    void removeMember(Integer projectId, Integer employeeId);
}