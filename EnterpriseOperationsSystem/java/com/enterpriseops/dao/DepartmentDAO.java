package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.Department;

public interface DepartmentDAO {

    void save(Department department);

    Department findById(Integer id);

    List<Department> findAll();

    void update(Department department);

    void delete(Integer id);
}