
package com.enterpriseops.util;

import com.enterpriseops.model.Project;
import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Role;
import com.enterpriseops.model.User;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.AuditLog;
import com.enterpriseops.model.Task;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

import java.util.Properties;

public class HibernateUtil {

    private static final SessionFactory sessionFactory;

    static {
        try {
            Properties properties = new Properties();

            // Read database connection settings from Render environment variables
            properties.setProperty(
                "hibernate.connection.driver_class",
                "com.mysql.cj.jdbc.Driver"
            );
            properties.setProperty(
                "hibernate.connection.url",
                getRequiredEnv("DB_URL")
            );
            properties.setProperty(
                "hibernate.connection.username",
                getRequiredEnv("DB_USERNAME")
            );
            properties.setProperty(
                "hibernate.connection.password",
                getRequiredEnv("DB_PASSWORD")
            );

            // Hibernate settings
            properties.setProperty(
                "hibernate.dialect",
                "org.hibernate.dialect.MariaDBDialect"
            );
            properties.setProperty("hibernate.show_sql", "true");
            properties.setProperty("hibernate.format_sql", "true");
            properties.setProperty("hibernate.hbm2ddl.auto", "validate");

            sessionFactory = new Configuration()
                .configure("hibernate.cfg.xml")
                .addProperties(properties)
                .addAnnotatedClass(Role.class)
                .addAnnotatedClass(User.class)
                .addAnnotatedClass(Department.class)
                .addAnnotatedClass(Employee.class)
                .addAnnotatedClass(Project.class)
                .addAnnotatedClass(Task.class)
                .addAnnotatedClass(LeaveRequest.class)
                .addAnnotatedClass(AuditLog.class)
                .addAnnotatedClass(Attendance.class)
                .buildSessionFactory();

            System.out.println(
                "Hibernate SessionFactory created successfully."
            );

        } catch (Throwable ex) {
            System.err.println(
                "========== HIBERNATE INITIALIZATION ERROR =========="
            );

            ex.printStackTrace(System.err);

            Throwable cause = ex.getCause();
            while (cause != null) {
                System.err.println("ROOT CAUSE: " + cause);
                cause = cause.getCause();
            }

            throw new ExceptionInInitializerError(ex);
        }
    }

    private static String getRequiredEnv(String name) {
        String value = System.getenv(name);

        if (value == null || value.trim().isEmpty()) {
            throw new IllegalStateException(
                "Required environment variable is missing: " + name
            );
        }

        return value;
    }

    private HibernateUtil() {
        // Prevent instantiation
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        if (sessionFactory != null && !sessionFactory.isClosed()) {
            sessionFactory.close();
        }
    }
}
