package com.enterpriseops.service;

import java.util.List;

import com.enterpriseops.dao.AuditLogDAO;
import com.enterpriseops.dao.impl.AuditLogDAOImpl;
import com.enterpriseops.model.AuditLog;
import com.enterpriseops.model.User;

public class AuditLogService {

    private final AuditLogDAO auditLogDAO;

    public AuditLogService() {
        this.auditLogDAO = new AuditLogDAOImpl();
    }

    public void log(User user,
                    String action,
                    String entityType,
                    Integer entityId,
                    String description) {

        if (action == null ||
            action.trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Audit action is required");
        }

        AuditLog auditLog =
                new AuditLog(
                        user,
                        action.trim().toUpperCase(),
                        entityType,
                        entityId,
                        description);

        auditLogDAO.save(auditLog);
    }

    public List<AuditLog> getRecentLogs(int limit) {

        if (limit <= 0) {
            limit = 10;
        }

        return auditLogDAO.findRecent(limit);
    }

    public List<AuditLog> getAllLogs() {

        return auditLogDAO.findAll();
    }

    public AuditLog getLog(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid audit log ID");
        }

        return auditLogDAO.findById(id);
    }
}