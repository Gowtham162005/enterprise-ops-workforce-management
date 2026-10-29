package com.enterpriseops.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.dto.DashboardDTO;
import com.enterpriseops.service.DashboardService;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DashboardService dashboardService;

    @Override
    public void init() throws ServletException {
        dashboardService = new DashboardService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login");

            return;
        }

        DashboardDTO dashboard =
                dashboardService.getDashboardData();

        request.setAttribute(
                "dashboard",
                dashboard);

        request.setAttribute(
                "username",
                session.getAttribute("username"));

        request.setAttribute(
                "role",
                session.getAttribute("role"));

        request.getRequestDispatcher(
                "/WEB-INF/views/dashboard.jsp")
                .forward(request, response);
    }
}