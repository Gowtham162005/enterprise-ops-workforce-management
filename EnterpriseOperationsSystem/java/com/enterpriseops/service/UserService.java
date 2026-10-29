package com.enterpriseops.service;

import java.security.SecureRandom;
import com.enterpriseops.model.Employee;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.enterpriseops.dao.UserDAO;
import com.enterpriseops.dao.impl.UserDAOImpl;
import com.enterpriseops.model.Role;
import com.enterpriseops.model.User;

public class UserService {

    private final UserDAO userDAO;
    private static final SecureRandom RANDOM = new SecureRandom();

    public UserService() {
        this.userDAO = new UserDAOImpl();
    }

    public User authenticate(String username, String password) {
        if (username == null || username.trim().isEmpty()
                || password == null || password.isEmpty()) {
            return null;
        }

        User user = userDAO.findByUsername(username.trim());
        if (user == null) {
            return null;
        }

        try {
            return BCrypt.checkpw(password, user.getPassword())
                    ? user : null;
        } catch (IllegalArgumentException e) {
            System.err.println("Invalid password hash for account.");
            return null;
        }
    }

    // Creates a user and hashes the supplied password.
    public void createUser(User user) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }
        if (user.getUsername() == null
                || user.getUsername().trim().isEmpty()) {
            throw new IllegalArgumentException("Username is required");
        }
        if (user.getPassword() == null || user.getPassword().isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (user.getRole() == null) {
            throw new IllegalArgumentException("Role is required");
        }

        user.setUsername(user.getUsername().trim());

        if (userDAO.findByUsername(user.getUsername()) != null) {
            throw new IllegalArgumentException("Username already exists");
        }

        user.setPassword(BCrypt.hashpw(user.getPassword(), BCrypt.gensalt(12)));
        userDAO.save(user);
    }

    // Generates a cryptographically random temporary password.
    public String generateTemporaryPassword() {
        final String chars =
                "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz"
                + "23456789!@#$%";
        StringBuilder result = new StringBuilder();

        for (int i = 0; i < 14; i++) {
            result.append(chars.charAt(RANDOM.nextInt(chars.length())));
        }
        return result.toString();
    }

    // Creates a user that must change their password at first login.
    // Returns the temporary password for one-time display to the admin.
    public String createEmployeeAccount(User user) {
        if (user == null || user.getEmployee() == null
                || user.getEmployee().getId() == null) {
            throw new IllegalArgumentException(
                    "A saved employee must be linked to the account");
        }

        if (user.getRole() == null
                || !"EMPLOYEE".equalsIgnoreCase(user.getRole().getName())) {
            throw new IllegalArgumentException(
                    "Employee account must have the EMPLOYEE role");
        }

        String temporaryPassword = generateTemporaryPassword();
        user.setPassword(temporaryPassword);
        user.setMustChangePassword(true);
        createUser(user);

        return temporaryPassword;
    }

    public User getUserByUsername(String username) {
        if (username == null || username.trim().isEmpty()) {
            return null;
        }
        return userDAO.findByUsername(username.trim());
    }

    public User getUserById(Integer userId) {
        if (userId == null || userId <= 0) {
            return null;
        }
        return userDAO.findById(userId);
    }

    public List<User> getAllUsers() {
        return userDAO.findAll();
    }

    public void updateUserRole(Integer userId, String roleName) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        if (roleName == null || roleName.trim().isEmpty()) {
            throw new IllegalArgumentException("Role is required");
        }

        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }

        String normalizedRole = roleName.trim().toUpperCase();

        if (!normalizedRole.equals("EMPLOYEE")
                && !normalizedRole.equals("MANAGER")
                && !normalizedRole.equals("ADMIN")) {
            throw new IllegalArgumentException("Invalid role");
        }

        Role role = new Role();
        role.setId(getRoleId(normalizedRole));
        role.setName(normalizedRole);
        user.setRole(role);

        userDAO.update(user);
    }

    private Integer getRoleId(String roleName) {
        if ("ADMIN".equals(roleName)) return 1;
        if ("MANAGER".equals(roleName)) return 2;
        if ("EMPLOYEE".equals(roleName)) return 3;
        throw new IllegalArgumentException("Invalid role");
    }

    public void resetPassword(Integer userId, String newPassword) {
        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        validatePassword(newPassword);

        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }

        user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
        user.setMustChangePassword(false);
        userDAO.update(user);
    }
    

/**
 * Resets an existing employee account or creates one if it does
 * not exist. Returns [username, temporaryPassword].
 */
