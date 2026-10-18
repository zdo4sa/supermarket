<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>新規会員登録</title>
</head>
<body style="background-color: #f0fdf4; color: #1e293b; font-family: sans-serif; padding: 40px 20px; margin: 0;">

    <div style="max-width: 480px; margin: 0 auto;">

        <div style="text-align: center; margin-bottom: 24px;">
            <h1 style="margin: 0; font-size: 22px; color: #15803d;">newネットスーパー</h1>
            <p style="margin: 6px 0 0 0; font-size: 14px; color: #64748b;">新規会員登録</p>
        </div>

        <div style="background-color: #ffffff; padding: 30px; border-radius: 10px; border: 1px solid #bbf7d0; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">

            
            <% if (request.getAttribute("errorMessage") != null) { %>
                <p style="color: #b91c1c; font-weight: bold; background-color: #fee2e2; padding: 10px; border-radius: 6px; border-left: 5px solid #b91c1c; margin-top: 0; font-size: 14px;">⚠️ <c:out value="${errorMessage}"/></p>
            <% } %>

            <form action="${pageContext.request.contextPath}/signup" method="POST">

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">ユーザーID（ログインID）</label>
                <input type="text" name="username" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 16px;">

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">パスワード</label>
                <input type="password" name="password" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 4px;">
                <p style="margin: 0 0 16px 0; font-size: 12px; color: #64748b;">※半角英数それぞれ1文字以上含む10文字以上</p>

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">お名前（フルネーム）</label>
                <input type="text" name="fullName" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 16px;">

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">配送先住所</label>
                <input type="text" name="deliveryAddress" required placeholder="例：品川区大井1-1-1"
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 4px;">
                <p style="margin: 0 0 16px 0; font-size: 12px; color: #64748b;">※品川区大井、品川区広町、品川区西品川など、実在エリア町名から入力</p>

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">電話番号（携帯または固定）</label>
                <input type="text" name="phoneNumber" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 20px;">

                
                <div style="border: 1px solid #cbd5e1; padding: 14px; border-radius: 6px; background-color: #f8fafc; font-size: 13px; margin-bottom: 14px; line-height: 1.7;">
                    <strong style="color: #1e293b;">【大切なお知らせ（利用規約）】</strong><br>
                    当サイトは毎日15:00に当日の配達を完全に締め切ります。通信環境による遅延やタイムラグによって、サーバー到着時刻が15:01以降となったさいは翌日のお届けとなりますのでご了承ください。電波の良い場所で、お時間に十分な余裕を持ってご注文手続きを完了させてください。
                </div>

                <label style="display: flex; align-items: flex-start; gap: 8px; font-size: 14px; font-weight: bold; margin-bottom: 24px; cursor: pointer;">
                    <input type="checkbox" name="termsAgree" value="true" id="agree" required style="margin-top: 3px;">
                    <span>上記の利用規約の内容をすべて読み、完全に同意します（チェック必須）</span>
                </label>

                <button type="submit"
                    style="width: 100%; background-color: #15803d; color: #ffffff; border: none; padding: 12px; font-size: 16px; font-weight: bold; border-radius: 6px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">🆕 この内容でアカウントを作成する</button>
            </form>

            <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 24px 0;">

            <p style="text-align: center; margin: 0; font-size: 14px;">
                <a href="${pageContext.request.contextPath}/login" style="color: #15803d; font-weight: bold; text-decoration: none;">⇒ 登録済みの方はこちら（ログイン画面へ）</a>
            </p>
        </div>
    </div>

</body>
</html>