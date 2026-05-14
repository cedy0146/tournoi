<%@ page language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/jsp/header.jsp" %>

<style>
    .page-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; border-bottom: 2px solid var(--border-blue); padding-bottom: 1rem; }
    .page-title { font-size: 2.5rem; color: var(--primary-blue); margin: 0; }
    .page-title span { color: var(--accent-blue); }
    .form-card { background: white; padding: 2.5rem; border-radius: 15px; box-shadow: 0 10px 25px rgba(30, 60, 114, 0.1); border: 1px solid var(--border-blue); }
    .form-label { display: block; font-weight: 700; color: var(--primary-blue); margin-bottom: 0.5rem; font-size: 1.1rem; }
    .form-control { width: 100%; padding: 0.8rem; border: 2px solid var(--border-blue); border-radius: 8px; font-family: 'Rajdhani', sans-serif; font-size: 1rem; color: var(--primary-blue); box-sizing: border-box; }
    .form-control:focus { outline: none; border-color: var(--accent-blue); box-shadow: 0 0 0 4px rgba(42, 82, 152, 0.1); }
    .btn-primary { background: var(--accent-blue); color: white; border: none; padding: 0.8rem 2rem; border-radius: 8px; font-weight: 700; cursor: pointer; transition: 0.3s; font-family: 'Rajdhani', sans-serif; font-size: 1.1rem; }
    .btn-primary:hover { background: var(--primary-blue); transform: translateY(-2px); box-shadow: 0 5px 15px rgba(30, 60, 114, 0.3); }
    .btn-outline { background: white; color: var(--accent-blue); border: 2px solid var(--accent-blue); padding: 0.8rem 2rem; border-radius: 8px; font-weight: 700; text-decoration: none; transition: 0.3s; display: inline-block; font-size: 1.1rem; }
    .btn-outline:hover { background: var(--light-blue); transform: translateY(-2px); }
    .container { max-width: 800px; margin: 2rem auto; }
</style>

<div class="container">
    <div class="page-header">
        <h1 class="page-title">
            <c:choose>
                <c:when test="${not empty tournoi}">Modifier le <span>Tournoi</span></c:when>
                <c:otherwise>Nouveau <span>Tournoi</span></c:otherwise>
            </c:choose>
        </h1>
        <a href="${pageContext.request.contextPath}/tournois?action=list" class="btn btn-outline">&#8592; Retour</a>
    </div>

    <div class="form-card">
        <form action="${pageContext.request.contextPath}/tournois" method="post">
            <input type="hidden" name="action" value="save"/>
            <c:if test="${not empty tournoi}">
                <input type="hidden" name="id"     value="${tournoi.id}"/>
                <input type="hidden" name="statut" value="${tournoi.statut}"/>
            </c:if>

            <div class="form-group">
                <label class="form-label">Nom du tournoi *</label>
                <input type="text" name="nom" class="form-control"
                       value="<c:out value='${tournoi.nom}'/>"
                       placeholder="Ex: Coupe de Printemps 2025" required/>
            </div>

            <div class="form-group">
                <label class="form-label">Type de tournoi *</label>
                <select name="type" class="form-control" required>
                    <option value="">-- Choisir un type --</option>
                    <option value="CHAMPIONNAT"
                        <c:if test="${not empty tournoi && tournoi.championnat}">selected</c:if>>
                        &#127885; Championnat (aller-retour)
                    </option>
                    <option value="ELIMINATION_DIRECTE"
                        <c:if test="${not empty tournoi && tournoi.eliminationDirecte}">selected</c:if>>
                        &#129354; Elimination Directe
                    </option>
                </select>
            </div>

            <div class="form-group">
                <label class="form-label">Date de debut</label>
                <input type="date" name="dateDebut" class="form-control"
                    <c:if test="${not empty tournoi && not empty tournoi.dateDebut}">
                        value="<fmt:formatDate value='${tournoi.dateDebut}' pattern='yyyy-MM-dd'/>"
                    </c:if>
                />
            </div>

            <div class="form-group">
                <label class="form-label">Date de fin</label>
                <input type="date" name="dateFin" class="form-control"
                    <c:if test="${not empty tournoi && not empty tournoi.dateFin}">
                        value="<fmt:formatDate value='${tournoi.dateFin}' pattern='yyyy-MM-dd'/>"
                    </c:if>
                />
            </div>

            <div style="display:flex;gap:1rem;margin-top:2rem;">
                <button type="submit" class="btn btn-primary">&#128190; Enregistrer</button>
                <a href="${pageContext.request.contextPath}/tournois?action=list" class="btn btn-outline">Annuler</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>
