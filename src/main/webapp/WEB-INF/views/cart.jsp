<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.time.LocalDate" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title> ショッピングカート・お会計レジ精算画面</title>
</head>
<body style="background-color: #f8fafc; color: #334155; font-family: sans-serif; padding: 20px;">

    <h2 style="color: #16a34a;"> あなたのショッピングカート・精算窓口</h2>
   
    <p><a href="${pageContext.request.contextPath}/shop/products" style="font-weight: bold; color: #16a34a; text-decoration: none;">⬅ 🛒 お買い物を続ける（商品カタログへ戻る）</a></p>
    <hr>

   
    <% if (request.getAttribute("successMessage") != null) { %>
        <p style="color: #16a34a; font-weight: bold; background-color: #dcfce7; padding: 10px; border-left: 5px solid #16a34a;"> <c:out value="${successMessage}"/></p>
    <% } %>

   
    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color: #b91c1c; font-weight: bold; background-color: #fee2e2; padding: 10px; border-left: 5px solid #b91c1c;"> <c:out value="${errorMessage}"/></p>
    <% } %>

    <div style="width: 800px; background-color: #ffffff; padding: 20px; border-radius: 6px; border: 1px solid #e2e8f0; margin-top: 20px;">
        <h3 style="margin-top: 0; color: #1e293b;">📋 カゴに投入されている精算対象商品一覧</h3>
        
        <table border="1" cellpadding="8" style="border-collapse: collapse; width: 100%; text-align: center; border-color: #cbd5e1;">
            <tr style="background-color: #f1f5f9; color: #1e293b;">
                <th>画像</th><th>商品名</th><th>単価</th><th>数量</th><th>小計</th>
            </tr>
            
            <%
              
                java.util.List cartProducts = (java.util.List) request.getAttribute("productList");
                
                if (cartProducts != null && !cartProducts.isEmpty()) {
                    for (Object obj : cartProducts) {
                        request.setAttribute("item", obj);
            %>
            
            
            <tr style="line-height: 1.8;">
             
                <td>
                    <img src="${pageContext.request.contextPath}/images/${fn:escapeXml(item.imageUrl)}" alt="商品画像" style="width: 50px; height: 40px; object-fit: cover;">
                </td>
                <td style="font-weight: bold;"> <c:out value="${item.productName}"/></td>
                <td>¥ ${item.price}</td>
                <td>1 個</td>
                <td style="font-weight: bold; color: #b91c1c;">¥ ${item.price}</td>
            </tr>
            
            <%
                    }
                } else {
            %>
            <tr style="line-height: 1.8;">
                <td colspan="5" style="text-align: center; color: #64748b; padding: 15px; background-color: #f8fafc;">現在、買い物カゴの中身は空っぽです。</td>
            </tr>
            <%
                }
            %>
        </table>

      
        <div style="background-color: #f8fafc; border: 1px solid #cbd5e1; padding: 15px; margin-top: 20px; border-radius: 4px;">
            <h4 style="margin-top: 0; color: #1e293b; border-bottom: 1px solid #cbd5e1; padding-bottom: 5px;">🚚 今回の自社定期便・お届け先配送情報（身元固定）</h4>
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
            
           
            <div style="margin-top: 15px; padding-top: 10px; border-top: 1px dashed #cbd5e1;">
                <label for="deliveryDate" style="font-weight: bold; color: #1e293b;">📅 お届け希望日を選択してください：</label><br>
                <input type="date" id="deliveryDate" name="deliveryDate" form="checkoutForm"
                    min="<%= LocalDate.now() %>" value="<%= LocalDate.now() %>" required
                    style="margin-top: 8px; padding: 6px 10px; font-size: 14px; border: 1px solid #cbd5e1; border-radius: 4px;">
            </div>

        </div>

      
        <div style="margin-top: 25px; text-align: right; border-top: 2px dashed #cbd5e1; padding-top: 15px;">
           
            <span style="font-size: 16px; font-weight: bold; color: #475569; margin-right: 20px;">
                精算対象: ${itemCount}品
            </span>
            <span style="font-size: 22px; font-weight: bold; color: #b91c1c;">
                総合決済金額: ¥ ${totalAmount}-
            </span>
            
            <form id="checkoutForm" action="${pageContext.request.contextPath}/customer/checkout" method="POST" style="margin-top: 15px;">
                <input type="hidden" name="action" value="executePurchase">
                <button type="submit" style="background-color: #b91c1c; color: #ffffff; border: none; padding: 10px 30px; font-size: 18px; font-weight: bold; border-radius: 4px; cursor: pointer; box-shadow: 0 2px 4px rgba(0,0,0,0.1);">💳 この内容で決済を確定して自社便配送を依頼する</button>
            </form> 
        </div>
    </div>

</body>
</html>