package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.LeaveDAO;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.util.HibernateUtil;

public class LeaveDAOImpl implements LeaveDAO {

    @Override
    public void save(LeaveRequest leaveRequest) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.save(leaveRequest);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null
                    && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error saving leave request",
                    e
            );
        }
    }

    @Override
    public LeaveRequest findById(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT l " +
                    "FROM LeaveRequest l " +
                    "LEFT JOIN FETCH l.employee e " +
                    "LEFT JOIN FETCH e.manager " +
                    "LEFT JOIN FETCH l.reviewedBy " +
                    "WHERE l.id = :id";

            return session.createQuery(
                    hql,
                    LeaveRequest.class)
                    .setParameter("id", id)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding leave request: " + id,
                    e
            );
        }
    }

    @Override
    public List<LeaveRequest> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT l " +
                    "FROM LeaveRequest l " +
                    "LEFT JOIN FETCH l.employee e " +
                    "LEFT JOIN FETCH e.manager " +
                    "LEFT JOIN FETCH l.reviewedBy " +
                    "ORDER BY l.id DESC";

            return session.createQuery(
                    hql,
                    LeaveRequest.class)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving leave requests",
                    e
            );
        }
    }

    @Override
    public List<LeaveRequest> findByManager(
            Integer managerId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT l " +
                    "FROM LeaveRequest l " +
                    "LEFT JOIN FETCH l.employee e " +
                    "LEFT JOIN FETCH e.manager m " +
                    "LEFT JOIN FETCH l.reviewedBy " +
                    "WHERE m.id = :managerId " +
                    "ORDER BY l.id DESC";

            return session.createQuery(
                    hql,
                    LeaveRequest.class)
                    .setParameter(
                            "managerId",
                            managerId)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving leave requests for manager",
                    e
            );
        }
    }

    @Override
    public LeaveRequest findByIdAndManager(
            Integer leaveId,
            Integer managerId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT l " +
                    "FROM LeaveRequest l " +
                    "LEFT JOIN FETCH l.employee e " +
                    "LEFT JOIN FETCH e.manager m " +
                    "LEFT JOIN FETCH l.reviewedBy " +
                    "WHERE l.id = :leaveId " +
                    "AND m.id = :managerId";

            return session.createQuery(
                    hql,
                    LeaveRequest.class)
                    .setParameter(
                            "leaveId",
                            leaveId)
                    .setParameter(
                            "managerId",
                            managerId)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding manager leave request",
                    e
            );
        }
    }

    @Override
    public void update(
            LeaveRequest leaveRequest) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.merge(leaveRequest);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null
                    && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error updating leave request",
                    e
            );
        }
    }

    @Override
    public void delete(Integer id) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            LeaveRequest leaveRequest =
                    session.get(
                            LeaveRequest.class,
                            id);

            if (leaveRequest != null) {
                session.delete(leaveRequest);
            }

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null
                    && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error deleting leave request",
                    e
            );
        }
    }
    
    @Override
    public List<LeaveRequest> findByEmployee(Integer employeeId) {

        try (Session session =
                HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT l " +
                    "FROM LeaveRequest l " +
                    "JOIN FETCH l.employee e " +
                    "WHERE e.id = :employeeId " +
                    "ORDER BY l.id DESC";

            return session.createQuery(hql, LeaveRequest.class)
                    .setParameter("employeeId", employeeId)
                    .getResultList();

        } catch (Exception e) {
            throw new RuntimeException(
                    "Error retrieving employee leave requests", e);
        }
    }
}