package com.enterpriseops.test;

import org.hibernate.Session;
import org.hibernate.SessionFactory;

import com.enterpriseops.util.HibernateUtil;

public class HibernateConnectionTest {

    public static void main(String[] args) {

        SessionFactory sessionFactory = null;
        Session session = null;

        try {

            // Get Hibernate SessionFactory
            sessionFactory = HibernateUtil.getSessionFactory();

            // Open a Hibernate session
            session = sessionFactory.openSession();

            // Test database connection
            session.createNativeQuery("SELECT 1").getSingleResult();

            System.out.println("--------------------------------------");
            System.out.println("Hibernate connection successful!");
            System.out.println("MySQL database connection successful!");
            System.out.println("--------------------------------------");

        } catch (Exception e) {

            System.out.println("--------------------------------------");
            System.out.println("Hibernate connection FAILED!");
            System.out.println("--------------------------------------");

            e.printStackTrace();

        } finally {

            if (session != null) {
                session.close();
            }

            if (sessionFactory != null) {
                HibernateUtil.shutdown();
            }
        }
    }
}