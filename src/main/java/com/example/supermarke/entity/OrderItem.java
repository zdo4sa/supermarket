package com.example.supermarke.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "order_items")
public class OrderItem {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	@Column(name = "order_item_id")
	private Integer orderItemId;

	@Column(name = "order_id", nullable = false)
	private Integer orderId;

	@Column(name = "product_id", nullable = false)
	private Integer productId;

	@Column(nullable = false)
	private int quantity;

	@Column(name = "price_at_purchase", nullable = false)
	private int priceAtPurchase;

	public Integer getOrderItemId() {
		return orderItemId;
	}

	public void setOrderItemId(Integer orderItemId) {
		this.orderItemId = orderItemId;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public void setOrderId(Integer orderId) {
		this.orderId = orderId;
	}

	public Integer getProductId() {
		return productId;
	}

	public void setProductId(Integer productId) {
		this.productId = productId;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	public int getPriceAtPurchase() {
		return priceAtPurchase;
	}

	public void setPriceAtPurchase(int priceAtPurchase) {
		this.priceAtPurchase = priceAtPurchase;
	}
}