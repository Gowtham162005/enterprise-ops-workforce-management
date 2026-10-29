package com.enterpriseops.dao;

import com.enterpriseops.dto.ManagerDashboardDTO;

public interface ManagerDashboardDAO {

    ManagerDashboardDTO getDashboardData(Integer managerEmployeeId);
}