public String[] createOrResetEmployeeAccount(Employee employee) {

    if (employee == null || employee.getId() == null) {
        throw new IllegalArgumentException(
                "A saved employee is required");
    }

    // Find an account already linked to this employee.
    User linkedUser = null;

    for (User user : userDAO.findAll()) {
        if (user.getEmployee() != null
                && user.getEmployee().getId() != null
                && user.getEmployee().getId().equals(employee.getId())) {
            linkedUser = user;
            break;
        }
    }

    // Existing account: reset its password.
    if (linkedUser != null) {
        String temporaryPassword =
                resetEmployeePassword(linkedUser.getId());

        return new String[] {
            linkedUser.getUsername(),
            temporaryPassword
        };
    }

    // No account exists: create one for this employee.
    User newUser = new User();
    newUser.setEmployee(employee);

    Role employeeRole = new Role();
    employeeRole.setId(getRoleId("EMPLOYEE"));
    employeeRole.setName("EMPLOYEE");
    newUser.setRole(employeeRole);

    String username = generateUniqueEmployeeUsername(employee);
    newUser.setUsername(username);

    // This generates a temporary password and requires a change
    // on the employee's first login.
    String temporaryPassword = createEmployeeAccount(newUser);

    return new String[] {
        newUser.getUsername(),
        temporaryPassword
    };
}

/**
 * Creates a unique username using the employee code.
 * Falls back to the email prefix, then the employee ID.
 */
