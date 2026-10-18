<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>ログイン総合窓口</title>
</head>
<body style="background-color: #f0fdf4; color: #1e293b; font-family: sans-serif; padding: 40px 20px; margin: 0;">

    <div style="max-width: 420px; margin: 0 auto;">

        <div style="text-align: center; margin-bottom: 24px;">
            <h1 style="margin: 0; font-size: 22px; color: #15803d;">newネットスーパー</h1>
            <p style="margin: 6px 0 0 0; font-size: 14px; color: #64748b;">ログイン総合窓口</p>
        </div>

        <div style="background-color: #ffffff; padding: 30px; border-radius: 10px; border: 1px solid #bbf7d0; box-shadow: 0 4px 10px rgba(0,0,0,0.06);">

            <% if (request.getAttribute("errorMessage") != null) { %>
                <p style="color: #b91c1c; font-weight: bold; background-color: #fee2e2; padding: 10px; border-radius: 6px; border-left: 5px solid #b91c1c; margin-top: 0; font-size: 14px;">❌ <c:out value="${errorMessage}"/></p>
            <% } %>

            <% if (request.getParameter("banned") != null) { %>
                <div style="border: 1px solid #fca5a5; background-color: #fef2f2; padding: 14px; border-radius: 6px; margin-bottom: 20px;">
                    <p style="color: #b91c1c; font-weight: bold; margin: 0; line-height: 1.6; font-size: 14px;">
                        ⚠️ ご入力いただいたアカウントは、現在一時的にご利用いただけない状態となっております。<br>
                        恐れ入りますが、お心当たりのある場合は店舗の窓口またはお電話にて、前回の配送・未回収状況をご確認いただけますようお願い申し上げます。
                    </p>
                </div>
            <% } %>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">ユーザーID（ログインID）</label>
                <input type="text" name="userId" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 18px;">

                <label style="display: block; font-weight: bold; font-size: 14px; color: #334155; margin-bottom: 6px;">パスワード</label>
                <input type="password" name="password" required
                    style="width: 100%; box-sizing: border-box; padding: 10px 12px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 6px; margin-bottom: 24px;">

                <button type="submit"
                    style="width: 100%; background-color: #15803d; color: #ffffff; border: none; padding: 12px; font-size: 16px; font-weight: bold; border-radius: 6px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">ログイン</button>
            </form>

            <hr style="border: 0; border-top: 1px solid #e2e8f0; margin: 24px 0;">

            <p style="text-align: center; margin: 0; font-size: 14px;">
                <a href="${pageContext.request.contextPath}/signup" style="color: #15803d; font-weight: bold; text-decoration: none;">⇒ はじめてご利用の方（新規会員登録はこちら）</a>
            </p>
        </div>
    </div>

</body>
</html>