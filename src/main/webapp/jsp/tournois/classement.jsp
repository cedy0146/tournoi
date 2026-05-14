<%@ page language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="/jsp/header.jsp" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Classement - ${tournoi.nom}</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sport.css">
    <style>
        body { font-family: 'Rajdhani', sans-serif; background-color: #f0f7ff; color: #5db2e4ff; margin: 0; padding: 20px; }
        .container { 
            max-width: 1100px; margin: 2rem auto; background: #fff; padding: 2.5rem; 
            border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); 
        }
        .hero-section {
            background: linear-gradient(135deg, #326bd4ff 0%, #2d70e2ff 100%);
            color: white; padding: 3rem; border-radius: 15px; text-align: center; margin-bottom: 2.5rem;
            box-shadow: 0 8px 20px rgba(30, 60, 114, 0.2);
        }
        .hero-title { font-family: 'Bebas Neue', cursive; font-size: 4rem; margin: 0; letter-spacing: 3px; }
        .hero-subtitle { font-size: 1.2rem; text-transform: uppercase; font-weight: 500; opacity: 0.9; margin-top: 0.5rem; }

        .table-sport { width: 100%; border-collapse: separate; border-spacing: 0 12px; margin-top: 1rem; }
        .table-sport th { 
            padding: 1.2rem; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1.5px;
            color: #2a5298; border-bottom: 2px solid #bfdbfe; cursor: pointer; transition: 0.3s;
        }
        .table-sport th:hover { color: #2a5298; }
        .table-sport td { 
            padding: 1.2rem; background: #ffffff; border-top: 1px solid #f0f0f0; border-bottom: 1px solid #f0f0f0;
            font-size: 1.1rem; font-weight: 600; transition: 0.3s; text-align: center;
        }
        .table-sport tr td:first-child { border-left: 1px solid #f0f0f0; border-radius: 12px 0 0 12px; }
        .table-sport tr td:last-child { border-right: 1px solid #f0f0f0; border-radius: 0 12px 12px 0; }
        .table-sport tr:hover td { transform: translateY(-2px); background: #f8fbff; border-color: #2a5298; box-shadow: 0 4px 10px rgba(0,0,0,0.05); }

        .pos-cell { color: #60a5fa; width: 60px; font-size: 1.3rem; }
        .team-cell { text-align: left !important; color: #2a5298; font-size: 1.2rem; }
        .points-cell { background: #f0f4ff !important; color: #2a5298 !important; font-size: 1.4rem !important; font-weight: 800 !important; }
        
        .diff-pos { color: #28a745; }
        .diff-neg { color: #dc3545; }
        
        .empty-card { text-align: center; padding: 5rem; background: #f0f7ff; border-radius: 15px; color: #2a5298; border: 2px dashed #bfdbfe; }
        .back-link { display: inline-block; margin-top: 2rem; color: #2a5298; text-decoration: none; font-weight: 600; transition: 0.3s; }
        .back-link:hover { color: #6d9df0ff; transform: translateX(-5px); }
        .nav-link { text-decoration: none; color: #2a5298; opacity: 0.7; font-weight: 700; padding: 1rem 0; font-size: 1.1rem; letter-spacing: 1px; border-bottom: 3px solid transparent; transition: 0.3s; }
        .nav-link.active { color: #2a5298; border-bottom: 3px solid #2a5298; }
    </style>
</head>
<body>
<div class="container">
    <div class="hero-section">
        <h1 class="hero-title">${tournoi.nom}</h1>
        <div class="hero-subtitle">${tournoi.typeLabel} • ${tournoi.statutLabel}</div>
    </div>

    <div class="navbar" style="background: transparent; box-shadow: none; border-bottom: 2px solid #e9ecef; margin-bottom: 2.5rem; height: auto; padding: 0;">
        <div class="navbar-nav" style="display: flex; gap: 2.5rem;">
            <a href="tournois?action=view&id=${tournoi.id}&tab=equipes" class="nav-link">Equipes</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=calendrier" class="nav-link">Calendrier</a>
            <a href="tournois?action=view&id=${tournoi.id}&tab=classement" class="nav-link active">Classement</a>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty classement}">
            <div class="empty-card">
                <p>Le classement n'est pas encore disponible pour ce tournoi.</p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="table-sport" id="classementTable">
                <thead>
                    <tr>
                        <th onclick="sortTable(0)">#</th>
                        <th onclick="sortTable(1)" style="text-align:left;">Équipe</th>
                        <th onclick="sortTable(2)">MJ</th>
                        <th onclick="sortTable(3)">V</th>
                        <th onclick="sortTable(4)">N</th>
                        <th onclick="sortTable(5)">D</th>
                        <th onclick="sortTable(6)">BP</th>
                        <th onclick="sortTable(7)">BC</th>
                        <th onclick="sortTable(8)">Diff</th>
                        <th onclick="sortTable(9)">Pts</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="c" items="${classement}" varStatus="status">
                        <tr>
                            <td class="pos-cell">${status.index + 1}</td>
                            <td class="team-cell">${c.equipe.nom}</td>
                            <td>${c.matchsJoues}</td>
                            <td>${c.victoires}</td>
                            <td>${c.nuls}</td>
                            <td>${c.defaites}</td>
                            <td>${c.butsPour}</td>
                            <td>${c.butsContre}</td>
                            <td class="${c.differenceButs >= 0 ? 'diff-pos' : 'diff-neg'}">
                                ${c.differenceButs > 0 ? '+' : ''}${c.differenceButs}
                            </td>
                            <td class="points-cell">${c.points}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

    <a href="tournois?action=list" class="back-link">&larr; Retour aux tournois</a>
</div>

<script>
function sortTable(n) {
    const table = document.getElementById("classementTable");
    let rows, switching, i, x, y, shouldSwitch, dir, switchcount = 0;
    switching = true;
    dir = "desc"; 
    
    while (switching) {
        switching = false;
        rows = table.rows;
        for (i = 1; i < (rows.length - 1); i++) {
            shouldSwitch = false;
            x = rows[i].getElementsByTagName("TD")[n];
            y = rows[i + 1].getElementsByTagName("TD")[n];
            
            let xVal = isNaN(parseFloat(x.innerText)) ? x.innerText.toLowerCase() : parseFloat(x.innerText);
            let yVal = isNaN(parseFloat(y.innerText)) ? y.innerText.toLowerCase() : parseFloat(y.innerText);

            if (dir == "asc") {
                if (xVal > yVal) { shouldSwitch = true; break; }
            } else if (dir == "desc") {
                if (xVal < yVal) { shouldSwitch = true; break; }
            }
        }
        if (shouldSwitch) {
            rows[i].parentNode.insertBefore(rows[i + 1], rows[i]);
            switching = true;
            switchcount ++;      
        } else {
            if (switchcount == 0 && dir == "desc") { dir = "asc"; switching = true; }
        }
    }
    
    const headers = table.querySelectorAll("th");
    headers.forEach(h => h.classList.remove("sort-asc", "sort-desc"));
    headers[n].classList.add(dir === "asc" ? "sort-asc" : "sort-desc");
}
</script>

</body>
</html>