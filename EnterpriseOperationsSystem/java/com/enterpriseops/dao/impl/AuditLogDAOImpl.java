package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.AuditLogDAO;
import com.enterpriseops.model.AuditLog;
import com.enterpriseops.util.HibernateUtil;

public class AuditLogDAOImpl implements AuditLogDAO {

    @Override
    public void save(AuditLog auditLog) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.save(auditLog);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error saving audit log", e);
        }
    }

    @Override
    public AuditLog findById(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a FROM AuditLog a " +
                    "LEFT JOIN FETCH a.user " +
                    "WHERE a.id = :id",
                    AuditLog.class)
                    .setParameter("id", id)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding audit log: " + id, e);
        }
    }

    @Override
    public List<AuditLog> findRecent(int limit) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a FROM AuditLog a " +
                    "LEFT JOIN FETCH a.user " +
                    "ORDER BY a.createdAt DESC",
                    AuditLog.class)
                    .setMaxResults(limit)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving recent audit logs", e);
        }
    }

    @Override
    public List<AuditLog> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a FROM AuditLog a " +
                    "LEFT JOIN FETCH a.user " +
                    "ORDER BY a.createdAt DESC",
                    AuditLog.class)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving audit logs", e);
        }
    }
}