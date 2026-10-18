package com.example.supermarke.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import com.example.supermarke.entity.User;

@Repository
public interface UserRepository extends JpaRepository<User, Integer> {
	Optional<User> findByUsername(String username);

	Optional<User> findByPhoneNumber(String phoneNumber);

	@Query(value = "SELECT COALESCE(SUM(total_amount), 0) FROM orders WHERE status = 'completed'", nativeQuery = true)
	int calculateTotalSales();
}
