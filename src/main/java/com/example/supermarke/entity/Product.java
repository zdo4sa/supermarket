package com.example.supermarke.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;

@Entity
@Table(name = "products")
public class Product {

	@Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	private Integer id;

	@Column(name = "product_name")
	private String productName;

	@Column(name = "base_price", nullable = false)
	private Integer price;

	@Column(name = "image_url")
	private String imageUrl;

	@Column(name = "preservation_days", nullable = false)
	private Integer preservationDays;

	@Column(name = "is_active", columnDefinition = "boolean default true")
	private Boolean active = true;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public Integer getPrice() {
		return price;
	}

	public void setPrice(Integer price) {
		this.price = price;
	}

	public String getImageUrl() {
		return imageUrl;
	}

	public void setImageUrl(String imageUrl) {
		this.imageUrl = imageUrl;
	}

	public Integer getPreservationDays() {
		return preservationDays;
	}

	public void setPreservationDays(Integer preservationDays) {
		this.preservationDays = preservationDays;
	}

	public boolean isActive() {
		return active == null || active;
	}

	public void setActive(Boolean active) {
		this.active = active;
	}
}