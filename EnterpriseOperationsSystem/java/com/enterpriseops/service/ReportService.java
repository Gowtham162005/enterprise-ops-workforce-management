package com.enterpriseops.service;

import com.enterpriseops.dao.ReportDAO;
import com.enterpriseops.dao.impl.ReportDAOImpl;
import com.enterpriseops.dto.ReportDTO;

public class ReportService {

    private final ReportDAO reportDAO = new ReportDAOImpl();

    public ReportDTO getReportData() {
        return reportDAO.getReportData();
    }
}