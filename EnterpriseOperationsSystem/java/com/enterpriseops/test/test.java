package com.enterpriseops.test;

import org.mindrot.jbcrypt.BCrypt;

public class test {
    public static void main(String[] args) {

        String password = "thomas@employee";

        String hash = BCrypt.hashpw(
            password,
            BCrypt.gensalt(12)
        );

        System.out.println( hash);
    }
}