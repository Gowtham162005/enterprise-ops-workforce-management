package com.enterpriseops.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordHashGenerator {

    public static void main(String[] args) {

        String password = "Admin@123";

        String hash =
                BCrypt.hashpw(password, BCrypt.gensalt(12));

        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hash);
    }
}