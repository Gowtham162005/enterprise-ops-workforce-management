
package com.enterpriseops.service;

import java.util.List;

import com.enterpriseops.dao.TaskDAO;
import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.dao.impl.TaskDAOImpl;
import com.enterpriseops.dao.impl.EmployeeDAOImpl;
import com.enterpriseops.model.Task;
import com.enterpriseops.model.Employee;

public class TaskService {

    private final TaskDAO taskDAO;
    private final EmployeeDAO employeeDAO;

    public TaskService() {
        this.taskDAO = new TaskDAOImpl();
        this.employeeDAO = new EmployeeDAOImpl();
    }

    // =========================================================
    // GET TASKS BY MANAGER
    // =========================================================

    public List<Task> getTasksByManager(Integer managerId) {

        validateManagerId(managerId);

        return taskDAO.findByManager(managerId);
    }

    // =========================================================
    // GET ALL TASKS
    // Keep for existing callers
    // =========================================================

    public List<Task> getAllTasks() {

        return taskDAO.findAll();
    }

    // =========================================================
    // GET TASK BY ID
    // =========================================================

    public Task getTask(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                "Invalid task ID"
            );
        }

        return taskDAO.findById(id);
    }

    // =========================================================
    // ADD TASK
    // Existing general-purpose method
    // =========================================================

    public void addTask(Task task) {

        validateTaskFields(task);

        taskDAO.save(task);
    }

    // =========================================================
    // ADD TASK FOR MANAGER
    // Checks project ownership and employee department
    // =========================================================

    public void addTaskForManager(
            Task task,
            Integer managerId) {

        validateManagerId(managerId);
        validateManagerAssignment(task, managerId);

        // Reuse existing task validation and save logic.
        addTask(task);
    }

    // =========================================================
    // UPDATE TASK
    // Existing general-purpose method
    // =========================================================

    public void updateTask(Task task) {

        if (task == null) {
            throw new IllegalArgumentException(
                "Task cannot be null"
            );
        }

        if (task.getId() == null || task.getId() <= 0) {
            throw new IllegalArgumentException(
                "Invalid task ID"
            );
        }

        validateTaskFields(task);

        taskDAO.update(task);
    }

    // =========================================================
    // UPDATE TASK FOR MANAGER
    // Checks existing task ownership and new assignment
    // =========================================================

    public void updateTaskForManager(
            Task task,
            Integer managerId) {

        validateManagerId(managerId);

        if (task == null ||
            task.getId() == null ||
            task.getId() <= 0) {

            throw new IllegalArgumentException(
                "Invalid task"
            );
        }

        Task existingTask = taskDAO.findById(task.getId());

        if (existingTask == null ||
            existingTask.getProject() == null ||
            !taskDAO.isProjectManagedBy(
                existingTask.getProject().getId(),
                managerId)) {

            throw new SecurityException(
                "You cannot update a task outside your projects"
            );
        }

        validateManagerAssignment(task, managerId);

        updateTask(task);
    }

    // =========================================================
    // GET TASKS ASSIGNED TO AN EMPLOYEE
    // =========================================================

    public List<Task> getTasksByEmployee(Integer employeeId) {

        if (employeeId == null || employeeId <= 0) {
            throw new IllegalArgumentException(
                "Invalid employee ID"
            );
        }

        return taskDAO.findByAssignedEmployee(employeeId);
    }

    // =========================================================
    // CHECK PROJECT OWNERSHIP
    // =========================================================

    public boolean isProjectManagedBy(
            Integer projectId,
            Integer managerId) {

        if (projectId == null || projectId <= 0 ||
            managerId == null || managerId <= 0) {

            return false;
        }

        return taskDAO.isProjectManagedBy(
            projectId,
            managerId
        );
    }

    // =========================================================
    // DELETE TASK
    // Existing general-purpose method
    // =========================================================

    public void deleteTask(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException(
                "Invalid task ID"
            );
        }

        taskDAO.delete(id);
    }

    // =========================================================
    // VALIDATE TASK FIELDS
    // =========================================================

    private void validateTaskFields(Task task) {

        if (task == null) {
            throw new IllegalArgumentException(
                "Task cannot be null"
            );
        }

        if (task.getTaskCode() == null ||
            task.getTaskCode().trim().isEmpty()) {

            throw new IllegalArgumentException(
                "Task code is required"
            );
        }

        if (task.getTitle() == null ||
            task.getTitle().trim().isEmpty()) {

            throw new IllegalArgumentException(
                "Task title is required"
            );
        }

        if (task.getProject() == null ||
            task.getProject().getId() == null ||
            task.getProject().getId() <= 0) {

            throw new IllegalArgumentException(
                "A valid project is required"
            );
        }

        if (task.getProgress() == null) {
            task.setProgress(0);
        }

        if (task.getProgress() < 0 ||
            task.getProgress() > 100) {

            throw new IllegalArgumentException(
                "Progress must be between 0 and 100"
            );
        }
    }

    // =========================================================
    // VALIDATE MANAGER PROJECT AND EMPLOYEE ASSIGNMENT
    // =========================================================

    private void validateManagerAssignment(
            Task task,
            Integer managerId) {

        if (task == null) {
            throw new IllegalArgumentException(
                "Task cannot be null"
            );
        }

        validateTaskFields(task);

        Integer projectId = task.getProject().getId();

        // The project must belong to the logged-in manager.
        if (!taskDAO.isProjectManagedBy(
                projectId,
                managerId)) {

            throw new SecurityException(
                "You can only manage tasks for your own projects"
            );
        }

        // Load the manager to check their department.
        Employee manager = employeeDAO.findById(managerId);

        if (manager == null ||
            manager.getDepartment() == null ||
            manager.getDepartment().getId() == null) {

            throw new IllegalArgumentException(
                "Manager or manager department was not found"
            );
        }

        // A task must have an assigned employee.
        if (task.getAssignedEmployee() == null ||
            task.getAssignedEmployee().getId() == null ||
            task.getAssignedEmployee().getId() <= 0) {

            throw new IllegalArgumentException(
                "An employee must be assigned to the task"
            );
        }

        Employee employee = employeeDAO.findById(
            task.getAssignedEmployee().getId()
        );

        if (employee == null ||
            employee.getDepartment() == null ||
            employee.getDepartment().getId() == null) {

            throw new IllegalArgumentException(
                "Assigned employee or employee department was not found"
            );
        }

        // Manager and assigned employee must share a department.
        if (!manager.getDepartment().getId().equals(
                employee.getDepartment().getId())) {

            throw new SecurityException(
                "You can only assign tasks to employees in your department"
            );
        }
    }

    // =========================================================
    // VALIDATE MANAGER ID
    // =========================================================

    private void validateManagerId(Integer managerId) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException(
                "Invalid manager ID"
            );
        }
    }
}
