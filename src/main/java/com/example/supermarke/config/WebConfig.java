package com.example.supermarke.config;

import java.io.File;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebConfig implements WebMvcConfigurer {

	public static final String UPLOAD_DIR = System.getProperty("user.dir") + File.separator + "uploads"
			+ File.separator;

	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		new File(UPLOAD_DIR).mkdirs();

		registry.addResourceHandler("/images/**")
				.addResourceLocations("file:" + UPLOAD_DIR);
	}

	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		registry.jsp("/WEB-INF/views/", ".jsp");
	}
}