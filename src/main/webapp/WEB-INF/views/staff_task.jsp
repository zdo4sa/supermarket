<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>自社定期便・配達チェックリスト</title>
    <script>
        function validateTasks(event) {
            var c1 = document.getElementById("task1").checked;
            var c2 = document.getElementById("task2").checked;
            var c3 = document.getElementById("task3").checked;
            if (!c1 || !c2 || !c3) {
                alert("すべての安全運行タスクにチェックを入れてから次へ進んでください。");
                event.preventDefault();
                return false;
            }
            return true;
        }
    </script>
</head>
<body style="font-family: sans-serif; padding: 20px; background-color: #fff7ed; color: #431407;">

    <header style="background-color: #ea580c; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px;">
        <h1 style="margin: 0; font-size: 22px;">自社定期便・運行安全チェックタスク表</h1>
        <p style="margin: 5px 0 0 0; font-size: 14px;">現在配達中の配送先: <strong><c:out value="${selectedOrder != null ? selectedOrder.address : '（配送先データなし）'}"/></strong></p>
    </header>

    <div style="background-color: #ffffff; padding: 25px; border-radius: 6px; border: 1px solid #fed7aa; box-shadow: 0 4px 6px rgba(0,0,0,0.05);">
        <h3 style="color: #ea580c; margin-top: 0; border-bottom: 2px solid #ea580c; padding-bottom: 5px;">積込荷物および安全配送タスク（全チェック必須）</h3>

        <form action="${pageContext.request.contextPath}/staff/task" method="POST" onsubmit="return validateTasks(event);">
            <input type="hidden" name="orderId" value="${orderId}">

            <div style="display: flex; flex-direction: column; gap: 15px; margin: 20px 0; font-size: 16px; font-weight: bold; text-align: left;">
                <label style="background-color: #fef2f2; padding: 12px; border-radius: 4px; cursor: pointer; border: 1px solid #fca5a5; display: block;">
                    <input type="checkbox" id="task1" style="transform: scale(1.3); margin-right: 10px;"> 1. 注文内容（美味しいお茶 / オムライスなど）の積込数量と保冷状態を確認した
                </label>
                <label style="background-color: #fffbeb; padding: 12px; border-radius: 4px; cursor: pointer; border: 1px solid #fde68a; display: block;">
                    <input type="checkbox" id="task2" style="transform: scale(1.3); margin-right: 10px;"> 2. 指定配送先住所を確認が完了した
                </label>
                <label style="background-color: #f0fdf4; padding: 12px; border-radius: 4px; cursor: pointer; border: 1px solid #bbf7d0; display: block;">
                    <input type="checkbox" id="task3" style="transform: scale(1.3); margin-right: 10px;"> 3. お届け商品の破損・液漏れがないことを目視確認し、しっかり収納したか
                </label>
            </div>

            <button type="submit" style="background-color: #ea580c; color: #ffffff; padding: 12px 30px; font-size: 16px; font-weight: bold; border: none; border-radius: 4px; cursor: pointer; width: 100%; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">配達を完了し領収書を発行する</button>
        </form>
    </div>
</body>
</html>