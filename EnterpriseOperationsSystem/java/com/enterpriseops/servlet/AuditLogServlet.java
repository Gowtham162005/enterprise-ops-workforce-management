package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.AuditLog;
import com.enterpriseops.service.AuditLogService;

@WebServlet("/audit-logs")
public class AuditLogServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final AuditLogService auditLogService =
            new AuditLogService();

    @Override
    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        /*
         * Authentication check
         */
        if (session == null ||
            session.getAttribute("username") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        /*
         * Load all audit logs
         */
        List<AuditLog> auditLogs =
                auditLogService.getAllLogs();

        request.setAttribute("auditLogs", auditLogs);

        /*
         * Forward username and role for the common topbar
         */
        request.setAttribute(
                "username",
                session.getAttribute("username"));

        request.setAttribute(
                "role",
                session.getAttribute("role"));

        /*
         * Open Audit Logs page
         */
        request.getRequestDispatcher(
                "/WEB-INF/views/audit-logs.jsp")
                .forward(request, response);
    }
}