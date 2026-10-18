<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>オーナー専用・売上日報報告書</title>
</head>
<body style="background-color: #ffffff; color: #000000; font-family: sans-serif; padding: 20px;">

    <header style="background-color: #008000; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1 style="margin: 0; font-size: 24px;">店長専用：本日のお支払い売上日報</h1>
                <p style="margin: 10px 0 0 0; font-size: 14px;">ログイン中の管理者: <strong><c:out value="${loginUser.fullName}"/></strong> 店長</p>
            </div>
            <a href="${pageContext.request.contextPath}/logout" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">ログアウト</a>
        </div>
    </header>

    <div style="background-color: #f0fdf4; border: 1px solid #008000; padding: 15px; width: 400px; margin-bottom: 20px;">
        <h3>本日の引渡基準・確定売上総額</h3>
        <p style="font-size: 24px; font-weight: bold; margin: 0; color: #008000;">
            ¥ ${totalSales}-
            <span style="font-size: 14px; font-weight: normal; color: #333;">（代引き集金・精算完了分）</span>
        </p>
    </div>

    <ul>
        <li><a href="${pageContext.request.contextPath}/owner/management" style="font-weight: bold; color: #008000;">総合ユーザー管理マスタ画面（手動凍結解除・住所代理更新）へ進む</a></li>
        <li><a href="${pageContext.request.contextPath}/owner/orders" style="font-weight: bold; color: #008000; display: inline-block; margin-top: 10px;">本日のリアルタイム注文履歴一覧画面へ進む</a></li>
        <li><a href="${pageContext.request.contextPath}/owner/products" style="font-weight: bold; color: #008000; display: inline-block; margin-top: 10px;">商品一覧・追加・削除マスタ画面へ進む</a></li>
    </ul>

</body>
</html>