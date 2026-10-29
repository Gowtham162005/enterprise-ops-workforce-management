package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.AuditLog;

public interface AuditLogDAO {

    void save(AuditLog auditLog);

    AuditLog findById(Integer id);

    List<AuditLog> findRecent(int limit);

    List<AuditLog> findAll();
}