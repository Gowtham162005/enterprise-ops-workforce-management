package com.enterpriseops.dao;

import java.util.List;

import com.enterpriseops.model.User;

public interface UserDAO {

    void save(User user);

    User findById(Integer id);

    User findByUsername(String username);

    List<User> findAll();

    void update(User user);

    void delete(Integer id);
}