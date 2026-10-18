<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>支払い確認待ち一覧</title>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #fffbeb; color: #1e293b;">

    <header style="background-color: #b45309; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1 style="margin: 0; font-size: 24px;">支払い確認待ち一覧</h1>
                <p style="margin: 10px 0 0 0; font-size: 14px;">配達・領収書発行は済んでいるが、代金を受け取れたかまだ記録していない注文</p>
            </div>
            <a href="${pageContext.request.contextPath}/staff/orders" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">配達スケジュールへ戻る</a>
        </div>
    </header>

    <c:if test="${not empty staffMessage}">
        <p style="color: #b91c1c; font-weight: bold; background-color: #fee2e2; padding: 10px; border-radius: 6px; border-left: 5px solid #b91c1c; margin-bottom: 20px;"><c:out value="${staffMessage}"/></p>
    </c:if>

    <div style="background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #fde68a; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
        <table border="1" cellpadding="10" style="border-collapse: collapse; width: 100%; text-align: center; border-color: #cbd5e1;">
            <tr style="background-color: #fffbeb; color: #b45309; font-weight: bold;">
                <th>配達完了日時</th>
                <th>配送先住所</th>
                <th>お届け内容</th>
                <th>ご請求額</th>
                <th>操作</th>
            </tr>

            <c:forEach var="hist" items="${pendingList}">
                <tr style="line-height: 1.8; font-size: 14px;">
                    <td><strong><c:out value="${hist.orderDate}"/></strong></td>
                    <td style="text-align: left;"><strong><c:out value="${hist.address}"/></strong></td>
                    <td style="text-align: left; font-weight: bold;"><c:out value="${hist.detail}"/></td>
                    <td style="font-weight: bold; color: #b91c1c;"><c:out value="${hist.amount}"/></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/staff/confirm?orderId=${hist.orderId}" style="background-color: #b45309; color: #ffffff; text-decoration: none; padding: 6px 15px; border-radius: 4px; font-weight: bold; display: inline-block; font-size: 12px;">支払い確認をする</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty pendingList}">
                <tr style="line-height: 1.8; font-size: 14px;">
                    <td colspan="5" style="text-align: center; color: #64748b; padding: 15px; background-color: #f8fafc;">支払い確認待ちの注文はありません。</td>
                </tr>
            </c:if>
        </table>
    </div>
</body>
</html>