package com.enterpriseops.util;

import org.mindrot.jbcrypt.BCrypt;

public class PasswordGenerator {

    public static void main(String[] args) {

        String password = "manager123";

        String hash = BCrypt.hashpw(
                password,
                BCrypt.gensalt(10)
        );

        System.out.println("Password: " + password);
        System.out.println("BCrypt Hash: " + hash);
    }
}