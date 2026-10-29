
package com.enterpriseops.service;

import java.time.LocalDate;
import java.util.List;

import com.enterpriseops.dao.ProjectDAO;
import com.enterpriseops.dao.impl.ProjectDAOImpl;
import com.enterpriseops.model.Project;

public class ProjectService {

    private final ProjectDAO projectDAO;
    private final AuditLogService auditLogService;

    public ProjectService() {
        this.projectDAO = new ProjectDAOImpl();
        this.auditLogService = new AuditLogService();
    }

    // ---------------------------------------------------------
    // CREATE PROJECT
    // ---------------------------------------------------------

    public void addProject(Project project) {
        validateProject(project);

        projectDAO.save(project);

        auditSafely(
                "CREATE",
                project.getId(),
                "Project created: " + project.getProjectCode()
                        + " - " + project.getName());
    }

    // ---------------------------------------------------------
    // GET PROJECTS BY MANAGER
    // ---------------------------------------------------------

    public List<Project> getProjectsByManager(Integer managerId) {
        validateId(managerId, "manager ID");
        return projectDAO.findByManager(managerId);
    }

    // ---------------------------------------------------------
    // GET PROJECT
    // ---------------------------------------------------------

    public Project getProject(Integer id) {
        validateId(id, "project ID");
        return projectDAO.findById(id);
    }

    // ---------------------------------------------------------
    // GET PROJECTS BY EMPLOYEE
    // ---------------------------------------------------------

    public List<Project> getProjectsByEmployee(Integer employeeId) {
        validateId(employeeId, "employee ID");
        return projectDAO.findByEmployee(employeeId);
    }

    // ---------------------------------------------------------
    // GET ALL PROJECTS
    // ---------------------------------------------------------

    public List<Project> getAllProjects() {
        return projectDAO.findAll();
    }

    // ---------------------------------------------------------
    // UPDATE PROJECT
    // ---------------------------------------------------------

    public void updateProject(Project project) {
        validateProject(project);

        if (project.getId() == null || project.getId() <= 0) {
            throw new IllegalArgumentException("Invalid project ID.");
        }

        projectDAO.update(project);

        auditSafely(
                "UPDATE",
                project.getId(),
                "Project updated: " + project.getProjectCode()
                        + " - " + project.getName());
    }

    // ---------------------------------------------------------
    // DELETE PROJECT
    // ---------------------------------------------------------

    public void deleteProject(Integer id) {
        validateId(id, "project ID");

        Project existing = projectDAO.findById(id);

        if (existing == null) {
            throw new IllegalArgumentException("Project not found.");
        }

        String description = existing.getProjectCode()
                + " - " + existing.getName();

        projectDAO.delete(id);

        auditSafely(
                "DELETE",
                id,
                "Project deleted: " + description);
    }

    // ---------------------------------------------------------
    // ADD PROJECT MEMBER
    // ---------------------------------------------------------

    public void addMember(Integer projectId, Integer employeeId) {
        validateId(projectId, "project ID");
        validateId(employeeId, "employee ID");

        // DAO must verify both records exist and avoid duplicates.
        projectDAO.addMember(projectId, employeeId);

        auditSafely(
                "ADD_MEMBER",
                projectId,
                "Employee " + employeeId
                        + " added to project " + projectId);
    }

    // ---------------------------------------------------------
    // REMOVE PROJECT MEMBER
    // ---------------------------------------------------------

    public void removeMember(Integer projectId, Integer employeeId) {
        validateId(projectId, "project ID");
        validateId(employeeId, "employee ID");

        // DAO must remove only the association, not the employee.
        projectDAO.removeMember(projectId, employeeId);

        auditSafely(
                "REMOVE_MEMBER",
                projectId,
                "Employee " + employeeId
                        + " removed from project " + projectId);
    }

    // ---------------------------------------------------------
    // VALIDATION
    // ---------------------------------------------------------

    private void validateId(Integer id, String fieldName) {
        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                    "Invalid " + fieldName + ".");
        }
    }

    private void validateProject(Project project) {
        if (project == null) {
            throw new IllegalArgumentException(
                    "Project cannot be null.");
        }

        String code = project.getProjectCode();
        String name = project.getName();
        String description = project.getDescription();
        String status = project.getStatus();

        if (code == null || code.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Project code is required.");
        }

        if (code.trim().length() > 30) {
            throw new IllegalArgumentException(
                    "Project code must be 30 characters or fewer.");
        }

        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException(
                    "Project name is required.");
        }

        if (name.trim().length() > 150) {
            throw new IllegalArgumentException(
                    "Project name must be 150 characters or fewer.");
        }

        if (description != null && description.length() > 500) {
            throw new IllegalArgumentException(
                    "Description must be 500 characters or fewer.");
        }

        LocalDate startDate = project.getStartDate();
        LocalDate endDate = project.getEndDate();

        if (startDate != null
                && endDate != null
                && endDate.isBefore(startDate)) {
            throw new IllegalArgumentException(
                    "End date cannot be before start date.");
        }

        if (status == null || status.trim().isEmpty()) {
            project.setStatus("PLANNED");
        } else if (status.trim().length() > 30) {
            throw new IllegalArgumentException(
                    "Status must be 30 characters or fewer.");
        }

        // Store trimmed text values.
        project.setProjectCode(code.trim());
        project.setName(name.trim());

        if (description != null) {
            project.setDescription(description.trim());
        }

        if (project.getStatus() != null) {
            project.setStatus(project.getStatus().trim());
        }
    }

    // ---------------------------------------------------------
    // AUDIT LOGGING
    // ---------------------------------------------------------

    private void auditSafely(
            String action,
            Integer projectId,
            String details) {

        try {
            auditLogService.log(
                    null,
                    action,
                    "PROJECT",
                    projectId,
                    details);

        } catch (Exception e) {
            System.err.println(
                    "Warning: Project operation succeeded, "
                    + "but audit logging failed: " + action);

            e.printStackTrace();
        }
    }
}
