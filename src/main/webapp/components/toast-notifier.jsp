<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- 
    Common Toast Notifier
    Checks for various session messages and displays them as Bootstrap Toasts.
--%>

<div class="toast-container p-3">
    <%-- 1. Order Messages (format "type:message") --%>
    <c:if test="${not empty sessionScope.orderMsg}">
        <c:set var="parts" value="${fn:split(sessionScope.orderMsg, ':')}" />
        <c:set var="type"  value="${parts[0] == 'success' ? 'success' : 'danger'}" />
        <c:set var="msg"   value="${fn:substringAfter(sessionScope.orderMsg, ':')}" />
        
        <div class="toast align-items-center text-white bg-${type} border-0" role="alert" aria-live="assertive" aria-atomic="true" id="orderToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas ${type == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
                    ${msg}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="orderMsg" scope="session" />
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const toastEl = document.getElementById('orderToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 5000 });
                toast.show();
            });
        </script>
    </c:if>

    <%-- 2. Cart Messages --%>
    <c:if test="${not empty sessionScope.cartMsg}">
        <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true" id="cartToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-shopping-basket me-2"></i>
                    ${sessionScope.cartMsg}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="cartMsg" scope="session" />
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const toastEl = document.getElementById('cartToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
                toast.show();
            });
        </script>
    </c:if>

    <%-- 3. Voucher Messages (format "type:message") --%>
    <c:if test="${not empty sessionScope.voucherMsg}">
        <c:set var="vType" value="${fn:startsWith(sessionScope.voucherMsg, 'success') ? 'success' : 'danger'}" />
        <c:set var="vMsg"  value="${fn:substringAfter(sessionScope.voucherMsg, ':')}" />
        
        <div class="toast align-items-center text-white bg-${vType} border-0" role="alert" aria-live="assertive" aria-atomic="true" id="voucherToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-ticket-alt me-2"></i>
                    ${vMsg}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="voucherMsg" scope="session" />
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const toastEl = document.getElementById('voucherToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 4000 });
                toast.show();
            });
        </script>
    </c:if>
    <%-- 4. Checkout Errors --%>
    <c:if test="${not empty sessionScope.checkoutError}">
        <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true" id="checkoutToast">
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${sessionScope.checkoutError}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        </div>
        <c:remove var="checkoutError" scope="session" />
        <script>
            document.addEventListener("DOMContentLoaded", function() {
                const toastEl = document.getElementById('checkoutToast');
                const toast = new bootstrap.Toast(toastEl, { delay: 6000 });
                toast.show();
            });
        </script>
    </c:if>
</div>
