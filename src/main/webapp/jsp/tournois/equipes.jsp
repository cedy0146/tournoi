<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/jsp/header.jsp" %>

<style>
    body { background-color: #f0f7ff; }
    .hero-section {
        background: linear-gradient(135deg, #3971daff 0%, #2a63c5ff 100%);
        color: white; padding: 3rem; border-radius: 15px; text-align: center; margin-bottom: 2.5rem;
    }
    .hero-title { font-family: 'Bebas Neue', cursive; font-size: 4rem; margin: 0; letter-spacing: 3px; }
    .hero-subtitle { font-size: 1.2rem; text-transform: uppercase; opacity: 0.9; }

    .nav-link { text-decoration: none; color: #2b64c7ff; opacity: 0.7; font-weight: 700; padding: 1rem 0; font-size: 1.1rem; border-bottom: 3px solid transparent; transition: 0.3s; }
    .nav-link.active { color: #2a5298; border-bottom: 3px solid #316bceff; }

    .section-title { font-family: 'Bebas Neue', cursive; font-size: 2.5rem; color: #3e73d4ff; margin: 2rem 0 1.5rem; letter-spacing: 1px; }
    
    .team-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 1.5rem; }
    .team-card { 
        background: white; padding: 1.5rem; border-radius: 12px; border-left: 5px solid #2a5298;
        display: flex; justify-content: space-between; align-items: center;
        box-shadow: 0 4px 6px rgba(30, 60, 114, 0.1); transition: 0.3s;
    }
    .team-card:hover { transform: translateY(-5px); box-shadow: 0 8px 15px rgba(0,0,0,0.1); }
    .team-name { font-size: 1.25rem; font-weight: 700; color: #2a60bdff; display: block; }
    .team-city { color: #265ab4ff; opacity: 0.6; font-size: 0.95rem; text-transform: uppercase; letter-spacing: 1px; }

    .btn-remove { background: #fff1f1; color: #dc3545; border: 1px solid #ffcccc; padding: 8px 15px; border-radius: 6px; cursor: pointer; font-weight: 600; transition: 0.3s; }
    .btn-remove:hover { background: #dc3545; color: white; }

    .registration-box { 
        background: #f8fbff; padding: 2rem; border-radius: 15px; margin-top: 3rem; 
        border: 2px dashed #5e99ffff;
    }
    .form-control { width: 100%; padding: 12px; border: 2px solid #bfdbfe; border-radius: 8px; font-family: 'Rajdhani'; font-size: 1.1rem; color: #1e3c72; }
    .btn-submit { 
        background: #4c8effff; color: white; border: none; padding: 12px 25px; border-radius: 8px; 
        cursor: pointer; font-weight: bold; width: 100%; font-size: 1.1rem; transition: 0.3s;
    }
    .btn-submit:hover { background: #1e3c72; box-shadow: 0 4px 12px rgba(30, 60, 114, 0.3); }
    .back-link { display: inline-block; margin-top: 2rem; color: #5493ffff; text-decoration: none; font-weight: 600; }
</style>

<div class="container">
    <div class="hero-section">
        <h1 class="hero-title">${tournoi.nom}</h1>
        <div class="hero-subtitle">${tournoi.typeLabel} • ${tournoi.statutLabel}</div>
    </div>

    <div class="navbar" style="background: transparent; box-shadow: none; border-bottom: 2px solid #e9ecef; margin-bottom: 2rem; height: auto; padding: 0;">
        <div class="navbar-nav" style="display: flex; gap: 2.5rem;">
            <a href="tournois?action=view&id=${tournoi.id}&tab=equipes" class="nav-link active">Equipes</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=calendrier" class="nav-link">Calendrier</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=classement" class="nav-link">Classement</a>
        </div>
    </div>

    <h2 class="section-title">Equipes inscrites <span style="color: var(--accent-blue); opacity: 0.5;">(${tournoi.equipes.size()})</span></h2>
    
    <c:choose>
        <c:when test="${empty tournoi.equipes}">
            <div style="text-align: center; padding: 3rem; background: #fff; border-radius: 12px; color: #6c757d;">
                <p>Aucune equipe n'est encore inscrite a ce tournoi.</p>
            </div>
        </c:when>
        <c:otherwise>
            <div class="team-grid">
                <c:forEach var="equipe" items="${tournoi.equipes}">
                    <div class="team-card">
                        <div>
                            <span class="team-name">${equipe.nom}</span>
                            <span class="team-city">${equipe.ville}</span>
                        </div>
                        <c:if test="${tournoi.enAttente}">
                            <form action="tournois" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="desinscrire">
                                <input type="hidden" name="idTournoi" value="${tournoi.id}">
                                <input type="hidden" name="idEquipe" value="${equipe.id}">
                                <button type="submit" class="btn-remove" onclick="return confirm('Désinscrire ${equipe.nom} ?')">✕</button>
                            </form>
                        </c:if>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

    <c:if test="${tournoi.enAttente}">
        <div class="registration-box">
            <h3 style="margin-top:0; font-family: 'Bebas Neue'; font-size: 2rem; color: #2a5298;">Inscrire une nouvelle equipe</h3>
            <form action="tournois" method="post">
                <input type="hidden" name="action" value="inscrire">
                <input type="hidden" name="idTournoi" value="${tournoi.id}">
                <div style="margin-bottom: 1.5rem;">
                    <select name="idEquipe" class="form-control" required>
                        <option value="">-- Selectionner une equipe --</option>
                        <c:forEach var="te" items="${toutesEquipes}">
                            <option value="${te.id}">${te.nom} (${te.ville})</option>
                        </c:forEach>
                    </select>
                </div>
                <button type="submit" class="btn-submit">Valider l'inscription</button>
            </form>
        </div>
    </c:if>

    <a href="tournois?action=list" class="back-link">&larr; Retour à la liste des tournois</a>
</div>
</body>