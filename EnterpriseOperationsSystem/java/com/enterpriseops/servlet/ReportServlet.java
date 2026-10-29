package com.enterpriseops.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.dto.ReportDTO;
import com.enterpriseops.service.ReportService;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ReportDTO report = reportService.getReportData();

        request.setAttribute("report", report);
        request.setAttribute("username", session.getAttribute("username"));
        request.setAttribute("role", session.getAttribute("role"));

        request.getRequestDispatcher("/WEB-INF/views/reports.jsp")
               .forward(request, response);
    }
}