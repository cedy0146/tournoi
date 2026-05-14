<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TournoiSport</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sport.css">
    <link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&family=Rajdhani:wght@500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-blue: #1e3c72;
            --accent-blue: #2a5298;
            --light-blue: #f0f7ff;
            --border-blue: #bfdbfe;
        }
        body { font-family: 'Rajdhani', sans-serif; background-color: var(--light-blue); color: var(--primary-blue); }
        h1, h2, h3, .hero-title { font-family: 'Bebas Neue', cursive; }
    </style>
</head>
<body>
<nav class="navbar">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/tournois">
        🏆 <span>Tournoi</span>SPORT
    </a>
    <ul class="navbar-nav">
        <li><a class="nav-link" href="${pageContext.request.contextPath}/tournois?action=list">Tournois</a></li>
        <li><a class="nav-link" href="${pageContext.request.contextPath}/equipes?action=list">Équipes</a></li>
    </ul>
</nav>
