<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>注文履歴・配送ステータス</title>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #f8fafc; color: #334155;">

    <h1 style="color: #1e293b; border-bottom: 2px solid #1e293b; padding-bottom: 10px;">注文履歴明細書</h1>
    <p>ログインユーザー：<strong><c:out value="${sessionScope.loginUser.fullName}"/></strong> 様</p>

    <% if (session.getAttribute("successMessage") != null) { %>
        <p style="color: #16a34a; font-weight: bold; background-color: #dcfce7; padding: 10px; border-left: 5px solid #16a34a;">
            <c:out value="${sessionScope.successMessage}"/>
        </p>
    <% } %>

    <div style="margin-top: 20px; background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #e2e8f0;">
        <h3 style="margin-top: 0; color: #1e293b;">過去のご注文履歴</h3>

        <table border="1" cellpadding="10" style="border-collapse: collapse; width: 100%; text-align: center; border-color: #cbd5e1;">
            <tr style="background-color: #f1f5f9; color: #1e293b;">
                <th>注文日時</th>
                <th>配送先住所</th>
                <th>ご注文内容</th>
                <th>総合決済金額</th>
                <th>配送ステータス</th>
            </tr>
            
            <%
                java.util.List list = (java.util.List) request.getAttribute("globalHistoryList");

                if (list != null && !list.isEmpty()) {
                    for (Object obj : list) {
                        request.setAttribute("hist", obj);
            %>

            <tr style="line-height: 1.8;">
              <td><strong><c:out value="${hist.orderDate}"/></strong></td>
    <td><strong><c:out value="${sessionScope.loginUser.deliveryAddress}"/></strong></td>
    <td style="color: #1e293b; text-align: left; font-weight: bold;"><c:out value="${hist.detail}"/></td>
    <td style="font-weight: bold; color: #b91c1c; font-size: 16px;"><c:out value="${hist.amount}"/></td>
    <td>
        <c:choose>
            <c:when test="${hist.status == 'completed'}">
                <span style="font-weight: bold; color: #16a34a;">配達完了（代金お支払い確認済み）</span>
            </c:when>
            <c:when test="${hist.status == 'failed'}">
                <span style="font-weight: bold; color: #b91c1c;">配達完了（代金未回収のためアカウント要確認）</span>
            </c:when>
            <c:when test="${hist.status == 'delivered'}">
                <span style="font-weight: bold; color: #b45309;">配達完了（お支払い確認中）</span>
            </c:when>
            <c:otherwise>
                <span style="font-weight: bold; color: #1d4ed8;">配達準備中（スタッフ引渡待ち）</span>
            </c:otherwise>
        </c:choose>
    </td>
            </tr>
            
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" style="text-align: center; color: #64748b; padding: 15px; background-color: #f8fafc;">現在、ご注文履歴はありません。お買い物を済ませると、ここに表示されます。</td>
            </tr>
            <% } %>
        </table>

        <div style="background-color: #f8fafc; border: 1px solid #cbd5e1; padding: 15px; margin-top: 20px; border-radius: 4px;">
            <h4 style="margin-top: 0; color: #1e293b; border-bottom: 1px solid #cbd5e1; padding-bottom: 5px;">今回の自社定期便・お届け先配送情報</h4>
            <table style="width: 100%; font-size: 14px; line-height: 2.0; text-align: left;">
                <tr>
                    <td style="width: 150px; font-weight: bold; color: #64748b;">お受取人氏名:</td>
                    <td style="font-weight: bold; color: #1e293b;"><c:out value="${sessionScope.loginUser.fullName}"/> 様</td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: #64748b;">ご指定配送先住所:</td>
                    <td style="font-weight: bold; color: #1e293b; background-color: #f0fdf4; padding-left: 5px;"><c:out value="${sessionScope.loginUser.deliveryAddress}"/></td>
                </tr>
                <tr>
                    <td style="font-weight: bold; color: #64748b;">緊急連絡先電話番号:</td>
                    <td style="font-weight: bold; color: #1e293b;"><c:out value="${sessionScope.loginUser.phoneNumber}"/></td>
                </tr>
            </table>
            <p style="font-size: 12px; color: #b91c1c; margin: 10px 0 0 0;">※住所の変更が必要な場合は、店舗の窓口へ申請してください。</p>
        </div>
    </div>

    <div style="margin-top: 25px;">
        <a href="${pageContext.request.contextPath}/shop/products" style="background-color: #16a34a; color: #ffffff; padding: 10px 20px; font-weight: bold; border-radius: 4px; text-decoration: none; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">お買い物を続ける（商品カタログへ戻る）</a>
    </div>

</body>
</html>