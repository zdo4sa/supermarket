package com.example.supermarke.servlet;

import java.io.IOException;
import java.time.LocalDateTime;
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
import com.example.supermarke.repository.OrderItemRepository;
import com.example.supermarke.repository.OrderRepository;
import com.example.supermarke.repository.ProductRepository;
import com.example.supermarke.repository.UserRepository;

@WebServlet({ "/staff/orders", "/staff/task", "/staff/receipt", "/staff/pending", "/staff/confirm" })
public class StaffServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final UserRepository userRepository;
	private final OrderRepository orderRepository;
	private final OrderItemRepository orderItemRepository;
	private final ProductRepository productRepository;

	public StaffServlet(UserRepository userRepository, OrderRepository orderRepository,
			OrderItemRepository orderItemRepository, ProductRepository productRepository) {
		this.userRepository = userRepository;
		this.orderRepository = orderRepository;
		this.orderItemRepository = orderItemRepository;
		this.productRepository = productRepository;
	}

	private OrderView buildOrderView(Order order) {
		String address = userRepository.findById(order.getUserId())
				.map(u -> u.getDeliveryAddress())
				.orElse("（配送先データなし）");

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

	private String popStaffMessage(HttpSession session) {
		String message = (String) session.getAttribute("staffMessage");
		if (message != null) {
			session.removeAttribute("staffMessage");
		}
		return message;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String servletPath = request.getServletPath();

		if (servletPath != null && servletPath.contains("orders")) {
			List<Order> pendingOrders = orderRepository
					.findByStatusAndDeliveryDateLessThanEqualOrderByDeliveryDateAscOrderIdAsc("reserved",
							java.time.LocalDate.now());
			List<OrderView> viewList = new ArrayList<>();
			for (Order order : pendingOrders) {
				viewList.add(buildOrderView(order));
			}
			request.setAttribute("globalHistoryList", viewList);
			request.setAttribute("todayDate", java.time.LocalDate.now().toString());

			String staffMessage = popStaffMessage(request.getSession());
			if (staffMessage != null) {
				request.setAttribute("staffMessage", staffMessage);
			}

			request.getRequestDispatcher("/WEB-INF/views/staff_orders.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("task")) {
			String orderIdStr = request.getParameter("orderId");
			if (orderIdStr != null) {
				try {
					Integer orderId = Integer.parseInt(orderIdStr);
					Optional<Order> orderOpt = orderRepository.findById(orderId);
					if (orderOpt.isPresent()) {
						request.setAttribute("selectedOrder", buildOrderView(orderOpt.get()));
						request.setAttribute("orderId", orderId);
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}
			request.getRequestDispatcher("/WEB-INF/views/staff_task.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("receipt")) {
			String orderIdStr = request.getParameter("orderId");
			if (orderIdStr != null) {
				try {
					Integer orderId = Integer.parseInt(orderIdStr);
					Optional<Order> orderOpt = orderRepository.findById(orderId);
					if (orderOpt.isPresent() && !"reserved".equals(orderOpt.get().getStatus())) {
						request.setAttribute("selectedOrder", buildOrderView(orderOpt.get()));
					} else {
						response.sendRedirect(request.getContextPath() + "/staff/orders");
						return;
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
					response.sendRedirect(request.getContextPath() + "/staff/orders");
					return;
				}
			} else {
				response.sendRedirect(request.getContextPath() + "/staff/orders");
				return;
			}
			request.getRequestDispatcher("/WEB-INF/views/staff_receipt.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("pending")) {
			List<Order> deliveredOrders = orderRepository.findByStatusOrderByCompletedAtAsc("delivered");
			List<OrderView> viewList = new ArrayList<>();
			for (Order order : deliveredOrders) {
				viewList.add(buildOrderView(order));
			}
			request.setAttribute("pendingList", viewList);

			String staffMessage = popStaffMessage(request.getSession());
			if (staffMessage != null) {
				request.setAttribute("staffMessage", staffMessage);
			}

			request.getRequestDispatcher("/WEB-INF/views/staff_pending.jsp").forward(request, response);
			return;
		}

		if (servletPath != null && servletPath.contains("confirm")) {
			String orderIdStr = request.getParameter("orderId");
			if (orderIdStr != null) {
				try {
					Integer orderId = Integer.parseInt(orderIdStr);
					Optional<Order> orderOpt = orderRepository.findById(orderId);
					if (orderOpt.isPresent() && "delivered".equals(orderOpt.get().getStatus())) {
						request.setAttribute("selectedOrder", buildOrderView(orderOpt.get()));
						request.setAttribute("orderId", orderId);
					} else {
						response.sendRedirect(request.getContextPath() + "/staff/pending");
						return;
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
					response.sendRedirect(request.getContextPath() + "/staff/pending");
					return;
				}
			} else {
				response.sendRedirect(request.getContextPath() + "/staff/pending");
				return;
			}
			request.getRequestDispatcher("/WEB-INF/views/staff_confirm.jsp").forward(request, response);
			return;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		String servletPath = request.getServletPath();
		String orderIdStr = request.getParameter("orderId");

		if (servletPath != null && servletPath.contains("task")) {
			if (orderIdStr != null) {
				try {
					Integer orderId = Integer.parseInt(orderIdStr);
					orderRepository.findById(orderId).ifPresent(order -> {
						if (!"reserved".equals(order.getStatus())) {
							return;
						}
						order.setStatus("delivered");
						order.setCompletedAt(LocalDateTime.now());
						orderRepository.save(order);
					});
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}
			response.sendRedirect(request.getContextPath() + "/staff/receipt?orderId=" + orderIdStr);
			return;
		}

		if (servletPath != null && servletPath.contains("confirm")) {
			String paymentReceived = request.getParameter("paymentReceived");
			boolean received = "yes".equals(paymentReceived);

			if (orderIdStr != null) {
				try {
					Integer orderId = Integer.parseInt(orderIdStr);
					Optional<Order> orderOpt = orderRepository.findById(orderId);

					if (orderOpt.isPresent()) {
						Order order = orderOpt.get();
						if (!"delivered".equals(order.getStatus())) {
							request.getSession().setAttribute("staffMessage",
									"注文ID: " + orderIdStr + " はすでに処理済みのため、変更しませんでした。");
							response.sendRedirect(request.getContextPath() + "/staff/pending");
							return;
						}
						order.setStatus(received ? "completed" : "failed");
						orderRepository.save(order);

						if (!received) {
							userRepository.findById(order.getUserId()).ifPresent(user -> {
								user.setPenaltyBalance(user.getPenaltyBalance() + order.getTotalAmount());
								user.setRole("disabled");
								userRepository.save(user);
							});
						}

						request.getSession().setAttribute("staffMessage",
								received
										? "注文ID: " + orderIdStr + " を支払い受領済みとして記録しました。"
										: "注文ID: " + orderIdStr + " を未回収として記録しました。顧客アカウントへ反映済みです。");
					}
				} catch (NumberFormatException e) {
					e.printStackTrace();
				}
			}

			response.sendRedirect(request.getContextPath() + "/staff/pending");
			return;
		}
	}
}