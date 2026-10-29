package com.enterpriseops.service;

import com.enterpriseops.dao.DashboardDAO;
import com.enterpriseops.dao.impl.DashboardDAOImpl;
import com.enterpriseops.dto.DashboardDTO;

public class DashboardService {

    private final DashboardDAO dashboardDAO;

    public DashboardService() {
        this.dashboardDAO = new DashboardDAOImpl();
    }

    public DashboardDTO getDashboardData() {
        return dashboardDAO.getDashboardData();
    }
}