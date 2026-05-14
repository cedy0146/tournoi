<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="/jsp/header.jsp" %>

<div class="container">
    <div style="text-align:center;padding:4rem;">
        <div style="font-size:5rem;">⚠️</div>
        <h1 style="font-family:'Bebas Neue',cursive;font-size:2.5rem;color:var(--rouge);margin:1rem 0;">
            Une erreur est survenue
        </h1>
        <div class="alert alert-danger" style="max-width:500px;margin:1rem auto;">
            ${error}
        </div>
        <a href="${pageContext.request.contextPath}/tournois" class="btn btn-primary" style="margin-top:1rem;">
            ← Retour à l'accueil
        </a>
    </div>
</div>
</body>
</html>
