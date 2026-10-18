package com.example.supermarke.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.example.supermarke.dto.OrderView;
import com.example.supermarke.entity.Order;
import com.example.supermarke.entity.OrderItem;
import com.example.supermarke.entity.Product;
import com.example.supermarke.entity.User;
import com.example.supermarke.repository.OrderItemRepository;
import com.example.supermarke.repository.OrderRepository;
import com.example.supermarke.repository.ProductRepository;
import com.example.supermarke.repository.UserRepository;
import com.example.supermarke.util.PasswordUtil;

@WebServlet({ "/signup", "/customer/products", "/shop/products", "/customer/cart", "/shop/cart", "/customer/checkout",
		"/customer/order_history" })
public class CustomerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final UserRepository userRepository;
	private final ProductRepository productRepository;
	private final OrderRepository orderRepository;
	private final OrderItemRepository orderItemRepository;

	public CustomerServlet(UserRepository userRepository, ProductRepository productRepository,
			OrderRepository orderRepository, OrderItemRepository orderItemRepository) {
		this.userRepository = userRepository;
		this.productRepository = productRepository;
		this.orderRepository = orderRepository;
		this.orderItemRepository = orderItemRepository;
	}

	private OrderView buildOrderView(Order order, String address) {
		List<OrderItem> items = orderItemRepository.findByOrderId(order.getOrderId());
		StringBuilder detail = new StringBuilder();
		for (OrderItem item : items) {
			productRepository.findById(item.getProductId()).ifPresent(p -> {
				detail.append(p.getProductName());
				if (item.getQuantity() > 1) {
					detail.append(" x").append(item.getQuantity());
				}
				detail.append(" ");
			});
		}

		boolean delivered = !"reserved".equals(order.getStatus());
		boolean paid = "completed".equals(order.getStatus());

		return new OrderView(order.getOrderId(), order.getDeliveryDate().toString(), detail.toString(),
				"¥ " + order.getTotalAmount() + "-", address, delivered, paid, order.getUserId(),
				order.getTotalAmount(), order.getStatus());
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String servletPath = request.getServletPath();

		if ("/signup".equals(servletPath)) {
			request.getRequestDispatcher("/WEB-INF/views/signup.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && (servletPath.contains("products")
				|| (servletPath.contains("shop") && !servletPath.contains("cart")))) {
			try {
				List<Product> databaseList = productRepository.findByActiveTrue();
				request.setAttribute("productList", databaseList);

				HttpSession session = request.getSession();
				List<Product> cartList = (List<Product>) session.getAttribute("myCartList");

				int calculatedTotal = 0;
				int calculatedCount = 0;

				if (cartList != null) {
					for (Product p : cartList) {
						if (p != null) {
							calculatedTotal += p.getPrice();
							calculatedCount++;
						}
					}
				}

				request.setAttribute("itemCount", calculatedCount);
				request.setAttribute("totalAmount", calculatedTotal);

			} catch (Exception e) {
				e.printStackTrace();
			}

			request.getRequestDispatcher("/WEB-INF/views/customer_products.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("cart")) {
			HttpSession session = request.getSession();
			List<Product> cartList = (List<Product>) session.getAttribute("myCartList");
			if (cartList == null) {
				cartList = new ArrayList<>();
			}

			int calculatedTotal = 0;
			int calculatedCount = 0;
			for (Product p : cartList) {
				if (p != null) {
					calculatedTotal += p.getPrice();
					calculatedCount++;
				}
			}
			request.setAttribute("productList", cartList);
			request.setAttribute("itemCount", calculatedCount);
			request.setAttribute("totalAmount", calculatedTotal);

			String msg = (String) session.getAttribute("successMessage");
			if (msg != null) {
				request.setAttribute("successMessage", msg);
				session.removeAttribute("successMessage");
			}

			String errorMsg = (String) session.getAttribute("errorMessage");
			if (errorMsg != null) {
				request.setAttribute("errorMessage", errorMsg);
				session.removeAttribute("errorMessage");
			}

			request.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("order_history")) {
			HttpSession session = request.getSession();
			User loginUser = (User) session.getAttribute("loginUser");

			List<OrderView> viewList = new ArrayList<>();
			if (loginUser != null) {
				List<Order> orders = orderRepository.findByUserIdOrderByOrderIdDesc(loginUser.getUserId());
				for (Order order : orders) {
					viewList.add(buildOrderView(order, loginUser.getDeliveryAddress()));
				}
			}

			request.setAttribute("globalHistoryList", viewList);
			request.getRequestDispatcher("/WEB-INF/views/order_history.jsp").forward(request, response);
			return;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String servletPath = request.getServletPath();

		if ("/signup".equals(servletPath)) {
			handleSignup(request, response);
			return;
		}

		if (servletPath != null && (servletPath.contains("cart") || servletPath.contains("products"))) {
			try {
				String productIdStr = request.getParameter("productId");

				if (productIdStr != null) {
					Integer productId = Integer.parseInt(productIdStr);
					Optional<Product> productOpt = productRepository.findById(productId);

					if (productOpt.isPresent() && productOpt.get().isActive()) {
						HttpSession session = request.getSession();
						List<Product> cartList = (List<Product>) session.getAttribute("myCartList");
						if (cartList == null) {
							cartList = new ArrayList<>();
						}

						cartList.add(productOpt.get());
						session.setAttribute("myCartList", cartList);
						session.setAttribute("successMessage",
								"買い物カゴに「" + productOpt.get().getProductName() + "」を正常に追加しました！");
					}
					response.sendRedirect(request.getContextPath() + "/shop/cart");
					return;
				}

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		if (servletPath != null && servletPath.contains("checkout")) {
			try {
				HttpSession session = request.getSession();
				List<Product> cartList = (List<Product>) session.getAttribute("myCartList");
				User loginUser = (User) session.getAttribute("loginUser");

				if (cartList == null || cartList.isEmpty() || loginUser == null) {
					session.setAttribute("errorMessage", "買い物カゴが空のため、決済を確定できませんでした。商品を選んでから再度お試しください。");
					response.sendRedirect(request.getContextPath() + "/shop/cart");
					return;
				}

				String deliveryDateStr = request.getParameter("deliveryDate");
				java.time.LocalDate deliveryDate;
				try {
					deliveryDate = java.time.LocalDate.parse(deliveryDateStr);
				} catch (Exception e) {
					session.setAttribute("errorMessage", "お届け希望日を正しく選択してください。");
					response.sendRedirect(request.getContextPath() + "/shop/cart");
					return;
				}
				if (deliveryDate.isBefore(java.time.LocalDate.now())) {
					session.setAttribute("errorMessage", "お届け希望日には本日以降の日付を選択してください。");
					response.sendRedirect(request.getContextPath() + "/shop/cart");
					return;
				}

				java.util.LinkedHashMap<Integer, Integer> quantityMap = new java.util.LinkedHashMap<>();
				java.util.LinkedHashMap<Integer, Product> productByIdMap = new java.util.LinkedHashMap<>();
				int finalTotal = 0;
				for (Product p : cartList) {
					if (p != null) {
						quantityMap.merge(p.getId(), 1, Integer::sum);
						productByIdMap.putIfAbsent(p.getId(), p);
						finalTotal += p.getPrice();
					}
				}

				Order order = new Order();
				order.setUserId(loginUser.getUserId());
				order.setDeliveryDate(deliveryDate);
				order.setTotalAmount(finalTotal);
				order.setStatus("reserved");
				order = orderRepository.save(order);

				for (java.util.Map.Entry<Integer, Integer> entry : quantityMap.entrySet()) {
					Product p = productByIdMap.get(entry.getKey());
					OrderItem item = new OrderItem();
					item.setOrderId(order.getOrderId());
					item.setProductId(p.getId());
					item.setQuantity(entry.getValue());
					item.setPriceAtPurchase(p.getPrice());
					orderItemRepository.save(item);
				}

				session.setAttribute("successMessage", "決済を確定し、注文履歴を保存しました！");
				session.removeAttribute("myCartList");

				response.sendRedirect(request.getContextPath() + "/customer/order_history");
				return;

			} catch (Exception e) {
				e.printStackTrace();
			}
		}

	}

	private void handleSignup(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String fullName = request.getParameter("fullName");
		String address = request.getParameter("deliveryAddress");
		String phoneNumber = request.getParameter("phoneNumber");
		String termsAgree = request.getParameter("termsAgree");

		if (termsAgree == null || !"true".equals(termsAgree)) {
			forwardWithError(request, response, "signup.jsp", "利用規約の内容を読み、同意チェックボックスをONにしてください。");
			return;
		}

		if (password == null || password.length() < 10 || !password.matches("^(?=.*[a-zA-Z])(?=.*\\d).+$")) {
			forwardWithError(request, response, "signup.jsp", "パスワードは半角英字と半角数字をそれぞれ1文字以上含んだ、10文字以上で入力してください。");
			return;
		}

		try {
			Optional<User> existingUserOpt = userRepository.findByPhoneNumber(phoneNumber);
			if (existingUserOpt.isPresent() && "disabled".equals(existingUserOpt.get().getRole())) {
				forwardWithError(request, response, "signup.jsp", "ご入力いただいた住所または電話番号は、現在ご利用いただけない状態となっております。");
				return;
			}

			User newUser = new User();
			newUser.setUsername(username);
			newUser.setPasswordHash(PasswordUtil.hash(password));
			newUser.setRole("customer");
			newUser.setFullName(fullName);
			newUser.setDeliveryAddress(address);
			newUser.setPhoneNumber(phoneNumber);
			newUser.setPenaltyBalance(0);
			userRepository.save(newUser);
			response.sendRedirect(request.getContextPath() + "/login");
		} catch (Exception e) {
			e.printStackTrace();
			forwardWithError(request, response, "signup.jsp", "システムエラーが発生しました。別のユーザーIDをお試しいただくか、入力内容をご確認ください。");
		}
	}

	private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String jspName,
			String message) throws ServletException, IOException {
		request.setAttribute("errorMessage", message);
		request.getRequestDispatcher("/WEB-INF/views/" + jspName).forward(request, response);
	}
}