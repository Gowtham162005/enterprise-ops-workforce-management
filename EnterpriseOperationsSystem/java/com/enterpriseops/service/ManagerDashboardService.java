package com.enterpriseops.service;

import com.enterpriseops.dao.ManagerDashboardDAO;
import com.enterpriseops.dao.impl.ManagerDashboardDAOImpl;
import com.enterpriseops.dto.ManagerDashboardDTO;

public class ManagerDashboardService {

    private final ManagerDashboardDAO managerDashboardDAO;

    public ManagerDashboardService() {
        this.managerDashboardDAO = new ManagerDashboardDAOImpl();
    }

    public ManagerDashboardDTO getDashboardData(Integer managerEmployeeId) {

        if (managerEmployeeId == null || managerEmployeeId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid manager employee ID");
        }

        return managerDashboardDAO.getDashboardData(managerEmployeeId);
    }
}