package com.example.supermarke.servlet;

import java.io.IOException;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.supermarke.entity.User;
import com.example.supermarke.repository.UserRepository;
import com.example.supermarke.util.PasswordUtil;

@Controller
public class LoginServlet {

	private final UserRepository userRepository;

	public LoginServlet(UserRepository userRepository) {
		this.userRepository = userRepository;
	}

	@GetMapping("/login")
	public String doGet(HttpServletRequest request) {
		return "login";
	}

	@GetMapping("/logout")
	public void logout(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session != null) {
			session.invalidate();
		}
		response.sendRedirect(request.getContextPath() + "/login");
	}

	@PostMapping("/login")
	public void doPost(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("userId") String userIdInput,
			@RequestParam("password") String passwordInput) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		try {
			Optional<User> userOpt = userRepository.findByUsername(userIdInput);

			if (userOpt.isPresent()) {
				User user = userOpt.get();

				if ("disabled".equals(user.getRole())) {
					response.sendRedirect(request.getContextPath() + "/login?banned=true");
					return;
				}

				String storedPassword = user.getPasswordHash();
				boolean passwordOk;
				if (PasswordUtil.isHashed(storedPassword)) {
					passwordOk = PasswordUtil.matches(passwordInput, storedPassword);
				} else {
					passwordOk = storedPassword != null && storedPassword.trim().equals(passwordInput.trim());
					if (passwordOk) {
						user.setPasswordHash(PasswordUtil.hash(passwordInput));
						userRepository.save(user);
					}
				}

				if (passwordOk) {
					HttpSession session = request.getSession();
					session.setAttribute("role", user.getRole());
					session.setAttribute("loginUser", user);

					String currentRole = user.getRole() != null ? user.getRole().toLowerCase() : "";

					if ("owner".equals(currentRole) || "admin".equals(currentRole) || "manager".equals(currentRole)) {
						response.sendRedirect(request.getContextPath() + "/owner/reports");
					} else if ("staff".equals(user.getRole())) {
						response.sendRedirect(request.getContextPath() + "/staff/orders");
					} else {
						response.sendRedirect(request.getContextPath() + "/shop/products");
					}
					return;
				}
			}

			request.setAttribute("errorMessage", "ユーザーIDまたはパスワードが正しくありません。");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			request.setAttribute("errorMessage", "ログイン処理中にシステムエラーが発生しました。");
			request.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(request, response);
		}
	}
}