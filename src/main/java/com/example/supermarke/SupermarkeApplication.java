package com.example.supermarke;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.ServletComponentScan;

@SpringBootApplication
@ServletComponentScan
public class SupermarkeApplication {
	public static void main(String[] args) {
		SpringApplication.run(SupermarkeApplication.class, args);
	}
}