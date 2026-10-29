package com.enterpriseops.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthorizationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig)
            throws ServletException {
        // Filter initialization
    }

    @Override
    public void doFilter(
            ServletRequest servletRequest,
            ServletResponse servletResponse,
            FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) servletRequest;

        HttpServletResponse response =
                (HttpServletResponse) servletResponse;

        String uri = request.getRequestURI();

        String contextPath = request.getContextPath();

        String path = uri.substring(contextPath.length());

        if (path.equals("/login") ||
                path.equals("/login.jsp") ||
                path.equals("/logout") ||
                path.startsWith("/assets/") ||
                path.startsWith("/css/") ||
                path.startsWith("/js/") ||
                path.startsWith("/images/")) {

            chain.doFilter(request, response);
            return;
        }

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("loggedInUser") == null) {

            response.sendRedirect(contextPath + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");

        if (role != null) {
            role = role.trim().toUpperCase();
        }
        /*
         * Role-specific URL protection.
         *
         * Admin can access /admin/*
         */
        if (path.startsWith("/admin/")) {

            if (!"ADMIN".equals(role)) {
                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Access denied");
                return;
            }
        }

        /*
         * Manager and Admin can access /manager/*
         */
        if (path.startsWith("/manager/")) {

            if (!"MANAGER".equals(role) &&
                    !"ADMIN".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Access denied");
                return;
            }
        }

        /*
         * Only Employee can access /employee/*
         */
        if (path.startsWith("/employee/")) {

            if (!"EMPLOYEE".equals(role)) {

                response.sendError(
                        HttpServletResponse.SC_FORBIDDEN,
                        "Access denied");
                return;
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Filter cleanup
    }
}