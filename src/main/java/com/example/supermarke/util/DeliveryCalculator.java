package com.example.supermarke.util;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

public class DeliveryCalculator {
	public static LocalDate calculateDeliveryDate(LocalDateTime orderDateTime) {
		LocalTime deadline = LocalTime.of(15, 0, 0);
		LocalDate deliveryDate;
		if (orderDateTime.toLocalTime().isBefore(deadline) || orderDateTime.toLocalTime().equals(deadline)) {
			deliveryDate = orderDateTime.toLocalDate();
		} else {
			deliveryDate = orderDateTime.toLocalDate().plusDays(1);
		}
		while (isNewYearsDay(deliveryDate)) {
			deliveryDate = deliveryDate.plusDays(1);
		}
		return deliveryDate;
	}

	private static boolean isNewYearsDay(LocalDate date) {
		return date.getMonthValue() == 1 && date.getDayOfMonth() == 1;
	}
}
