
package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.User;
import com.enterpriseops.service.LeaveService;

@WebServlet("/manager/approvals")
public class ManagerApprovalServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private LeaveService leaveService;

    @Override
    public void init() throws ServletException {
        leaveService = new LeaveService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInManager(request, response);

        if (user == null) {
            return;
        }

        Integer managerId = user.getEmployee().getId();

        try {
            List<LeaveRequest> leaveRequests =
                    leaveService.getLeaveRequestsByManager(managerId);

            request.setAttribute("leaveRequests", leaveRequests);
            request.setAttribute("managerEmployeeId", managerId);
            request.setAttribute("username", user.getUsername());
            request.setAttribute("role", user.getRole().getName());

            request.getRequestDispatcher(
                    "/WEB-INF/views/manager/approvals.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to load leave approvals. Check the server console.");
            }
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        User user = getLoggedInManager(request, response);

        if (user == null) {
            return;
        }

        String action = request.getParameter("action");

        // Accept both parameter names to support existing forms.
        String idValue = request.getParameter("id");

        if (idValue == null || idValue.trim().isEmpty()) {
            idValue = request.getParameter("leaveId");
        }

        if (idValue == null || idValue.trim().isEmpty()) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Leave ID is missing. Submit either id or leaveId.");
            return;
        }

        if (!"approve".equalsIgnoreCase(action)
                && !"reject".equalsIgnoreCase(action)) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid approval action.");
            return;
        }

        final int leaveId;

        try {
            leaveId = Integer.parseInt(idValue.trim());

            if (leaveId <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Invalid leave ID.");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Leave ID must be a valid number.");
            return;
        }

        Integer managerId = user.getEmployee().getId();

        try {
            if ("approve".equalsIgnoreCase(action)) {
                leaveService.approveLeaveForManager(
                        leaveId, managerId);
            } else {
                leaveService.rejectLeaveForManager(
                        leaveId, managerId);
            }

            response.sendRedirect(
                    request.getContextPath() + "/manager/approvals");

        } catch (SecurityException e) {
            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    e.getMessage());

        } catch (Exception e) {
            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to process leave approval. Check the server console.");
            }
        }
    }

    private User getLoggedInManager(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return null;
        }

        Object loggedInUser = session.getAttribute("loggedInUser");

        if (!(loggedInUser instanceof User)) {
            response.sendRedirect(
                    request.getContextPath() + "/login");
            return null;
        }

        User user = (User) loggedInUser;

        if (user.getRole() == null
                || !"MANAGER".equalsIgnoreCase(
                        user.getRole().getName())) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager access required.");
            return null;
        }

        if (user.getEmployee() == null
                || user.getEmployee().getId() == null) {

            response.sendError(
                    HttpServletResponse.SC_FORBIDDEN,
                    "Manager employee profile is not configured.");
            return null;
        }

        return user;
    }
}
