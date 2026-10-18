<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>最高管理者・総合管理マスタ</title>
</head>
<body style="background-color: #ffffff; color: #000000; font-family: sans-serif; padding: 20px;">

    <h2 style="color: #008000;"> 店長専用：総合ユーザー管理マスタ</h2>
    <p><a href="${pageContext.request.contextPath}/owner/reports">←  売上日報報告書画面へ戻る</a></p>
    <hr>

    <c:if test="${not empty successMessage}">
        <p style="color: #008000; font-weight: bold;"> <c:out value="${successMessage}"/></p>
    </c:if>

    
    <div style="margin-bottom: 30px; width: 800px;">
        <h3> 1. 自社配送スタッフ一覧</h3>
        
       
        <div style="background-color: #f0f9ff; border: 1px solid #1d4ed8; padding: 15px; margin-bottom: 20px; font-size: 14px; width: 570px;">
            <h4 style="color: #1d4ed8; margin-top:0; margin-bottom: 10px;"> 新しい配送スタッフのアカウントを発行する</h4>
            <form action="${pageContext.request.contextPath}/owner/management" method="POST" style="line-height: 2.2;">
                <input type="hidden" name="action" value="addStaff">
                配送員氏名: <input type="text" name="fullName" placeholder="例: 鈴木 太郎" required style="width: 130px;"><br>
                ログインID: <input type="text" name="username" placeholder="例: staff_suzuki" required style="width: 130px;"><br>
                パスワード: <input type="password" name="password" placeholder="pass2026staff" required style="width: 130px;"><br>
                <button type="submit" style="background-color: #1d4ed8; color: #fff; border: none; padding: 5px 15px; font-weight: bold; cursor: pointer; margin-top: 5px;">スタッフとして新規アカウント登録</button>
            </form>
        </div>

        <table border="1" cellpadding="5" style="border-collapse: collapse; width: 600px; text-align: center;">
            <tr style="background-color: #e2e8f0;">
                <th>ID</th><th>氏名</th><th>ログインアカウント</th>
            </tr>
            
            <c:forEach var="staff" items="${staffList}">
                <tr>
                    
                    <td>${staff.userId}</td>
                    <td><strong><c:out value="${staff.fullName}"/></strong></td>
                    <td><c:out value="${staff.username}"/></td>
                </tr>
            </c:forEach>
            
            <c:if test="${empty staffList}">
                <tr>
                    <td colspan="3" style="text-align: center; color: #666; background-color: #f9fafb;">現在、登録されている配送スタッフは0人です。</td>
                </tr>
            </c:if>
        </table>
    </div>

    <br>
    <h3> 2. 一般客・一時停止客マスタ</h3>
    <table border="1" cellpadding="5" style="border-collapse: collapse; width: 800px; text-align: center;">
        <tr style="background-color: #e2e8f0;">
            <th>氏名</th><th>登録住所（身元固定）</th><th>電話番号</th><th>未回収残高</th><th>状態</th><th>店長手動救済アクション</th>
        </tr>
        
        <c:forEach var="customer" items="${customerList}">
            <tr>
                <td><c:out value="${customer.fullName}"/></td>
                <td><c:out value="${customer.deliveryAddress}"/></td>
                <td><c:out value="${customer.phoneNumber}"/></td>
                <td style="color: ${customer.penaltyBalance > 0 ? '#ff0000' : '#000000'};">¥ ${customer.penaltyBalance}-</td>
                <td style="color: ${customer.role == 'disabled' ? '#ff0000' : '#000000'}; font-weight: bold;"><c:out value="${customer.role}"/></td>
                <td>
                    <c:if test="${customer.role == 'disabled'}">
                        <form action="${pageContext.request.contextPath}/owner/management" method="POST" style="margin: 0;">
                            <input type="hidden" name="action" value="unlock">
                            <input type="hidden" name="userId" value="${customer.userId}">
                            <button type="submit" style="cursor: pointer; font-weight: bold; color: #008000;"> 通常会員へ凍結解除</button>
                        </form>
                    </c:if>
                    <c:if test="${customer.role != 'disabled'}">
                        <span style="color: #666; font-size: 14px;">通常稼働中（対応不要）</span>
                    </c:if>
                </td>
            </tr>
        </c:forEach>
        
        <c:if test="${empty customerList}">
            <tr>
                <td colspan="6" style="text-align: center; color: #666; background-color: #f9fafb;">現在、対象の顧客ユーザーは0人です。</td>
            </tr>
        </c:if>
    </table>

    <br><br>
    <p><a href="${pageContext.request.contextPath}/logout" style="color: #666;">ログアウト</a></p>

</body>
</html>