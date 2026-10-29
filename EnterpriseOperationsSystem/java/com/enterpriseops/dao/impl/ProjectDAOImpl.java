
package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.ProjectDAO;
import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Project;
import com.enterpriseops.util.HibernateUtil;

public class ProjectDAOImpl implements ProjectDAO {

    @Override
    public void save(Project project) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Department department =
                    resolveDepartment(session, project.getDepartment());

            Employee manager =
                    resolveManager(session, project.getManager(), department);

            project.setDepartment(department);
            project.setManager(manager);

            session.save(project);
            transaction.commit();

        } catch (RuntimeException e) {
            rollback(transaction);
            throw e;
        }
    }

    @Override
    public Project findById(Integer id) {
        if (id == null) {
            return null;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            List<Project> results = session.createQuery(
                    "SELECT DISTINCT p "
                  + "FROM Project p "
                  + "LEFT JOIN FETCH p.manager "
                  + "LEFT JOIN FETCH p.department "
                  + "LEFT JOIN FETCH p.members "
                  + "WHERE p.id = :id",
                    Project.class)
                    .setParameter("id", id)
                    .getResultList();

            if (results.isEmpty()) {
                return null;
            }

            Project project = results.get(0);
            project.getMembers().size();

            return project;
        }
    }

    @Override
    public List<Project> findAll() {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT p "
                  + "FROM Project p "
                  + "LEFT JOIN FETCH p.manager "
                  + "LEFT JOIN FETCH p.department "
                  + "LEFT JOIN FETCH p.members "
                  + "ORDER BY p.id DESC",
                    Project.class)
                    .getResultList();
        }
    }

    @Override
    public List<Project> findByManager(Integer managerId) {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT p "
                  + "FROM Project p "
                  + "LEFT JOIN FETCH p.manager "
                  + "LEFT JOIN FETCH p.department "
                  + "LEFT JOIN FETCH p.members "
                  + "WHERE p.manager.id = :managerId "
                  + "ORDER BY p.id DESC",
                    Project.class)
                    .setParameter("managerId", managerId)
                    .getResultList();
        }
    }

    @Override
    public List<Project> findByEmployee(Integer employeeId) {

        if (employeeId == null || employeeId <= 0) {
            throw new IllegalArgumentException("Invalid employee ID");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT p " +
                    "FROM Project p " +
                    "LEFT JOIN FETCH p.manager " +
                    "LEFT JOIN FETCH p.department " +
                    "LEFT JOIN FETCH p.members " +
                    "WHERE p.id IN (" +
                    "    SELECT memberProject.id " +
                    "    FROM Project memberProject " +
                    "    JOIN memberProject.members projectMember " +
                    "    WHERE projectMember.id = :employeeId" +
                    ") " +
                    "OR EXISTS (" +
                    "    SELECT t.id " +
                    "    FROM Task t " +
                    "    WHERE t.project.id = p.id " +
                    "    AND t.assignedEmployee.id = :employeeId" +
                    ") " +
                    "ORDER BY p.id DESC";

            return session.createQuery(hql, Project.class)
                    .setParameter("employeeId", employeeId)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving projects for employee", e);
        }
    }

    @Override
    public void update(Project project) {
        if (project == null || project.getId() == null) {
            throw new IllegalArgumentException(
                    "A valid project is required for updating.");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Project existing =
                    session.get(Project.class, project.getId());

            if (existing == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            Department department =
                    resolveDepartment(session, project.getDepartment());

            Employee manager =
                    resolveManager(session, project.getManager(), department);

            existing.setProjectCode(project.getProjectCode());
            existing.setName(project.getName());
            existing.setDescription(project.getDescription());
            existing.setStartDate(project.getStartDate());
            existing.setEndDate(project.getEndDate());
            existing.setStatus(project.getStatus());
            existing.setDepartment(department);
            existing.setManager(manager);

            // Preserve the existing project-member associations.
            transaction.commit();

        } catch (RuntimeException e) {
            rollback(transaction);
            throw e;
        }
    }

    @Override
    public void delete(Integer id) {
        if (id == null) {
            throw new IllegalArgumentException(
                    "A valid project ID is required.");
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Project project = session.get(Project.class, id);

            if (project == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            project.getMembers().clear();
            session.flush();
            session.remove(project);

            transaction.commit();

        } catch (RuntimeException e) {
            rollback(transaction);
            throw e;
        }
    }

    @Override
    public void addMember(Integer projectId, Integer employeeId) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Project project = session.get(Project.class, projectId);
            Employee employee = session.get(Employee.class, employeeId);

            if (project == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            if (employee == null) {
                throw new IllegalArgumentException("Employee not found.");
            }

            project.getMembers().size();

            boolean alreadyMember = project.getMembers().stream()
                    .anyMatch(member ->
                            member.getId() != null
                            && member.getId().equals(employeeId));

            if (!alreadyMember) {
                project.addMember(employee);
            }

            transaction.commit();

        } catch (RuntimeException e) {
            rollback(transaction);
            throw e;
        }
    }

    @Override
    public void removeMember(Integer projectId, Integer employeeId) {
        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Project project = session.get(Project.class, projectId);
            Employee employee = session.get(Employee.class, employeeId);

            if (project == null) {
                throw new IllegalArgumentException("Project not found.");
            }

            if (employee == null) {
                throw new IllegalArgumentException("Employee not found.");
            }

            project.getMembers().removeIf(member ->
                    member.getId() != null
                    && member.getId().equals(employeeId));

            transaction.commit();

        } catch (RuntimeException e) {
            rollback(transaction);
            throw e;
        }
    }

    // ---------------------------------------------------------
    // HELPERS
    // ---------------------------------------------------------

    private Department resolveDepartment(
            Session session,
            Department submittedDepartment) {

        if (submittedDepartment == null
                || submittedDepartment.getId() == null) {
            throw new IllegalArgumentException(
                    "Please select a department.");
        }

        Department department = session.get(
                Department.class,
                submittedDepartment.getId());

        if (department == null) {
            throw new IllegalArgumentException(
                    "The selected department does not exist.");
        }

        return department;
    }

    private Employee resolveManager(
            Session session,
            Employee submittedManager,
            Department department) {

        if (submittedManager == null
                || submittedManager.getId() == null) {
            return null;
        }

        Employee manager = session.get(
                Employee.class,
                submittedManager.getId());

        if (manager == null) {
            throw new IllegalArgumentException(
                    "The selected project manager does not exist.");
        }

        Department employeeDepartment = manager.getDepartment();

        if (employeeDepartment == null
                || employeeDepartment.getId() == null
                || !employeeDepartment.getId().equals(department.getId())) {
            throw new IllegalArgumentException(
                    "The project manager must belong to the "
                            + "selected department.");
        }

        return manager;
    }

    private void rollback(Transaction transaction) {
        if (transaction != null && transaction.isActive()) {
            try {
                transaction.rollback();
            } catch (RuntimeException rollbackException) {
                rollbackException.printStackTrace();
            }
        }
    }
}
