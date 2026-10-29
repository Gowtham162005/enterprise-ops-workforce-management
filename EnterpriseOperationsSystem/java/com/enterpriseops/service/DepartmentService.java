
package com.enterpriseops.service;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.Hibernate;

import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.util.HibernateUtil;

public class DepartmentService {

    public List<Department> getAllDepartments() {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT d FROM Department d " +
                    "LEFT JOIN FETCH d.managers " +
                    "ORDER BY d.name",
                    Department.class
            ).getResultList();
        }
    }

    public List<Department> getDepartmentsWithEmployees() {
        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT d FROM Department d " +
                    "LEFT JOIN FETCH d.employees " +
                    "ORDER BY d.name",
                    Department.class
            ).getResultList();
        }
    }

    public Department getDepartment(Integer id) {
        if (id == null) {
            return null;
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            List<Department> results = session.createQuery(
                    "SELECT DISTINCT d FROM Department d " +
                    "LEFT JOIN FETCH d.managers " +
                    "WHERE d.id = :id",
                    Department.class
            ).setParameter("id", id).getResultList();

            return results.isEmpty() ? null : results.get(0);
        }
    }

    public void addDepartment(Department department) {
        validateDepartment(department);

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();
            session.save(department);
            transaction.commit();

        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void updateDepartment(Department department) {
        validateDepartment(department);

        if (department.getId() == null) {
            throw new IllegalArgumentException(
                    "Department ID is required for updating."
            );
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Department existing =
                    session.get(Department.class, department.getId());

            if (existing == null) {
                throw new IllegalArgumentException(
                        "Department not found."
                );
            }

            existing.setName(department.getName());
            existing.setDescription(department.getDescription());

            session.update(existing);
            transaction.commit();

        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    public void deleteDepartment(Integer departmentId) {
        if (departmentId == null) {
            throw new IllegalArgumentException(
                    "Department ID is required."
            );
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Department department =
                    session.get(Department.class, departmentId);

            if (department == null) {
                throw new IllegalArgumentException(
                        "Department not found."
                );
            }

            Hibernate.initialize(department.getEmployees());
            Hibernate.initialize(department.getManagers());

            if (!department.getEmployees().isEmpty()) {
                throw new IllegalStateException(
                        "Cannot delete a department that still has employees."
                );
            }

            department.getManagers().clear();

            session.delete(department);
            transaction.commit();

        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    /**
     * Assigns an employee as an additional manager of their own department.
     * Existing managers are preserved.
     */
    public void assignManager(Integer departmentId, Integer employeeId) {
        if (departmentId == null || employeeId == null) {
            throw new IllegalArgumentException(
                    "Department ID and employee ID are required."
            );
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Department department =
                    session.get(Department.class, departmentId);

            if (department == null) {
                throw new IllegalArgumentException(
                        "Department not found."
                );
            }

            Employee employee =
                    session.get(Employee.class, employeeId);

            if (employee == null) {
                throw new IllegalArgumentException(
                        "Employee not found."
                );
            }

            if (employee.getDepartment() == null ||
                    !departmentId.equals(
                            employee.getDepartment().getId())) {

                throw new IllegalArgumentException(
                        "The employee must belong to the selected department."
                );
            }

            if (employee.getStatus() == null ||
                    !"ACTIVE".equalsIgnoreCase(employee.getStatus())) {

                throw new IllegalArgumentException(
                        "Only active employees can be assigned as managers."
                );
            }

            Hibernate.initialize(department.getManagers());

            // Set-based mapping prevents duplicate department-manager links.
            // Adding a manager does not remove existing managers.
            department.addManager(employee);

            session.update(department);
            transaction.commit();

        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    /**
     * Removes only the selected employee's manager assignment.
     * Other managers assigned to the department remain assigned.
     */
    public void removeManager(Integer departmentId, Integer employeeId) {
        if (departmentId == null || employeeId == null) {
            throw new IllegalArgumentException(
                    "Department ID and employee ID are required."
            );
        }

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Department department = session.createQuery(
                    "SELECT DISTINCT d FROM Department d " +
                    "LEFT JOIN FETCH d.managers " +
                    "WHERE d.id = :departmentId",
                    Department.class
            ).setParameter("departmentId", departmentId)
             .uniqueResult();

            if (department == null) {
                throw new IllegalArgumentException(
                        "Department not found."
                );
            }

            Employee employee =
                    session.get(Employee.class, employeeId);

            if (employee == null) {
                throw new IllegalArgumentException(
                        "Employee not found."
                );
            }

            boolean removed = department.getManagers().removeIf(
                    manager -> manager.getId().equals(employeeId)
            );

            if (!removed) {
                throw new IllegalArgumentException(
                        "This employee is not a manager of the selected department."
                );
            }

            session.update(department);
            transaction.commit();

        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }
            throw e;
        }
    }

    private void validateDepartment(Department department) {
        if (department == null) {
            throw new IllegalArgumentException(
                    "Department cannot be null."
            );
        }

        if (department.getName() == null ||
                department.getName().trim().isEmpty()) {

            throw new IllegalArgumentException(
                    "Department name is required."
            );
        }

        department.setName(department.getName().trim());
    }
}
