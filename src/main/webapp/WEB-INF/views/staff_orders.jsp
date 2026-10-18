<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>自社定期便・配達スケジュール管理マスタ</title>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #f0fdf4; color: #1e293b;">

    <header style="background-color: #15803d; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1 style="margin: 0; font-size: 24px;">newネットスーパー・自社定期便配送センター</h1>
                <p style="margin: 10px 0 0 0; font-size: 14px;">ログイン中の配送スタッフ: <strong><c:out value="${sessionScope.loginUser.fullName}"/></strong> 様</p>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/staff/pending" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">支払い確認待ち一覧</a>
                <a href="${pageContext.request.contextPath}/logout" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">ログアウト</a>
            </div>
        </div>
    </header>

    <c:if test="${not empty staffMessage}">
        <p style="color: #b91c1c; font-weight: bold; background-color: #fee2e2; padding: 10px; border-radius: 6px; border-left: 5px solid #b91c1c; margin-bottom: 20px;"><c:out value="${staffMessage}"/></p>
    </c:if>

    <div style="background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #bbf7d0; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
        <h3 style="margin-top: 0; color: #15803d; border-bottom: 2px solid #15803d; padding-bottom: 5px;">本日の配達スケジュール・運行ルート一覧</h3>

        <table border="1" cellpadding="10" style="border-collapse: collapse; width: 100%; text-align: center; border-color: #cbd5e1; margin-top: 15px;">
            <tr style="background-color: #f0fdf4; color: #15803d; font-weight: bold;">
                <th>注文日時</th>
                <th>お届け先配送先住所</th>
                <th>積込商品内容（内訳明細）</th>
                <th>ご請求予定額</th>
                <th>操作・ルート開始</th>
            </tr>

            <c:forEach var="hist" items="${globalHistoryList}">
                <tr style="line-height: 1.8; font-size: 14px; ${hist.orderDate lt todayDate ? 'background-color: #fef2f2;' : ''}">
                    <td>
                        <strong><c:out value="${hist.orderDate}"/></strong>
                        <c:if test="${hist.orderDate lt todayDate}">
                            <br><span style="color: #b91c1c; font-weight: bold; font-size: 12px;">延滞中（要早急対応）</span>
                        </c:if>
                    </td>
                    <td style="text-align: left; background-color: #fff9db;"><strong><c:out value="${hist.address}"/></strong></td>
                    <td style="color: #1e293b; text-align: left; font-weight: bold;"><c:out value="${hist.detail}"/></td>
                    <td style="font-weight: bold; color: #b91c1c;"><c:out value="${hist.amount}"/> （配達時に現地決済）</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/staff/task?orderId=${hist.orderId}" style="background-color: #15803d; color: #ffffff; text-decoration: none; padding: 6px 15px; border-radius: 4px; font-weight: bold; display: inline-block; font-size: 12px; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">この配達を開始する</a>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty globalHistoryList}">
                <tr style="line-height: 1.8; font-size: 14px;">
                    <td colspan="5" style="text-align: center; color: #64748b; padding: 15px; background-color: #f8fafc;">現在、本日分の配達注文はありません。</td>
                </tr>
            </c:if>
        </table>
    </div>
</body>
</html>