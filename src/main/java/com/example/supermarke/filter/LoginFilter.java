package com.example.supermarke.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class LoginFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		HttpServletResponse httpResponse = (HttpServletResponse) response;
		HttpSession session = httpRequest.getSession(false);

		String requestURI = httpRequest.getRequestURI();
		String contextPath = httpRequest.getContextPath();

		// ログイン・新規登録・JSPフォルダ自体は誰でもアクセス許可
		if (requestURI.equals(contextPath + "/login") ||
				requestURI.equals(contextPath + "/signup") ||
				requestURI.contains("/WEB-INF/views/") ||
				requestURI.contains("/css/") ||
				requestURI.contains("/images/")) {
			chain.doFilter(request, response);
			return;
		}

		String userRole = (session != null) ? (String) session.getAttribute("role") : null;

		// まだログインの場合はログイン画面へ
		if (userRole == null) {
			httpResponse.sendRedirect(contextPath + "/login");
			return;
		}

		// 権限のないユーザーによる店長・スタッフ画面への直接アクセスを防止
		if (requestURI.startsWith(contextPath + "/owner/") && !"owner".equals(userRole)) {
			httpResponse.sendRedirect(contextPath + "/login");
			return;
		}
		if (requestURI.startsWith(contextPath + "/staff/") && !"staff".equals(userRole)) {
			httpResponse.sendRedirect(contextPath + "/login");
			return;
		}

		chain.doFilter(request, response);
	}

	@Override
	public void destroy() {
	}
}
