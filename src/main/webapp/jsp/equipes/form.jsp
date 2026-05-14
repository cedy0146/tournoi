<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/jsp/header.jsp" %>

<div class="container">
    <div class="page-header">
        <h1 class="page-title">
            <c:choose>
                <c:when test="${not empty equipe}">Modifier l'<span>Équipe</span></c:when>
                <c:otherwise>Nouvelle <span>Équipe</span></c:otherwise>
            </c:choose>
        </h1>
        <a href="${pageContext.request.contextPath}/equipes?action=list" class="btn btn-outline">← Retour</a>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/equipes" method="post">
            <c:if test="${not empty equipe}">
                <input type="hidden" name="id" value="${equipe.id}">
            </c:if>

            <div class="form-group">
                <label class="form-label">Nom de l'équipe</label>
                <input type="text" name="nom" class="form-control"
                       value="${equipe.nom}" placeholder="Ex: Lions FC" required>
            </div>

            <div class="form-group">
                <label class="form-label">Ville</label>
                <input type="text" name="ville" class="form-control"
                       value="${equipe.ville}" placeholder="Ex: Casablanca">
            </div>

            <div class="form-group">
                <label class="form-label">URL du Logo (optionnel)</label>
                <input type="text" name="logoUrl" class="form-control"
                       value="${equipe.logoUrl}" placeholder="https://...">
            </div>

            <div style="display:flex;gap:1rem;margin-top:2rem;">
                <button type="submit" class="btn btn-primary">💾 Enregistrer</button>
                <a href="${pageContext.request.contextPath}/equipes?action=list" class="btn btn-outline">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
