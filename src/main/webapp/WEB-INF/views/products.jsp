<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>${sessionScope.role == 'owner' ? '商品在庫・管理編集' : '商品カタログ・お買い物'}</title>
</head>
<body style="background-color: #ffffff; color: #000000; font-family: sans-serif; padding: 20px;">

    <div style="${sessionScope.role == 'customer' ? 'display: block;' : 'display: none;'}">
        <h2>一般顧客専用：特売カタログ</h2>
        <p>ようこそ、<strong><c:out value="${loginUser.fullName}"/></strong> 様 | 配達先住所：<c:out value="${loginUser.deliveryAddress}"/></p>

        <div style="border: 1px dashed #333; padding: 10px; background-color: #fffbeb; width: 550px; margin-bottom: 20px; font-size: 14px;">
            <strong>お探しの商品を見つけるには？</strong><br>
            キーボードの <strong>[Ctrl] + [F]</strong>（Macの方は <strong>[Command] + [F]</strong>）を押すと、ブラウザ独自の高速文字検索窓が立ち上がります. ぜひご活用ください！
        </div>
    </div>

    <div style="${sessionScope.role == 'owner' ? 'display: block;' : 'display: none;'}">
        <h2 style="color: #008000;">店長専用：商品・在庫管理統括コントロールマスタ</h2>
        <p>現在のログイン管理者：<strong><c:out value="${loginUser.fullName}"/></strong> 店長</p>

        <p style="color: #008000; font-weight: bold;"><c:out value="${successMessage}"/></p>

        <div style="background-color: #f0fdf4; border: 1px solid #008000; padding: 15px; width: 550px; margin-bottom: 20px;">
            <h3 style="color: #008000; margin-top:0;">カタログに新しい商品を追加する</h3>
            <form action="${pageContext.request.contextPath}/owner/products" method="POST" enctype="multipart/form-data" style="line-height: 2.2; font-size: 14px;">
                <input type="hidden" name="action" value="add">
                商品名: <input type="text" name="productName" placeholder="例: サンふじりんご" required style="width: 200px;"> |
                価格: <input type="number" name="price" placeholder="300" required style="width: 70px;"> 円<br>

                商品画像: <input type="file" name="productImage" accept="image/*" required><br>
                <button type="submit" style="background-color: #008000; color: #fff; border: none; padding: 5px 15px; font-weight: bold; cursor: pointer; margin-top: 5px;">新規追加</button>
            </form>
        </div>
    </div>

    <hr>

    <div style="display: flex; gap: 20px; flex-wrap: wrap;">

        <%
            java.util.List products = (java.util.List) request.getAttribute("productList");

            if (products != null) {
                for (Object obj : products) {
                    request.setAttribute("product", obj);
        %>

        <div style="border: 1px solid #ccc; padding: 15px; width: 180px; text-align: center; background-color: #ffffff;">

            <div style="width: 100%; height: 120px; display: flex; align-items: center; justify-content: center; margin-bottom: 10px;">
                <img src="${pageContext.request.contextPath}/images/${fn:escapeXml(product.imageUrl)}" alt="${fn:escapeXml(product.productName)}" style="max-width: 100%; max-height: 100%; object-fit: contain;">
            </div>

            <h4 style="margin: 10px 0 5px 0;"><c:out value="${product.productName}"/></h4>
            <p style="color: #ff0000; font-weight: bold; margin: 0 0 10px 0;">¥ ${product.price}-</p>

            <div style="${sessionScope.role == 'customer' ? 'display: block;' : 'display: none;'}">
                <form action="${pageContext.request.contextPath}/shop/cart" method="POST" style="margin:0;">
                    <input type="hidden" name="productId" value="${product.id}">
                    <button type="submit" style="padding: 5px 10px; cursor: pointer; background-color: #000000; color: #fff; border: none;">買い物かごに入れる</button>
                </form>
            </div>

            <div style="${sessionScope.role == 'owner' ? 'display: block;' : 'display: none;'}">
                <form action="${pageContext.request.contextPath}/owner/products" method="POST" enctype="multipart/form-data" style="margin: 10px 0 0 0; text-align: left; font-size: 12px; border-top: 1px dashed #ccc; padding-top: 10px;">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="productId" value="${product.id}">
                    商品名: <input type="text" name="productName" value="${fn:escapeXml(product.productName)}" style="width: 100%; box-sizing: border-box;"><br>
                    価格: <input type="number" name="price" value="${product.price}" style="width: 100%; box-sizing: border-box;"><br>
                    画像差替:<br>
                    <div style="width: 100%; overflow: hidden;">
                        <input type="file" name="productImage" accept="image/*" style="width: 100%; max-width: 100%; box-sizing: border-box;">
                    </div>
                    <button type="submit" style="padding: 4px 10px; cursor: pointer; background-color: #1d4ed8; color: #fff; border: none; font-weight: bold; margin-top: 5px;">この内容で更新</button>
                </form>
                <form action="${pageContext.request.contextPath}/owner/products" method="POST" style="margin: 8px 0 0 0;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="productId" value="${product.id}">
                    <button type="submit" style="padding: 5px 10px; cursor: pointer; background-color: #ff3333; color: #fff; border: none; font-weight: bold; width: 100%;">この商品をマスターから削除</button>
                </form>
            </div>
        </div>

        <%
                }
            } else {
        %>

            <p style="color: #666;">現在、登録されている商品はございません。上のフォームから追加してください！</p>
        <%
            }
        %>

    </div>

    <br><br>

    <p style="${sessionScope.role == 'owner' ? 'display: block;' : 'display: none;'}">
        <a href="${pageContext.request.contextPath}/owner/reports" style="color: #008000; font-weight: bold;">← 売上日報・総合ダッシュボード画面へ戻る</a>
    </p>

    <p><a href="${pageContext.request.contextPath}/logout" style="color: #666;">ログアウト</a></p>

</body>
</html>