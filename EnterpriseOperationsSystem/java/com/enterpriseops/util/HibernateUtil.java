package com.enterpriseops.util;
import com.enterpriseops.model.Project;
import com.enterpriseops.model.Attendance;
import com.enterpriseops.model.Department;
import com.enterpriseops.model.Employee;
import com.enterpriseops.model.Role;
import com.enterpriseops.model.User;
import com.enterpriseops.model.LeaveRequest;
import com.enterpriseops.model.AuditLog;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import com.enterpriseops.model.Task;
public class HibernateUtil {

    private static final SessionFactory sessionFactory;

    static {
        try {
            sessionFactory = new Configuration()
                    .configure("hibernate.cfg.xml")

                    
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
                    "Hibernate SessionFactory creation failed."
            );

            ex.printStackTrace();

            throw new ExceptionInInitializerError(ex);
        }
    }

    private HibernateUtil() {
        // Prevent object creation
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        getSessionFactory().close();
    }
}