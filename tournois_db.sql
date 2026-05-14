-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Hôte : localhost
-- Généré le : jeu. 14 mai 2026 à 15:51
-- Version du serveur : 10.4.32-MariaDB
-- Version de PHP : 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `tournois_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `classement`
--

CREATE TABLE `classement` (
  `id_classement` int(11) NOT NULL,
  `id_tournoi` int(11) NOT NULL,
  `id_equipe` int(11) NOT NULL,
  `points` int(11) DEFAULT 0,
  `matchs_joues` int(11) DEFAULT 0,
  `victoires` int(11) DEFAULT 0,
  `nuls` int(11) DEFAULT 0,
  `defaites` int(11) DEFAULT 0,
  `buts_pour` int(11) DEFAULT 0,
  `buts_contre` int(11) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `equipe`
--

CREATE TABLE `equipe` (
  `id_equipe` int(11) NOT NULL,
  `nom` varchar(100) NOT NULL,
  `ville` varchar(100) DEFAULT NULL,
  `logo_url` varchar(255) DEFAULT NULL,
  `date_creation` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `match_sportif`
--

CREATE TABLE `match_sportif` (
  `id_match` int(11) NOT NULL,
  `id_tournoi` int(11) NOT NULL,
  `id_equipe1` int(11) NOT NULL,
  `id_equipe2` int(11) NOT NULL,
  `score_equipe1` int(11) DEFAULT NULL,
  `score_equipe2` int(11) DEFAULT NULL,
  `tab_equipe1` int(11) DEFAULT NULL,
  `tab_equipe2` int(11) DEFAULT NULL,
  `date_match` date DEFAULT NULL,
  `journee` int(11) DEFAULT 1,
  `statut` enum('PROGRAMME','JOUE') DEFAULT 'PROGRAMME'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `match_terrain`
--

CREATE TABLE `match_terrain` (
  `id_match` int(11) NOT NULL,
  `id_terrain` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `regles_tournoi`
--

CREATE TABLE `regles_tournoi` (
  `id_tournoi` int(11) NOT NULL,
  `pts_victoire` int(11) DEFAULT 3,
  `pts_nul` int(11) DEFAULT 1,
  `pts_defaite` int(11) DEFAULT 0,
  `nb_terrains` int(11) DEFAULT 1,
  `duree_match_minutes` int(11) DEFAULT 90,
  `gestion_prolongations` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Structure de la table `terrain`
--

CREATE TABLE `terrain` (
  `id_terrain` int(11) NOT NULL,
  `nom` varchar(50) NOT NULL,
  `capacite` int(11) DEFAULT 100,
  `type` varchar(20) DEFAULT 'herbe'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Déchargement des données de la table `terrain`
--

INSERT INTO `terrain` (`id_terrain`, `nom`, `capacite`, `type`) VALUES
(1, 'Terrain A', 500, 'herbe'),
(2, 'Terrain B', 300, 'herbe'),
(3, 'Terrain C', 200, 'synthetique');

-- --------------------------------------------------------

--
-- Structure de la table `tournoi`
--

CREATE TABLE `tournoi` (
  `id_tournoi` int(11) NOT NULL,
  `nom` varchar(150) NOT NULL,
  `type` enum('ELIMINATION_DIRECTE','CHAMPIONNAT') NOT NULL,
  `date_debut` date DEFAULT NULL,
  `date_fin` date DEFAULT NULL,
  `statut` enum('EN_ATTENTE','EN_COURS','TERMINE') DEFAULT 'EN_ATTENTE'
) ;

--
-- Déchargement des données de la table `tournoi`
--

INSERT INTO `tournoi` (`id_tournoi`, `nom`, `type`, `date_debut`, `date_fin`, `statut`) VALUES
(1, 'coupe', 'CHAMPIONNAT', '2026-05-16', '2026-05-23', 'EN_ATTENTE');

-- --------------------------------------------------------

--
-- Structure de la table `tournoi_equipe`
--

CREATE TABLE `tournoi_equipe` (
  `id_tournoi` int(11) NOT NULL,
  `id_equipe` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `classement`
--
ALTER TABLE `classement`
  ADD PRIMARY KEY (`id_classement`),
  ADD UNIQUE KEY `unique_classement` (`id_tournoi`,`id_equipe`),
  ADD KEY `id_equipe` (`id_equipe`),
  ADD KEY `idx_classement_tournoi` (`id_tournoi`);

--
-- Index pour la table `equipe`
--
ALTER TABLE `equipe`
  ADD PRIMARY KEY (`id_equipe`);

--
-- Index pour la table `match_sportif`
--
ALTER TABLE `match_sportif`
  ADD PRIMARY KEY (`id_match`),
  ADD KEY `id_equipe1` (`id_equipe1`),
  ADD KEY `id_equipe2` (`id_equipe2`),
  ADD KEY `idx_match_tournoi` (`id_tournoi`);

--
-- Index pour la table `match_terrain`
--
ALTER TABLE `match_terrain`
  ADD PRIMARY KEY (`id_match`,`id_terrain`),
  ADD KEY `id_terrain` (`id_terrain`);

--
-- Index pour la table `regles_tournoi`
--
ALTER TABLE `regles_tournoi`
  ADD PRIMARY KEY (`id_tournoi`);

--
-- Index pour la table `terrain`
--
ALTER TABLE `terrain`
  ADD PRIMARY KEY (`id_terrain`);

--
-- Index pour la table `tournoi`
--
ALTER TABLE `tournoi`
  ADD PRIMARY KEY (`id_tournoi`);

--
-- Index pour la table `tournoi_equipe`
--
ALTER TABLE `tournoi_equipe`
  ADD PRIMARY KEY (`id_tournoi`,`id_equipe`),
  ADD KEY `id_equipe` (`id_equipe`),
  ADD KEY `idx_tournoi_equipe_tournoi` (`id_tournoi`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `classement`
--
ALTER TABLE `classement`
  MODIFY `id_classement` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `equipe`
--
ALTER TABLE `equipe`
  MODIFY `id_equipe` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `match_sportif`
--
ALTER TABLE `match_sportif`
  MODIFY `id_match` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT pour la table `terrain`
--
ALTER TABLE `terrain`
  MODIFY `id_terrain` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT pour la table `tournoi`
--
ALTER TABLE `tournoi`
  MODIFY `id_tournoi` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `classement`
--
ALTER TABLE `classement`
  ADD CONSTRAINT `classement_ibfk_1` FOREIGN KEY (`id_tournoi`) REFERENCES `tournoi` (`id_tournoi`) ON DELETE CASCADE,
  ADD CONSTRAINT `classement_ibfk_2` FOREIGN KEY (`id_equipe`) REFERENCES `equipe` (`id_equipe`);

--
-- Contraintes pour la table `match_sportif`
--
ALTER TABLE `match_sportif`
  ADD CONSTRAINT `match_sportif_ibfk_1` FOREIGN KEY (`id_tournoi`) REFERENCES `tournoi` (`id_tournoi`) ON DELETE CASCADE,
  ADD CONSTRAINT `match_sportif_ibfk_2` FOREIGN KEY (`id_equipe1`) REFERENCES `equipe` (`id_equipe`),
  ADD CONSTRAINT `match_sportif_ibfk_3` FOREIGN KEY (`id_equipe2`) REFERENCES `equipe` (`id_equipe`);

--
-- Contraintes pour la table `match_terrain`
--
ALTER TABLE `match_terrain`
  ADD CONSTRAINT `match_terrain_ibfk_1` FOREIGN KEY (`id_match`) REFERENCES `match_sportif` (`id_match`) ON DELETE CASCADE,
  ADD CONSTRAINT `match_terrain_ibfk_2` FOREIGN KEY (`id_terrain`) REFERENCES `terrain` (`id_terrain`);

--
-- Contraintes pour la table `regles_tournoi`
--
ALTER TABLE `regles_tournoi`
  ADD CONSTRAINT `regles_tournoi_ibfk_1` FOREIGN KEY (`id_tournoi`) REFERENCES `tournoi` (`id_tournoi`) ON DELETE CASCADE;

--
-- Contraintes pour la table `tournoi_equipe`
--
ALTER TABLE `tournoi_equipe`
  ADD CONSTRAINT `tournoi_equipe_ibfk_1` FOREIGN KEY (`id_tournoi`) REFERENCES `tournoi` (`id_tournoi`) ON DELETE CASCADE,
  ADD CONSTRAINT `tournoi_equipe_ibfk_2` FOREIGN KEY (`id_equipe`) REFERENCES `equipe` (`id_equipe`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
