<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ include file="/jsp/header.jsp" %>

<div class="container">

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success">&#9989; Operation effectuee avec succes !</div>
    </c:if>

    <div class="hero-section">
        <div style="font-family:'Bebas Neue',cursive;font-size:3rem;letter-spacing:4px;">
            &#127942; Gestion des <span style="color:var(--vert)">Tournois</span>
        </div>
        <p style="color:#9ca3af;margin-top:0.5rem;font-size:1.1rem;">
            Creez et gerez vos tournois. Generation automatique du calendrier incluse.
        </p>
        <div class="stats-grid">
            <div class="stat-box">
                <div class="stat-value">${tournois.size()}</div>
                <div class="stat-label">Tournois</div>
            </div>
        </div>
    </div>

    <div class="page-header">
        <h1 class="page-title">Tous les <span>Tournois</span></h1>
        <a href="${pageContext.request.contextPath}/tournois?action=create" class="btn btn-primary">
            + Nouveau Tournoi
        </a>
    </div>

    <c:choose>
        <c:when test="${empty tournois}">
            <div style="text-align:center;padding:4rem;color:#6b7280;">
                <div style="font-size:4rem;">&#127951;</div>
                <p style="font-size:1.2rem;margin-top:1rem;">Aucun tournoi pour l'instant.</p>
                <a href="${pageContext.request.contextPath}/tournois?action=create"
                   class="btn btn-primary" style="margin-top:1rem;">
                    Creer le premier tournoi
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card-grid">
                <c:forEach var="t" items="${tournois}">
                    <div class="card">
                        <div style="display:flex;justify-content:space-between;align-items:flex-start;margin-bottom:0.75rem;">
                            <span class="card-title"><c:out value="${t.nom}"/></span>
                            <c:choose>
                                <c:when test="${t.enAttente}">
                                    <span class="badge badge-yellow">En attente</span>
                                </c:when>
                                <c:when test="${t.enCours}">
                                    <span class="badge badge-green">En cours</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-blue">Termine</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-meta">
                            <c:choose>
                                <c:when test="${t.eliminationDirecte}">
                                    &#129354; Elimination Directe
                                </c:when>
                                <c:otherwise>
                                    &#127885; Championnat
                                </c:otherwise>
                            </c:choose>
                            <c:if test="${not empty t.dateDebut}">
                                &nbsp;·&nbsp;
                                <fmt:formatDate value="${t.dateDebut}" pattern="dd/MM/yyyy"/>
                            </c:if>
                        </div>
                        <div style="display:flex;gap:0.5rem;flex-wrap:wrap;margin-top:1rem;">
                            <a href="${pageContext.request.contextPath}/tournois?action=view&id=${t.id}"
                               class="btn btn-outline btn-sm">Voir</a>
                            <a href="${pageContext.request.contextPath}/tournois?action=edit&id=${t.id}"
                               class="btn btn-sm" style="border:2px solid #6b7280;color:#9ca3af;">Modifier</a>
                            <a href="${pageContext.request.contextPath}/tournois?action=delete&id=${t.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Supprimer ce tournoi ?')">Supprimer</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
