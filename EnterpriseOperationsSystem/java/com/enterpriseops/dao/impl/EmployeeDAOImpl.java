package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.EmployeeDAO;
import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.util.HibernateUtil;

public class EmployeeDAOImpl implements EmployeeDAO {

    @Override
    public void save(Employee employee) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Transaction transaction = null;

            try {

                transaction = session.beginTransaction();

                attachDepartment(session, employee);
                attachManager(session, employee);

                session.save(employee);

                transaction.commit();

            } catch (Exception e) {

                if (transaction != null &&
                        transaction.isActive()) {

                    transaction.rollback();
                }

                throw new RuntimeException(
                        "Error saving employee", e);
            }
        }
    }


    @Override
    public Employee findById(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE e.id = :id",
                    Employee.class
            )
            .setParameter("id", id)
            .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding employee: " + id, e);
        }
    }


    @Override
    public List<Employee> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "ORDER BY e.id DESC",
                    Employee.class
            )
            .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving employees", e);
        }
    }


    @Override
    public void update(Employee employee) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Transaction transaction = null;

            try {

                transaction = session.beginTransaction();

                attachDepartment(session, employee);
                attachManager(session, employee);

                session.update(employee);

                transaction.commit();

            } catch (Exception e) {

                if (transaction != null &&
                        transaction.isActive()) {

                    transaction.rollback();
                }

                throw new RuntimeException(
                        "Error updating employee", e);
            }
        }
    }


    @Override
    public void deactivate(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Transaction transaction = null;

            try {

                transaction = session.beginTransaction();

                Employee employee =
                        session.get(Employee.class, id);

                if (employee == null) {

                    throw new RuntimeException(
                            "Employee not found: " + id);
                }

                employee.setStatus("INACTIVE");

                session.update(employee);

                transaction.commit();

            } catch (Exception e) {

                if (transaction != null &&
                        transaction.isActive()) {

                    transaction.rollback();
                }

                throw new RuntimeException(
                        "Error deactivating employee: " + id, e);
            }
        }
    }


    @Override
    public List<Employee> search(String keyword) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String searchTerm =
                    "%" + keyword.toLowerCase().trim() + "%";

            return session.createQuery(
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE LOWER(e.employeeCode) LIKE :keyword " +
                    "OR LOWER(e.firstName) LIKE :keyword " +
                    "OR LOWER(e.lastName) LIKE :keyword " +
                    "OR LOWER(e.email) LIKE :keyword " +
                    "ORDER BY e.id DESC",
                    Employee.class
            )
            .setParameter("keyword", searchTerm)
            .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error searching employees", e);
        }
    }
    
 // =========================================================
 // FIND ALL MANAGERS
 // =========================================================

 @Override
 public List<Employee> findManagers() {

     try (Session session =
                  HibernateUtil.getSessionFactory().openSession()) {

         return session.createQuery(
                 "SELECT DISTINCT e " +
                 "FROM Employee e " +
                 "JOIN User u ON u.employee.id = e.id " +
                 "JOIN u.role r " +
                 "WHERE UPPER(r.name) = 'MANAGER' " +
                 "AND UPPER(e.status) = 'ACTIVE' " +
                 "ORDER BY e.firstName ASC",
                 Employee.class
         )
         .getResultList();

     } catch (Exception e) {

         throw new RuntimeException(
                 "Error retrieving managers", e);
     }
 }


    @Override
    public List<Employee> findByDepartment(
            Integer departmentId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE e.department.id = :departmentId " +
                    "ORDER BY e.id DESC",
                    Employee.class
            )
            .setParameter(
                    "departmentId",
                    departmentId)
            .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding employees by department",
                    e);
        }
    }


    @Override
    public List<Employee> findByStatus(
            String status) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE UPPER(e.status) = :status " +
                    "ORDER BY e.id DESC",
                    Employee.class
            )
            .setParameter(
                    "status",
                    status.toUpperCase())
            .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding employees by status",
                    e);
        }
    }


    @Override
    public long countEmployees() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE UPPER(e.status) = 'ACTIVE'",
                    Long.class
            )
            .uniqueResult();

            return count != null ? count : 0;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error counting employees", e);
        }
    }


    @Override
    public boolean existsByEmployeeCode(
            String employeeCode) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE LOWER(e.employeeCode) = :code",
                    Long.class
            )
            .setParameter(
                    "code",
                    employeeCode.toLowerCase().trim())
            .uniqueResult();

            return count != null && count > 0;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error checking employee code", e);
        }
    }


    @Override
    public boolean existsByEmail(
            String email) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE LOWER(e.email) = :email",
                    Long.class
            )
            .setParameter(
                    "email",
                    email.toLowerCase().trim())
            .uniqueResult();

            return count != null && count > 0;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error checking employee email", e);
        }
    }


    @Override
    public boolean existsByEmployeeCodeExceptId(
            String employeeCode,
            Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE LOWER(e.employeeCode) = :code " +
                    "AND e.id <> :id",
                    Long.class
            )
            .setParameter(
                    "code",
                    employeeCode.toLowerCase().trim())
            .setParameter("id", id)
            .uniqueResult();

            return count != null && count > 0;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error checking employee code", e);
        }
    }


    @Override
    public boolean existsByEmailExceptId(
            String email,
            Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            Long count = session.createQuery(
                    "SELECT COUNT(e) " +
                    "FROM Employee e " +
                    "WHERE LOWER(e.email) = :email " +
                    "AND e.id <> :id",
                    Long.class
            )
            .setParameter(
                    "email",
                    email.toLowerCase().trim())
            .setParameter("id", id)
            .uniqueResult();

            return count != null && count > 0;

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error checking employee email", e);
        }
    }


    

    // =========================================================
    // FIND MANAGERS BY DEPARTMENT
    // =========================================================

    @Override
    public List<Employee> findManagersByDepartment(
            Integer departmentId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT e " +
                    "FROM Employee e " +
                    "JOIN User u ON u.employee.id = e.id " +
                    "JOIN u.role r " +
                    "WHERE UPPER(r.name) = 'MANAGER' " +
                    "AND UPPER(e.status) = 'ACTIVE' " +
                    "AND e.department.id = :departmentId " +
                    "ORDER BY e.firstName ASC",
                    Employee.class
            )
            .setParameter(
                    "departmentId",
                    departmentId)
            .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving managers by department",
                    e);
        }
    }


    // =========================================================
    // FIND EMPLOYEES BY MANAGER
    // =========================================================

    @Override
    public List<Employee> findByManager(Integer managerId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT e " +
                    "FROM Employee e " +
                    "LEFT JOIN FETCH e.department " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE e.manager.id = :managerId " +
                    "AND e.id <> :managerId " +
                    "ORDER BY e.id DESC";

            return session.createQuery(hql, Employee.class)
                    .setParameter("managerId", managerId)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving employees by manager", e);
        }
    }

    // =========================================================
    // ATTACH DEPARTMENT
    // =========================================================

    private void attachDepartment(
            Session session,
            Employee employee) {

        if (employee.getDepartment() == null) {
            return;
        }

        Integer departmentId =
                employee.getDepartment().getId();

        if (departmentId == null) {

            employee.setDepartment(null);
            return;
        }

        Department department =
                session.get(
                        Department.class,
                        departmentId);

        if (department == null) {

            throw new RuntimeException(
                    "Department not found: "
                    + departmentId);
        }

        employee.setDepartment(department);
    }


    // =========================================================
    // ATTACH MANAGER
    // =========================================================

    private void attachManager(
            Session session,
            Employee employee) {

        if (employee.getManager() == null) {
            return;
        }

        Integer managerId =
                employee.getManager().getId();

        if (managerId == null) {

            employee.setManager(null);
            return;
        }

        if (employee.getId() != null &&
                employee.getId().equals(managerId)) {

            throw new RuntimeException(
                    "An employee cannot be their own manager.");
        }

        Employee manager =
                session.get(
                        Employee.class,
                        managerId);

        if (manager == null) {

            throw new RuntimeException(
                    "Manager not found: "
                    + managerId);
        }

        employee.setManager(manager);
    }
}