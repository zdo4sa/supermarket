<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>本日の注文履歴マスタ</title>
</head>
<body style="background-color: #ffffff; color: #000000; font-family: sans-serif; padding: 20px;">
    <h2 style="color: #008000;">店長専用：本日の注文履歴一覧</h2>
    <hr>
    <div style="background-color: #f0fdf4; border: 1px solid #008000; padding: 15px; width: 500px; line-height: 2.0;">
        <c:forEach var="orderSummary" items="${todayOrders}">
            <p style="margin: 5px 0; border-bottom: 1px dashed #ccc; padding-bottom: 5px;"><c:out value="${orderSummary}"/></p>
        </c:forEach>
        <c:if test="${empty todayOrders}">
            <p style="margin: 5px 0; color: #64748b;">本日はまだ注文がありません。</p>
        </c:if>
    </div>
    <br>
    <p><a href="${pageContext.request.contextPath}/owner/reports" style="color: #008000; font-weight: bold;">戻る（売上日報画面へ）</a></p>
</body>
</html>