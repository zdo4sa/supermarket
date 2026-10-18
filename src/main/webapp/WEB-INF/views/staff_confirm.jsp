<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>支払い確認</title>
    <script>
        function validatePayment(event) {
            var paymentReceived = document.querySelector('input[name="paymentReceived"]:checked');
            if (!paymentReceived) {
                alert("代金を受け取れたかどうかを選択してください。");
                event.preventDefault();
                return false;
            }
            return true;
        }
    </script>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #fffbeb; color: #1e293b;">

    <header style="background-color: #b45309; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px;">
        <h1 style="margin: 0; font-size: 22px;">支払い確認</h1>
        <p style="margin: 5px 0 0 0; font-size: 14px;">配送先: <strong><c:out value="${selectedOrder != null ? selectedOrder.address : '（配送先データなし）'}"/></strong></p>
    </header>

    <div style="background-color: #ffffff; padding: 25px; border-radius: 6px; border: 1px solid #fde68a; box-shadow: 0 4px 6px rgba(0,0,0,0.05); max-width: 480px;">
        <form action="${pageContext.request.contextPath}/staff/confirm" method="POST" onsubmit="return validatePayment(event);">
            <input type="hidden" name="orderId" value="${orderId}">

            <div style="background-color: #fef2f2; padding: 12px; border-radius: 4px; border: 1px solid #fca5a5; margin-bottom: 20px; text-align: left;">
                <p style="margin: 0 0 10px 0; font-weight: bold;">お客様から代金（<c:out value="${selectedOrder != null ? selectedOrder.amount : ''}"/>）を確実に受け取れましたか？</p>
                <label style="margin-right: 20px; font-weight: normal; cursor: pointer;">
                    <input type="radio" name="paymentReceived" value="yes" style="transform: scale(1.2); margin-right: 6px;"> 受け取った
                </label>
                <label style="font-weight: normal; cursor: pointer; color: #b91c1c;">
                    <input type="radio" name="paymentReceived" value="no" style="transform: scale(1.2); margin-right: 6px;"> 受け取れなかった（未回収）
                </label>
            </div>

            <button type="submit" style="background-color: #b45309; color: #ffffff; padding: 12px 30px; font-size: 16px; font-weight: bold; border: none; border-radius: 4px; cursor: pointer; width: 100%;">この内容で記録する</button>
        </form>
    </div>
</body>
</html>