private String generateUniqueEmployeeUsername(Employee employee) {

    String base = employee.getEmployeeCode();

    if (base == null || base.trim().isEmpty()) {
        String email = employee.getEmail();

        if (email != null && email.contains("@")) {
            base = email.substring(0, email.indexOf('@'));
        }
    }

    if (base == null || base.trim().isEmpty()) {
        base = "employee" + employee.getId();
    }

    base = base.trim().toLowerCase()
            .replaceAll("[^a-z0-9._-]", "");

    if (base.isEmpty()) {
        base = "employee" + employee.getId();
    }

    String username = base;
    int suffix = 1;

    while (userDAO.findByUsername(username) != null) {
        username = base + suffix;
        suffix++;
    }

    return username;
}

  
    
 // Admin resets an existing employee's password.
 // Returns the temporary password for one-time display.
 public String resetEmployeePassword(Integer userId) {

     if (userId == null || userId <= 0) {
         throw new IllegalArgumentException("Invalid user ID");
     }

     User user = userDAO.findById(userId);

     if (user == null) {
         throw new IllegalArgumentException("User not found");
     }

     if (user.getEmployee() == null
             || user.getEmployee().getId() == null) {
         throw new IllegalArgumentException(
                 "This account is not linked to an employee");
     }

     if (user.getRole() == null
             || !"EMPLOYEE".equalsIgnoreCase(user.getRole().getName())) {
         throw new IllegalArgumentException(
                 "This account does not have the EMPLOYEE role");
     }

     String temporaryPassword = generateTemporaryPassword();

     user.setPassword(
             BCrypt.hashpw(temporaryPassword, BCrypt.gensalt(12)));
     user.setMustChangePassword(true);

     userDAO.update(user);

     return temporaryPassword;
 }
 

    // Changes the logged-in user's password after verifying the old one.
    public void changeOwnPassword(
            Integer userId, String currentPassword, String newPassword) {

        if (userId == null || userId <= 0) {
            throw new IllegalArgumentException("Invalid user ID");
        }
        if (currentPassword == null || currentPassword.isEmpty()) {
            throw new IllegalArgumentException("Current password is required");
        }
        validatePassword(newPassword);

        User user = userDAO.findById(userId);
        if (user == null) {
            throw new IllegalArgumentException("User not found");
        }

        if (!BCrypt.checkpw(currentPassword, user.getPassword())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        if (BCrypt.checkpw(newPassword, user.getPassword())) {
            throw new IllegalArgumentException(
                    "Choose a password different from your current password");
        }

        user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
        user.setMustChangePassword(false);
        userDAO.update(user);
    }

    private void validatePassword(String password) {
        if (password == null || password.isEmpty()) {
            throw new IllegalArgumentException("Password is required");
        }
        if (password.length() < 8) {
            throw new IllegalArgumentException(
                    "Password must be at least 8 characters");
        }
    }
    

public void updateUsername(Integer userId, String newUsername) {

    if (userId == null || userId <= 0) {
        throw new IllegalArgumentException("Invalid user ID.");
    }

    if (newUsername == null || newUsername.trim().isEmpty()) {
        throw new IllegalArgumentException("Username is required.");
    }

    newUsername = newUsername.trim();

    if (!newUsername.matches("[A-Za-z0-9._-]{3,40}")) {
        throw new IllegalArgumentException(
            "Username must be 3-40 characters and contain only letters, "
            + "numbers, dots, underscores, or hyphens."
        );
    }

    User user = userDAO.findById(userId);

    if (user == null) {
        throw new IllegalArgumentException("User account not found.");
    }

    if (user.getRole() == null
            || !"MANAGER".equalsIgnoreCase(user.getRole().getName())) {
        throw new IllegalArgumentException(
            "This account is not a manager account."
        );
    }

    User existingUser = userDAO.findByUsername(newUsername);

    if (existingUser != null
            && !existingUser.getId().equals(userId)) {
        throw new IllegalArgumentException(
            "This username is already in use."
        );
    }

    user.setUsername(newUsername);
    userDAO.update(user);
}

/**
 * Finds the user account linked to an employee.
 * users.employee_id references employees.id.
 */
public User getUserByEmployeeId(Integer employeeId) {

    if (employeeId == null || employeeId <= 0) {
        throw new IllegalArgumentException("Invalid employee ID.");
    }

    for (User user : userDAO.findAll()) {
        if (user.getEmployee() != null
                && user.getEmployee().getId() != null
                && user.getEmployee().getId().equals(employeeId)) {
            return user;
        }
    }

    return null;
}

/**
 * Updates the username of the account linked to an employee.
 */
public void updateEmployeeUsername(
        Integer employeeId, String newUsername) {

    if (employeeId == null || employeeId <= 0) {
        throw new IllegalArgumentException("Invalid employee ID.");
    }

    if (newUsername == null || newUsername.trim().isEmpty()) {
        throw new IllegalArgumentException("Username is required.");
    }

    newUsername = newUsername.trim();

    if (!newUsername.matches("[A-Za-z0-9._-]{3,40}")) {
        throw new IllegalArgumentException(
                "Username must be 3-40 characters and contain only "
                + "letters, numbers, dots, underscores, or hyphens.");
    }

    User linkedUser = getUserByEmployeeId(employeeId);

    if (linkedUser == null) {
        throw new IllegalArgumentException(
                "No user account is linked to this employee.");
    }

    User existingUser = userDAO.findByUsername(newUsername);

    if (existingUser != null
            && !existingUser.getId().equals(linkedUser.getId())) {
        throw new IllegalArgumentException(
                "This username is already in use.");
    }

    linkedUser.setUsername(newUsername);
    userDAO.update(linkedUser);
}


public void changeOwnCredentials(
        Integer userId,
        String newUsername,
        String currentPassword,
        String newPassword) {

    if (userId == null || userId <= 0) {
        throw new IllegalArgumentException("Invalid user ID.");
    }

    if (newUsername == null || newUsername.trim().isEmpty()) {
        throw new IllegalArgumentException("Username is required.");
    }

    newUsername = newUsername.trim();

    if (!newUsername.matches("[A-Za-z0-9._-]{3,40}")) {
        throw new IllegalArgumentException(
                "Username must be 3-40 characters and contain only "
                + "letters, numbers, dots, underscores, or hyphens.");
    }

    if (currentPassword == null || currentPassword.isEmpty()) {
        throw new IllegalArgumentException("Current password is required.");
    }

    validatePassword(newPassword);

    User user = userDAO.findById(userId);

    if (user == null) {
        throw new IllegalArgumentException("User account not found.");
    }

    if (user.getPassword() == null
            || !BCrypt.checkpw(currentPassword, user.getPassword())) {
        throw new IllegalArgumentException(
                "Your current password is incorrect.");
    }

    if (BCrypt.checkpw(newPassword, user.getPassword())) {
        throw new IllegalArgumentException(
                "Choose a password different from your current password.");
    }

    User existingUser = userDAO.findByUsername(newUsername);

    if (existingUser != null
            && !existingUser.getId().equals(userId)) {
        throw new IllegalArgumentException(
                "That username is already in use. Please choose another.");
    }

    // Update the existing account; preserve its role and employee link.
    user.setUsername(newUsername);
    user.setPassword(BCrypt.hashpw(newPassword, BCrypt.gensalt(12)));
    user.setMustChangePassword(false);

    userDAO.update(user);
}


}
