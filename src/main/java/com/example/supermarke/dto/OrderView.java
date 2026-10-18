package com.example.supermarke.dto;

public class OrderView {
	private final Integer orderId;
	private final String orderDate;
	private final String detail;
	private final String amount;
	private final String address;
	private final boolean delivered;
	private final boolean paid;
	private final Integer userId;
	private final int totalAmount;
	private final String status;

	public OrderView(Integer orderId, String orderDate, String detail, String amount, String address,
			boolean delivered, boolean paid, Integer userId, int totalAmount, String status) {
		this.orderId = orderId;
		this.orderDate = orderDate;
		this.detail = detail;
		this.amount = amount;
		this.address = address;
		this.delivered = delivered;
		this.paid = paid;
		this.userId = userId;
		this.totalAmount = totalAmount;
		this.status = status;
	}

	public Integer getOrderId() {
		return orderId;
	}

	public String getOrderDate() {
		return orderDate;
	}

	public String getDetail() {
		return detail;
	}

	public String getAmount() {
		return amount;
	}

	public String getAddress() {
		return address;
	}

	public boolean isDelivered() {
		return delivered;
	}

	public boolean isPaid() {
		return paid;
	}

	public Integer getUserId() {
		return userId;
	}

	public int getTotalAmount() {
		return totalAmount;
	}

	public String getStatus() {
		return status;
	}
}