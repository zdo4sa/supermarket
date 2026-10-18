package com.example.supermarke.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.example.supermarke.entity.Order;

@Repository
public interface OrderRepository extends JpaRepository<Order, Integer> {
	List<Order> findByUserIdOrderByOrderIdDesc(Integer userId);

	List<Order> findByStatusAndDeliveryDateLessThanEqualOrderByDeliveryDateAscOrderIdAsc(String status,
			LocalDate deliveryDateLimit);

	List<Order> findByDeliveryDateOrderByOrderIdAsc(LocalDate deliveryDate);

	List<Order> findByStatusOrderByCompletedAtAsc(String status);
}