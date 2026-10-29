package com.enterpriseops.dao.impl;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.UserDAO;
import com.enterpriseops.model.User;
import com.enterpriseops.util.HibernateUtil;

public class UserDAOImpl implements UserDAO {

    @Override
    public void save(User user) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.save(user);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Error saving user", e);
        }
    }

    @Override
    public User findById(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT u FROM User u " +
                    "LEFT JOIN FETCH u.role " +
                    "LEFT JOIN FETCH u.employee " +
                    "WHERE u.id = :id",
                    User.class)
                    .setParameter("id", id)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding user with id: " + id, e);
        }
    }

    @Override
    public User findByUsername(String username) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT u FROM User u " +
                    "LEFT JOIN FETCH u.role " +
                    "LEFT JOIN FETCH u.employee " +
                    "WHERE u.username = :username",
                    User.class)
                    .setParameter("username", username)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding user with username: "
                            + username, e);
        }
    }

    @Override
    public List<User> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT DISTINCT u FROM User u " +
                    "LEFT JOIN FETCH u.role " +
                    "LEFT JOIN FETCH u.employee " +
                    "ORDER BY u.id",
                    User.class)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding all users", e);
        }
    }

    @Override
    public void update(User user) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.update(user);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException("Error updating user", e);
        }
    }

    @Override
    public void delete(Integer id) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            User user = session.get(User.class, id);

            if (user != null) {
                session.delete(user);
            }

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error deleting user with id: " + id, e);
        }
    }
}