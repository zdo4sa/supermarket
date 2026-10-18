package com.example.supermarke.util;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

public class PasswordUtil {
	private static final BCryptPasswordEncoder ENCODER = new BCryptPasswordEncoder();

	public static String hash(String rawPassword) {
		return ENCODER.encode(rawPassword);
	}

	public static boolean matches(String rawPassword, String storedPassword) {
		if (rawPassword == null || storedPassword == null) {
			return false;
		}
		return ENCODER.matches(rawPassword, storedPassword);
	}

	public static boolean isHashed(String storedPassword) {
		return storedPassword != null && storedPassword.matches("^\\$2[aby]\\$\\d{2}\\$.{53}$");
	}
}