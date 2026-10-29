package com.enterpriseops.servlet;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.enterpriseops.model.Department;
import com.enterpriseops.service.DepartmentService;

@WebServlet("/departments")
public class DepartmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private DepartmentService departmentService;

    @Override
    public void init() throws ServletException {

        departmentService = new DepartmentService();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if (action == null || action.equals("list")) {

            listDepartments(request, response);

        } else if (action.equals("add")) {

            showAddForm(request, response);

        } else if (action.equals("edit")) {

            showEditForm(request, response);

        } else if (action.equals("delete")) {

            deleteDepartment(request, response);

        } else {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action");
        }
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        if ("add".equals(action)) {

            addDepartment(request, response);

        } else if ("update".equals(action)) {

            updateDepartment(request, response);

        } else {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid action");
        }
    }

    private void listDepartments(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            List<Department> departments =
                    departmentService.getAllDepartments();

            request.setAttribute(
                    "departments",
                    departments);

            request.getRequestDispatcher(
                    "/WEB-INF/views/department/list.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load departments", e);
        }
    }

    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/WEB-INF/views/department/form.jsp")
                .forward(request, response);
    }

    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            Integer id = Integer.parseInt(
                    request.getParameter("id"));

            Department department =
                    departmentService.getDepartment(id);

            if (department == null) {

                response.sendError(
                        HttpServletResponse.SC_NOT_FOUND,
                        "Department not found");

                return;
            }

            request.setAttribute(
                    "department",
                    department);

            request.getRequestDispatcher(
                    "/WEB-INF/views/department/form.jsp")
                    .forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid department ID");

        } catch (Exception e) {

            throw new ServletException(
                    "Unable to load department", e);
        }
    }

    private void addDepartment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            String name =
                    request.getParameter("name");

            String description =
                    request.getParameter("description");

            Department department =
                    new Department(
                            name,
                            description);

            departmentService.addDepartment(
                    department);

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments");

        } catch (Exception e) {

            throw new IOException(
                    "Unable to add department", e);
        }
    }

    private void updateDepartment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            Integer id = Integer.parseInt(
                    request.getParameter("id"));

            String name =
                    request.getParameter("name");

            String description =
                    request.getParameter("description");

            Department department =
                    new Department(
                            name,
                            description);

            department.setId(id);

            departmentService.updateDepartment(
                    department);

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments");

        } catch (NumberFormatException e) {

            throw new IOException(
                    "Invalid department ID", e);

        } catch (Exception e) {

            throw new IOException(
                    "Unable to update department", e);
        }
    }

    private void deleteDepartment(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            Integer id = Integer.parseInt(
                    request.getParameter("id"));

            departmentService.deleteDepartment(id);

            response.sendRedirect(
                    request.getContextPath()
                    + "/departments");

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid department ID");

        } catch (Exception e) {

            throw new IOException(
                    "Unable to delete department", e);
        }
    }
}