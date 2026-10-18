package com.example.supermarke.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import com.example.supermarke.entity.Order;
import com.example.supermarke.entity.Product;
import com.example.supermarke.entity.User;
import com.example.supermarke.repository.OrderItemRepository;
import com.example.supermarke.repository.OrderRepository;
import com.example.supermarke.repository.ProductRepository;
import com.example.supermarke.repository.UserRepository;
import com.example.supermarke.util.PasswordUtil;

@WebServlet({ "/owner/management", "/owner/reports", "/owner/orders", "/owner/products" })
@MultipartConfig
public class OwnerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final UserRepository userRepository;
	private final ProductRepository productRepository;
	private final OrderRepository orderRepository;
	private final OrderItemRepository orderItemRepository;

	public OwnerServlet(UserRepository userRepository, ProductRepository productRepository,
			OrderRepository orderRepository, OrderItemRepository orderItemRepository) {
		this.userRepository = userRepository;
		this.productRepository = productRepository;
		this.orderRepository = orderRepository;
		this.orderItemRepository = orderItemRepository;
	}

	private String formatOrderSummary(Order order) {
		String statusText;
		if ("completed".equals(order.getStatus())) {
			statusText = order.getCompletedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"))
					+ "引渡・精算完了";
		} else if ("failed".equals(order.getStatus())) {
			statusText = order.getCompletedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm"))
					+ "引渡・代金未回収";
		} else {
			statusText = "配達待ち";
		}
		return "注文ID: " + order.getOrderId() + " / 金額: ¥" + order.getTotalAmount() + " (" + statusText + ")";
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String servletPath = request.getServletPath();

		if ("/owner/reports".equals(servletPath) || (servletPath != null && servletPath.endsWith("reports"))) {
			try {
				int totalSales = userRepository.calculateTotalSales();
				request.setAttribute("totalSales", totalSales);
			} catch (Exception e) {
				e.printStackTrace();
			}
			request.getRequestDispatcher("/WEB-INF/views/reports.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("management")) {
			try {
				List<User> allUsers = userRepository.findAll();

				List<User> staffList = allUsers.stream()
						.filter(u -> u.getRole() != null && "staff".equalsIgnoreCase(u.getRole().trim()))
						.toList();

				List<User> customerList = allUsers.stream()
						.filter(u -> u.getRole() != null &&
								("customer".equalsIgnoreCase(u.getRole().trim())
										|| "disabled".equalsIgnoreCase(u.getRole().trim())))
						.toList();

				if (staffList.isEmpty()) {
					staffList = new ArrayList<>();
					User mockStaff = new User();
					mockStaff.setFullName("加藤 配送員 (サンプル表示用)");
					mockStaff.setUsername("klo");
					staffList.add(mockStaff);
				}
				if (customerList.isEmpty()) {
					customerList = new ArrayList<>();
					User mockCustomer = new User();
					mockCustomer.setFullName("山田 太郎 (サンプル表示用)");
					mockCustomer.setDeliveryAddress("東京都葛飾区お花茶屋1-2-3");
					mockCustomer.setPhoneNumber("090-1234-5678");
					mockCustomer.setPenaltyBalance(1500);
					mockCustomer.setRole("disabled");
					customerList.add(mockCustomer);
				}

				request.setAttribute("staffList", staffList);
				request.setAttribute("customerList", customerList);

				String msg = (String) request.getSession().getAttribute("successMessage");
				if (msg != null) {
					request.setAttribute("successMessage", msg);
					request.getSession().removeAttribute("successMessage");
				}

			} catch (Exception e) {
				e.printStackTrace();
			}

			request.getRequestDispatcher("/WEB-INF/views/management.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("orders")) {
			List<Order> todayOrders = orderRepository.findByDeliveryDateOrderByOrderIdAsc(java.time.LocalDate.now());
			List<String> summaryList = new ArrayList<>();
			for (Order order : todayOrders) {
				summaryList.add(formatOrderSummary(order));
			}
			request.setAttribute("todayOrders", summaryList);
			request.getRequestDispatcher("/WEB-INF/views/orders.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("products")) {
			try {
				List<Product> databaseList = productRepository.findByActiveTrue();

				String msg = (String) request.getSession().getAttribute("successMessage");
				if (msg != null) {
					request.setAttribute("successMessage", msg);
					request.getSession().removeAttribute("successMessage");
				}

				request.setAttribute("productList", databaseList);

			} catch (Exception e) {
				e.printStackTrace();
			}

			request.getRequestDispatcher("/WEB-INF/views/products.jsp").forward(request, response);
			return;
		}

		response.sendRedirect(request.getContextPath() + "/login");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String servletPath = request.getServletPath();

		if (servletPath != null && servletPath.contains("management")) {
			String action = request.getParameter("action");

			if ("addStaff".equals(action)) {
				try {
					String fullName = request.getParameter("fullName");
					String username = request.getParameter("username");
					String password = request.getParameter("password");

					User newStaff = new User();
					newStaff.setFullName(fullName);
					newStaff.setUsername(username);
					newStaff.setPasswordHash(PasswordUtil.hash(password));
					newStaff.setRole("staff");
					newStaff.setPenaltyBalance(0);

					newStaff.setDeliveryAddress("自社配送センター・スタッフ");
					newStaff.setPhoneNumber("000-0000-0000");

					userRepository.save(newStaff);

					request.getSession().setAttribute("successMessage",
							"新しい配送スタッフ「" + fullName + "」様のアカウントを正常に発行しました！");
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if ("unlock".equals(action)) {
				String userIdStr = request.getParameter("userId");
				if (userIdStr != null) {
					try {
						Integer userId = Integer.parseInt(userIdStr);
						userRepository.findById(userId).ifPresent(user -> {
							if (!"disabled".equals(user.getRole())) {
								return;
							}
							user.setRole("customer");
							user.setPenaltyBalance(0);
							userRepository.save(user);

							List<Order> pastOrders = orderRepository.findByUserIdOrderByOrderIdDesc(userId);
							for (Order order : pastOrders) {
								if ("failed".equals(order.getStatus())) {
									order.setStatus("completed");
									orderRepository.save(order);
								}
							}

							request.getSession().setAttribute("successMessage",
									"ユーザーID: " + userId + " の凍結を解除し、未回収分の注文を支払い済みとして記録しました！");
						});
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			response.sendRedirect(request.getContextPath() + "/owner/management");
			return;
		}

		if (servletPath != null && servletPath.contains("products")) {
			String action = request.getParameter("action");

			if ("add".equals(action)) {
				try {
					String productName = request.getParameter("productName");
					String priceStr = request.getParameter("price");

					Part filePart = request.getPart("productImage");
					String fileName = "default.png";

					if (filePart != null && filePart.getSize() > 0) {
						fileName = filePart.getSubmittedFileName();

						String uploadPath = com.example.supermarke.config.WebConfig.UPLOAD_DIR;

						try (java.io.InputStream input = filePart.getInputStream();
								java.io.FileOutputStream output = new java.io.FileOutputStream(uploadPath + fileName)) {

							byte[] buffer = new byte[1024];

							int length;
							while ((length = input.read(buffer)) > 0) {
								output.write(buffer, 0, length);
							}
						}
					}

					Product newProduct = new Product();
					newProduct.setProductName(productName);
					newProduct.setPrice(Integer.parseInt(priceStr));
					newProduct.setImageUrl(fileName);
					newProduct.setPreservationDays(7);

					productRepository.save(newProduct);

					request.getSession().setAttribute("successMessage",
							"新商品「" + productName + "」をデータベースへ保存しました！");

				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if ("edit".equals(action)) {
				try {
					String productIdStr = request.getParameter("productId");
					if (productIdStr != null) {
						Integer productId = Integer.parseInt(productIdStr);
						Product product = productRepository.findById(productId).orElse(null);

						if (product != null) {
							String productName = request.getParameter("productName");
							String priceStr = request.getParameter("price");

							if (productName != null && !productName.isBlank()) {
								product.setProductName(productName);
							}
							if (priceStr != null && !priceStr.isBlank()) {
								product.setPrice(Integer.parseInt(priceStr));
							}

							Part filePart = request.getPart("productImage");
							if (filePart != null && filePart.getSize() > 0) {
								String fileName = filePart.getSubmittedFileName();
								String uploadPath = com.example.supermarke.config.WebConfig.UPLOAD_DIR;

								try (java.io.InputStream input = filePart.getInputStream();
										java.io.FileOutputStream output = new java.io.FileOutputStream(
												uploadPath + fileName)) {

									byte[] buffer = new byte[1024];

									int length;
									while ((length = input.read(buffer)) > 0) {
										output.write(buffer, 0, length);
									}
								}

								product.setImageUrl(fileName);
							}

							productRepository.save(product);
							request.getSession().setAttribute("successMessage", "商品ID: " + productId + " を更新しました！");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else if ("delete".equals(action)) {
				try {
					String productIdStr = request.getParameter("productId");
					if (productIdStr != null) {
						Integer productId = Integer.parseInt(productIdStr);

						productRepository.findById(productId).ifPresent(product -> {
							product.setActive(false);
							productRepository.save(product);
							request.getSession().setAttribute("successMessage",
									"商品ID: " + productId + " を販売終了にしました。商品一覧には表示されなくなります。");
						});
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			response.sendRedirect(request.getContextPath() + "/owner/products");
			return;
		}
	}
}