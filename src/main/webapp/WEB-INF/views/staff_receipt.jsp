<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>領収書確認マスタ</title>
    <script>
        function copyReceiptText() {
            var receiptText = document.getElementById("receiptDataArea").innerText;
            navigator.clipboard.writeText(receiptText).then(function() {
                var btn = document.getElementById("copyBtn");
                btn.innerText = "コピー完了";
                btn.style.backgroundColor = "#2563eb";
                setTimeout(function() {
                    btn.innerText = "この領収書のテキストをクリップボードにコピーする";
                    btn.style.backgroundColor = "#1e293b";
                }, 3000);
            });
        }
    </script>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #f1f5f9; color: #1e293b; text-align: center;">

    <h1 style="color: #1e293b; margin-bottom: 20px;">電子決済取引・公式領収明細書</h1>

    <div id="receiptDataArea" style="background-color: #ffffff; padding: 30px; border-radius: 6px; border: 2px dashed #94a3b8; max-width: 500px; margin: 0 auto; text-align: left; font-family: monospace; font-size: 14px; line-height: 1.8; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
        ==================================================<br>
        　　　　newネットスーパー・本日本店 領収書<br>
        ==================================================<br>
        ■ 発行日時 : <c:out value="${selectedOrder != null ? selectedOrder.orderDate : '2026年8月1日'}"/>（通常便）<br>
        ■ 配送住所 : <c:out value="${selectedOrder != null ? selectedOrder.address : '（配送先データなし）'}"/> 配送スタッフ引渡済<br>
        ■ お届内容 : <c:out value="${selectedOrder != null ? selectedOrder.detail : 'おにぎり弁当 おにぎり弁当'}"/><br>
        --------------------------------------------------<br>
        ■ 総合計額 : <c:out value="${selectedOrder != null ? selectedOrder.amount : '¥ 1,100-'}"/><br>
        ■ 決済状況 : ${selectedOrder != null && selectedOrder.status == 'completed' ? "現地にて代金領収済み" : (selectedOrder != null && selectedOrder.status == 'failed' ? "未回収（お客様アカウントへ反映済み）" : "確認中（帰社後に受領確認を行います）")}<br>
        ==================================================<br>
        newネットスーパー配送センター・品川本店<br>
        上記金額、正に領収いたしました。またのご利用をお待ちしております。<br>
        ==================================================
    </div>

    <br>
    <button id="copyBtn" onclick="copyReceiptText();" style="background-color: #1e293b; color: #ffffff; padding: 15px 30px; font-size: 15px; font-weight: bold; border: none; border-radius: 4px; cursor: pointer; max-width: 540px; width: 100%; box-shadow: 0 4px 6px rgba(0,0,0,0.1); transition: background-color 0.2s;">この領収書のテキストをクリップボードにコピーする</button>

    <div style="margin-top: 30px;">
        <a href="${pageContext.request.contextPath}/staff/orders" style="color: #475569; font-weight: bold; text-decoration: none;">配送スケジュール一覧へ戻る</a>
    </div>

</body>
</html>