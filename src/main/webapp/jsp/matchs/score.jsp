<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Saisir Score - ${match.equipe1.nom} vs ${match.equipe2.nom}</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f7f9; color: #333; margin: 0; padding: 20px; }
        .container { max-width: 600px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.05); }
        h1 { color: #0056b3; margin-bottom: 20px; text-align: center; }
        .match-details { text-align: center; margin-bottom: 30px; }
        .match-details p { margin: 5px 0; color: #6c757d; }
        .match-teams { display: flex; justify-content: center; align-items: center; gap: 20px; margin-bottom: 30px; }
        .team-info { text-align: center; font-weight: bold; font-size: 1.2em; color: #333; }
        .vs-text { font-size: 1.5em; font-weight: bold; color: #adb5bd; }

        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; margin-bottom: 8px; font-weight: 600; color: #495057; }
        .form-control { width: 100%; padding: 12px; border: 1px solid #ced4da; border-radius: 8px; font-size: 1em; box-sizing: border-box; }
        .form-control:focus { border-color: #007bff; outline: none; box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25); }

        .form-actions { display: flex; justify-content: space-between; gap: 15px; margin-top: 30px; }
        .btn { padding: 12px 25px; border-radius: 8px; cursor: pointer; font-weight: bold; text-decoration: none; transition: background-color 0.2s, color 0.2s; }
        .btn-primary { background-color: #007bff; color: white; border: none; }
        .btn-primary:hover { background-color: #0056b3; }
        .btn-secondary { background-color: #6c757d; color: white; border: none; }
        .btn-secondary:hover { background-color: #5a6268; }
        .btn-danger { background-color: #dc3545; color: white; border: none; }
        .btn-danger:hover { background-color: #c82333; }

        .alert { padding: 15px; margin-bottom: 20px; border-radius: 8px; font-weight: 500; }
        .alert-danger { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
    </style>
</head>
<body>

<div class="container">
    <h1>Saisir le Score du Match</h1>

    <!-- Conteneur pour les erreurs de validation JavaScript -->
    <div id="jsValidationAlert" class="alert alert-danger" style="display: none;"></div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <div class="match-details">
        <p>Tournoi : <strong>${tournoi.nom}</strong></p>
        <p>Journée : <strong>${match.journee}</strong> - Date : <strong><fmt:formatDate value="${match.dateMatch}" pattern="dd/MM/yyyy HH:mm" /></strong></p>
    </div>

    <div class="match-teams">
        <div class="team-info">
            ${match.equipe1.nom}
        </div>
        <span class="vs-text">VS</span>
        <div class="team-info">
            ${match.equipe2.nom}
        </div>
    </div>

    <c:choose>
        <c:when test="${match.joue}">
            <div style="text-align: center; padding: 20px; background-color: #e9f7ef; border-radius: 8px; color: #28a745; font-weight: bold;">
                Ce match a déjà été joué. Score final : ${match.scoreEquipe1} - ${match.scoreEquipe2}
            </div>
        </c:when>
        <c:otherwise>
            <form id="scoreForm" action="${pageContext.request.contextPath}/matchs" method="post">
                <input type="hidden" name="action" value="saveScore">
                <input type="hidden" name="idMatch" value="${match.id}">
                <input type="hidden" name="idTournoi" value="${tournoi.id}">

                <div class="form-group">
                    <label for="scoreEquipe1">Score ${match.equipe1.nom} :</label>
                    <input type="number" id="scoreEquipe1" name="scoreEquipe1" class="form-control" min="0" required>
                </div>

                <div class="form-group">
                    <label for="scoreEquipe2">Score ${match.equipe2.nom} :</label>
                    <input type="number" id="scoreEquipe2" name="scoreEquipe2" class="form-control" min="0" required>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Enregistrer le score</button>
                    <a href="${pageContext.request.contextPath}/tournois?action=view&id=${tournoi.id}&tab=calendrier" class="btn btn-secondary">Annuler</a>
                </div>
            </form>
        </c:otherwise>
    </c:choose>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('scoreForm');
    const errorDiv = document.getElementById('jsValidationAlert');

    if (form) {
        form.addEventListener('submit', function(event) {
            const score1 = parseInt(document.getElementById('scoreEquipe1').value, 10);
            const score2 = parseInt(document.getElementById('scoreEquipe2').value, 10);

            // Vérification : les scores ne doivent pas être NaN et doivent être >= 0
            if (isNaN(score1) || isNaN(score2) || score1 < 0 || score2 < 0) {
                event.preventDefault(); // Empêche l'envoi du formulaire
                errorDiv.textContent = "Attention : Les scores doivent être des nombres entiers positifs ou nuls.";
                errorDiv.style.display = 'block';
                window.scrollTo({ top: 0, behavior: 'smooth' });
            } else {
                errorDiv.style.display = 'none';
            }
        });
    }
});
</script>

</body>
</html>