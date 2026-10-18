<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>newネットスーパー・商品お買い物マスタカタログ</title>
</head>
<body style="background-color: #f8fafc; color: #334155; font-family: sans-serif; padding: 20px;">

    <header style="background-color: #16a34a; color: #ffffff; padding: 20px; border-radius: 6px; margin-bottom: 25px;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start;">
            <div>
                <h1 style="margin: 0; font-size: 24px;">newネットスーパー・オンライン本店</h1>
                <p style="margin: 10px 0 0 0; font-size: 14px;">ログイン中の会員様: <strong><c:out value="${sessionScope.loginUser.fullName}"/></strong> 様（通常稼働中）</p>
            </div>
            <div style="display: flex; gap: 10px;">
                <a href="${pageContext.request.contextPath}/customer/order_history" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">注文履歴・配送ステータス確認</a>
                <a href="${pageContext.request.contextPath}/logout" style="color: #ffffff; background-color: rgba(255,255,255,0.15); text-decoration: none; padding: 6px 14px; border-radius: 4px; font-size: 13px; font-weight: bold;">ログアウト</a>
            </div>
        </div>
    </header>

    <c:if test="${not empty successMessage}">
        <p style="color: #16a34a; font-weight: bold; background-color: #dcfce7; padding: 10px; border-left: 5px solid #16a34a; margin-bottom: 20px;">
            <c:out value="${successMessage}"/>
        </p>
    </c:if>

    <div style="display: flex; gap: 20px;">
        <div style="flex: 3; background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #e2e8f0;">
            <h2 style="color: #16a34a; margin-top: 0; border-bottom: 2px solid #16a34a; padding-bottom: 5px;">商品一覧</h2>

            <div style="display: flex; flex-wrap: wrap; gap: 20px; margin-top: 20px;">

                <%
                    java.util.List products = (java.util.List) request.getAttribute("productList");
                    if (products != null && !products.isEmpty()) {
                        for (Object obj : products) {
                            request.setAttribute("product", obj);
                %>

                <div style="border: 1px solid #ccc; padding: 15px; width: 180px; text-align: center; background-color: #ffffff; border-radius: 6px;">
                    <div style="width: 100%; height: 120px; display: flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                        <img src="${pageContext.request.contextPath}/images/${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.productName)}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
                    </div>
                    <h4 style="margin: 10px 0 5px 0;"><c:out value="${product.productName}"/></h4>
                    <p style="color: #ff0000; font-weight: bold; margin: 0 0 10px 0;">¥ ${product.price}-</p>

                    <form action="${pageContext.request.contextPath}/shop/cart" method="POST" style="margin:0;">
                        <input type="hidden" name="action" value="addCart">
                        <input type="hidden" name="productId" value="${product.id}">
                        <button type="submit" style="padding: 6px 15px; cursor: pointer; background-color: #16a34a; color: #fff; border: none; border-radius: 4px; font-weight: bold; width: 100%;">買い物カゴへ追加</button>
                    </form>
                </div>

                <%
                        }
                    } else {
                %>
                    <p style="color: #64748b; padding: 20px; text-align: center; width: 100%;">準備中です。店長画面から「新商品登録」を行うと、ここに画像付きでリアルタイムに大出現します！</p>
                <%
                    }
                %>

            </div>
        </div>

        <div style="flex: 1; background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #e2e8f0; height: fit-content;">
            <h3 style="color: #1e293b; margin-top: 0; border-bottom: 2px solid #cbd5e1; padding-bottom: 5px;">現在の買い物カゴ</h3>

            <p style="font-size: 13px; color: #64748b;">精算対象数量: <strong>${itemCount} 個</strong></p>

            <div style="margin: 20px 0; font-weight: bold; font-size: 18px; text-align: center; color: #b91c1c; background-color: #fef2f2; padding: 10px; border-radius: 4px;">
                合計金額: ¥ ${totalAmount}-
            </div>

            <a href="${pageContext.request.contextPath}/shop/cart" style="display: block; text-align: center; background-color: #1e293b; color: #ffffff; padding: 10px; font-weight: bold; border-radius: 4px; text-decoration: none;">カゴの中身を詳しく見る・精算へ</a>
        </div>
    </div>

</body>
</html>