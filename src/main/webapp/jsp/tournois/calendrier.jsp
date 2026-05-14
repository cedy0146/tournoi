<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="/jsp/header.jsp" %>

<style>
    body { background-color: #f0f7ff; }
    .hero-section {
        background: linear-gradient(135deg, #3c77e4ff 0%, #3b78e2ff 100%);
        color: white; padding: 3rem; border-radius: 15px; text-align: center; margin-bottom: 2.5rem;
    }
    .hero-title { font-family: 'Bebas Neue', cursive; font-size: 4rem; margin: 0; letter-spacing: 3px; }
    .hero-subtitle { font-size: 1.2rem; text-transform: uppercase; opacity: 0.9; }

    .nav-link { text-decoration: none; color: #2862c5ff; opacity: 0.7; font-weight: 700; padding: 1rem 0; font-size: 1.1rem; border-bottom: 3px solid transparent; transition: 0.3s; }
    .nav-link.active { color: #2a5298; border-bottom: 3px solid #498bfcff; }

    .journee-header { 
        background: #2a5298; color: white; padding: 10px 25px; border-radius: 8px; 
        margin-top: 2.5rem; font-family: 'Bebas Neue'; font-size: 1.5rem; letter-spacing: 1px;
    }
    .match-card { 
        display: grid; grid-template-columns: 150px 1fr 120px; align-items: center; 
        padding: 1.5rem; background: white; margin-top: 10px; border-radius: 10px;
        box-shadow: 0 2px 5px rgba(30, 60, 114, 0.1);
    }
    .match-date { color: #60a5fa; font-weight: 600; font-size: 0.9rem; }
    .match-main { display: flex; align-items: center; justify-content: center; gap: 1.5rem; }
    .team-name { flex: 1; font-weight: 700; font-size: 1.2rem; color: #4888ffff; }
    .team-left { text-align: right; }
    .team-right { text-align: left; }
    .score-pill { 
        background: #f0f4ff; color: #468affff; padding: 8px 20px; border-radius: 30px; 
        font-weight: 800; font-size: 1.4rem; min-width: 60px; text-align: center; border: 1px solid #d0d9ff;
    }
    .vs-label { font-family: 'Bebas Neue'; color: #bfdbfe; font-size: 1.5rem; }
    
    .btn-action { background: #4b8dffff; color: white; text-decoration: none; padding: 8px 15px; border-radius: 6px; font-weight: 600; font-size: 0.9rem; transition: 0.3s; }
    .btn-action:hover { background: #3d7cf0ff; transform: scale(1.05); }
    .btn-generate { background: #28a745; color: white; border: none; padding: 1rem 2rem; border-radius: 8px; cursor: pointer; font-weight: bold; font-family: 'Rajdhani'; font-size: 1.2rem; }
</style>

<div class="container">
    <div class="hero-section">
        <h1 class="hero-title">${tournoi.nom}</h1>
        <div class="hero-subtitle">${tournoi.typeLabel} • ${tournoi.statutLabel}</div>
    </div>

    <div class="navbar" style="background: transparent; box-shadow: none; border-bottom: 2px solid #e9ecef; margin-bottom: 2rem; height: auto; padding: 0;">
        <div class="navbar-nav" style="display: flex; gap: 2.5rem;">
            <a href="tournois?action=view&id=${tournoi.id}&tab=equipes" class="nav-link">Equipes</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=calendrier" class="nav-link active">Calendrier</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=classement" class="nav-link">Classement</a>
        </div>
    </div>

    <c:if test="${param.msg == 'calendrier_genere'}">
        <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            ✅ Le calendrier a ete genere  automatiquement pour ce tournoi.
        </div>
    </c:if>

    <c:if test="${param.msg == 'score_enregistre'}">
        <div style="background: #d4edda; color: #155724; padding: 15px; border-radius: 8px; margin-bottom: 20px;">
            ✅ Le score a ete enregistre et le classement mis a jour.
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty matchs}">
            <div style="text-align:center; padding: 4rem; background: white; border-radius: 15px;">
                <p>Aucun match n'a ete genere pour le moment.</p>
                <c:if test="${tournoi.enAttente}">
                    <form action="tournois" method="get">
                        <input type="hidden" name="action" value="generer">
                        <input type="hidden" name="id" value="${tournoi.id}">
                        <button type="submit" class="btn-generate">Generer le calendrier</button>
                    </form>
                </c:if>
            </div>
        </c:when>
        <c:otherwise>
            <c:set var="lastJournee" value="-1" />
            <c:forEach var="m" items="${matchs}">
                <c:if test="${m.journee != lastJournee}">
                    <div class="journee-header">Journee ${m.journee}</div>
                    <c:set var="lastJournee" value="${m.journee}" />
                </c:if>
                
                <div class="match-card">
                    <div class="match-date">
                        <fmt:formatDate value="${m.dateMatch}" pattern="dd/MM/yyyy HH:mm" />
                    </div>
                    <div class="match-main">
                        <span class="team-name team-left">
                            ${m.equipe1.nom}
                        </span>
                        <c:choose>
                            <c:when test="${m.joue}">
                                <div class="score-pill">${m.scoreEquipe1} - ${m.scoreEquipe2}</div>
                            </c:when>
                            <c:otherwise>
                                <span class="vs-label">VS</span>
                            </c:otherwise>
                        </c:choose>
                        <span class="team-name team-right">
                            ${m.equipe2.nom}
                        </span>
                    </div>
                    <div style="text-align: right;">
                        <c:if test="${!m.joue}">
                            <a href="matchs?action=score&id=${m.id}&idTournoi=${tournoi.id}" class="btn-action">Saisir score</a>
                        </c:if>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>

    <a href="tournois?action=list" style="display:inline-block; margin-top: 2rem; color: var(--accent-blue); text-decoration: none; font-weight: 600;">&larr; Retour aux tournois</a>
</div>
</body>