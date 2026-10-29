package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.DepartmentDAO;
import com.enterpriseops.model.Department;
import com.enterpriseops.util.HibernateUtil;

public class DepartmentDAOImpl implements DepartmentDAO {

    @Override
    public void save(Department department) {
        Transaction tx = null;

        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            tx = session.beginTransaction();
            session.save(department);
            tx.commit();

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException(
                "Error saving department", e
            );
        }
    }

    @Override
    public Department findById(Integer id) {
        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                "SELECT DISTINCT d FROM Department d " +
                "LEFT JOIN FETCH d.managers " +
                "WHERE d.id = :id",
                Department.class
            )
            .setParameter("id", id)
            .uniqueResult();

        } catch (Exception e) {
            throw new RuntimeException(
                "Error finding department with id: " + id, e
            );
        }
    }

    @Override
    public List<Department> findAll() {
        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                "SELECT DISTINCT d FROM Department d " +
                "LEFT JOIN FETCH d.managers " +
                "ORDER BY d.id DESC",
                Department.class
            ).getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                "Error retrieving departments", e
            );
        }
    }

    @Override
    public void update(Department department) {
        Transaction tx = null;

        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            tx = session.beginTransaction();

            Department existing =
                session.get(Department.class, department.getId());

            if (existing == null) {
                throw new IllegalArgumentException(
                    "Department not found: " + department.getId()
                );
            }

            existing.setName(department.getName());
            existing.setDescription(department.getDescription());

            tx.commit();

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException(
                "Error updating department", e
            );
        }
    }

    @Override
    public void delete(Integer id) {
        Transaction tx = null;

        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            tx = session.beginTransaction();

            Department department =
                session.get(Department.class, id);

            if (department != null) {
                department.getManagers().clear();
                session.delete(department);
            }

            tx.commit();

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException(
                "Error deleting department", e
            );
        }
    }
}