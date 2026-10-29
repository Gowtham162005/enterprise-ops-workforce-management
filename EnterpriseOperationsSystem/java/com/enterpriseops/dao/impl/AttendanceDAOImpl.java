package com.enterpriseops.dao.impl;

import java.time.LocalDate;
import java.util.List;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.enterpriseops.dao.AttendanceDAO;
import com.enterpriseops.model.Attendance;
import com.enterpriseops.util.HibernateUtil;

public class AttendanceDAOImpl implements AttendanceDAO {

    @Override
    public void save(Attendance attendance) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.save(attendance);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error saving attendance", e);
        }
    }


    @Override
    public Attendance findById(Integer id) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee e " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE a.id = :id",
                    Attendance.class)
                    .setParameter("id", id)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error finding attendance: " + id, e);
        }
    }


    @Override
    public List<Attendance> findAll() {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee e " +
                    "LEFT JOIN FETCH e.manager " +
                    "ORDER BY a.attendanceDate DESC, a.id DESC",
                    Attendance.class)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving attendance records", e);
        }
    }


    @Override
    public List<Attendance> findByEmployee(Integer employeeId) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee e " +
                    "LEFT JOIN FETCH e.manager " +
                    "WHERE e.id = :employeeId " +
                    "ORDER BY a.attendanceDate DESC, a.id DESC",
                    Attendance.class)
                    .setParameter("employeeId", employeeId)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving employee attendance", e);
        }
    }


    @Override
    public List<Attendance> findByManager(Integer managerId) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid manager ID");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee e " +
                    "LEFT JOIN FETCH e.manager m " +
                    "WHERE m.id = :managerId " +
                    "ORDER BY a.attendanceDate DESC, " +
                    "e.firstName ASC, " +
                    "e.lastName ASC, " +
                    "a.id DESC";

            return session.createQuery(
                    hql,
                    Attendance.class)
                    .setParameter("managerId", managerId)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving team attendance", e);
        }
    }


    @Override
    public List<Attendance> findByManagerAndDate(
            Integer managerId,
            LocalDate attendanceDate) {

        if (managerId == null || managerId <= 0) {
            throw new IllegalArgumentException(
                    "Invalid manager ID");
        }

        if (attendanceDate == null) {
            throw new IllegalArgumentException(
                    "Attendance date is required");
        }

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            String hql =
                    "SELECT DISTINCT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee e " +
                    "LEFT JOIN FETCH e.manager m " +
                    "WHERE m.id = :managerId " +
                    "AND a.attendanceDate = :attendanceDate " +
                    "ORDER BY e.firstName ASC, " +
                    "e.lastName ASC, " +
                    "a.id DESC";

            return session.createQuery(
                    hql,
                    Attendance.class)
                    .setParameter("managerId", managerId)
                    .setParameter("attendanceDate", attendanceDate)
                    .getResultList();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error retrieving team attendance for date",
                    e);
        }
    }


    @Override
    public Attendance findByEmployeeAndDate(
            Integer employeeId,
            LocalDate attendanceDate) {

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            return session.createQuery(
                    "SELECT a " +
                    "FROM Attendance a " +
                    "LEFT JOIN FETCH a.employee " +
                    "WHERE a.employee.id = :employeeId " +
                    "AND a.attendanceDate = :attendanceDate",
                    Attendance.class)
                    .setParameter("employeeId", employeeId)
                    .setParameter("attendanceDate", attendanceDate)
                    .uniqueResult();

        } catch (Exception e) {

            throw new RuntimeException(
                    "Error checking existing attendance", e);
        }
    }


    @Override
    public void update(Attendance attendance) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            session.merge(attendance);

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error updating attendance", e);
        }
    }


    @Override
    public void delete(Integer id) {

        Transaction transaction = null;

        try (Session session =
                     HibernateUtil.getSessionFactory().openSession()) {

            transaction = session.beginTransaction();

            Attendance attendance =
                    session.get(Attendance.class, id);

            if (attendance != null) {
                session.delete(attendance);
            }

            transaction.commit();

        } catch (Exception e) {

            if (transaction != null && transaction.isActive()) {
                transaction.rollback();
            }

            throw new RuntimeException(
                    "Error deleting attendance", e);
        }
    }
}