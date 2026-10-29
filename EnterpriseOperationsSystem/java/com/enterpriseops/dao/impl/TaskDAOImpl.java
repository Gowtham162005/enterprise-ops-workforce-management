package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.TaskDAO;
import com.enterpriseops.model.Task;
import com.enterpriseops.util.HibernateUtil;

public class TaskDAOImpl implements TaskDAO {

    // =========================================================
    // FIND TASKS BY MANAGER
    // Retrieves tasks belonging to projects managed by an employee.
    // =========================================================

    @Override
    public List<Task> findByManager(Integer managerId) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException("Invalid manager ID");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT t " +
                    "FROM Task t " +
                    "JOIN FETCH t.project p " +
                    "LEFT JOIN FETCH t.assignedEmployee " +
                    "WHERE p.manager.id = :managerId " +
                    "ORDER BY t.id DESC";

            return session.createQuery(hql, Task.class)
                    .setParameter("managerId", managerId)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving tasks for manager", e);
        }
    }


    // =========================================================
    // FIND TASKS ASSIGNED TO AN EMPLOYEE
    // Retrieves only tasks assigned to the specified employee.
    // =========================================================

    @Override
    public List<Task> findByAssignedEmployee(Integer employeeId) {

        if (employeeId == null || employeeId <= 0) {
            throw new IllegalArgumentException("Invalid employee ID");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT t " +
                    "FROM Task t " +
                    "LEFT JOIN FETCH t.project " +
                    "WHERE t.assignedEmployee.id = :employeeId " +
                    "ORDER BY t.dueDate ASC, t.id DESC";

            return session.createQuery(hql, Task.class)
                    .setParameter("employeeId", employeeId)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving tasks for employee", e);
        }
    }


    // =========================================================
    // CHECK PROJECT OWNERSHIP
    // Returns true if the specified project belongs to the manager.
    // =========================================================

    @Override
    public boolean isProjectManagedBy(
            Integer projectId,
            Integer managerId) {

        if (projectId == null || projectId <= 0
                || managerId == null || managerId <= 0) {
            return false;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT COUNT(p.id) " +
                    "FROM Project p " +
                    "WHERE p.id = :projectId " +
                    "AND p.manager.id = :managerId";

            Long count = session.createQuery(hql, Long.class)
                    .setParameter("projectId", projectId)
                    .setParameter("managerId", managerId)
                    .uniqueResult();

            return count != null && count > 0;

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error checking project ownership", e);
        }
    }


    // =========================================================
    // FIND ALL TASKS
    // Used by existing administrative functionality if required.
    // =========================================================

    @Override
    public List<Task> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT t " +
                    "FROM Task t " +
                    "LEFT JOIN FETCH t.project " +
                    "LEFT JOIN FETCH t.assignedEmployee " +
                    "ORDER BY t.id DESC";

            return session.createQuery(hql, Task.class)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving all tasks", e);
        }
    }


    // =========================================================
    // FIND TASK BY ID
    // =========================================================

    @Override
    public Task findById(Integer id) {

        if (id == null || id <= 0) {
            return null;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT t " +
                    "FROM Task t " +
                    "LEFT JOIN FETCH t.project " +
                    "LEFT JOIN FETCH t.assignedEmployee " +
                    "WHERE t.id = :id";

            return session.createQuery(hql, Task.class)
                    .setParameter("id", id)
                    .uniqueResult();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving task by ID", e);
        }
    }


    // =========================================================
    // SAVE TASK
    // =========================================================

    @Override
    public void save(Task task) {

        if (task == null) {
            throw new IllegalArgumentException("Task cannot be null");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.save(task);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Error saving task", e);
        }
    }


    // =========================================================
    // UPDATE TASK
    // =========================================================

    @Override
    public void update(Task task) {

        if (task == null || task.getId() == null) {
            throw new IllegalArgumentException(
                    "Task and task ID are required");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.update(task);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Error updating task", e);
        }
    }


    // =========================================================
    // DELETE TASK
    // =========================================================

    @Override
    public void delete(Integer id) {

        if (id == null || id <= 0) {
            throw new IllegalArgumentException("Invalid task ID");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Task task = session.get(Task.class, id);

            if (task != null) {
                session.delete(task);
            }

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Error deleting task", e);
        }
    }
}