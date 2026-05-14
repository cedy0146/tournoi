package metier;

import dao.*;
import model.*;
import java.util.*;

public class TournoiMetier {

    private TournoiDAO tournoiDAO = new TournoiDAO();
    private EquipeDAO equipeDAO = new EquipeDAO();
    private MatchDAO matchDAO = new MatchDAO();
    private ClassementDAO classementDAO = new ClassementDAO();

    // =================== TOURNOI ===================

    public List<Tournoi> getAllTournois() throws Exception {
        return tournoiDAO.findAll();
    }

    public Tournoi getTournoiById(int id) throws Exception {
        Tournoi t = tournoiDAO.findById(id);
        if (t != null) {
            t.setEquipes(equipeDAO.findByTournoi(id));
        }
        return t;
    }

    public void creerTournoi(Tournoi t) throws Exception {
        if (t.getNom() == null || t.getNom().trim().isEmpty())
            throw new Exception("Le nom du tournoi est obligatoire.");
        if (t.getType() == null)
            throw new Exception("Le type du tournoi est obligatoire.");
        tournoiDAO.insert(t);
    }

    public void modifierTournoi(Tournoi t) throws Exception {
        tournoiDAO.update(t);
    }

    public void supprimerTournoi(int id) throws Exception {
        tournoiDAO.delete(id);
    }

    // =================== ÉQUIPES ===================

    public List<Equipe> getAllEquipes() throws Exception {
        return equipeDAO.findAll();
    }

    public void ajouterEquipe(Equipe e) throws Exception {
        if (e.getNom() == null || e.getNom().trim().isEmpty())
            throw new Exception("Le nom de l'équipe est obligatoire.");
        equipeDAO.insert(e);
    }

    public void modifierEquipe(Equipe e) throws Exception {
        equipeDAO.update(e);
    }

    public void supprimerEquipe(int id) throws Exception {
        equipeDAO.delete(id);
    }

    public void inscrireEquipe(int idTournoi, int idEquipe) throws Exception {
        tournoiDAO.addEquipe(idTournoi, idEquipe);
        classementDAO.initClassement(idTournoi, idEquipe);
    }

    public void desinscrireEquipe(int idTournoi, int idEquipe) throws Exception {
        tournoiDAO.removeEquipe(idTournoi, idEquipe);
    }

    // =================== CALENDRIER ===================

    /**
     * Génération automatique du calendrier selon le type de tournoi.
     * - CHAMPIONNAT : chaque équipe rencontre toutes les autres (aller-retour)
     * - ELIMINATION_DIRECTE : bracket (puissance de 2 requise)
     */
    public void genererCalendrier(int idTournoi) throws Exception {
        Tournoi t = getTournoiById(idTournoi);
        if (t == null) throw new Exception("Tournoi introuvable.");

        List<Equipe> equipes = t.getEquipes();
        if (equipes.size() < 2)
            throw new Exception("Il faut au minimum 2 équipes pour générer le calendrier.");

        // Supprimer les matchs existants et réinitialiser le classement
        matchDAO.deleteByTournoi(idTournoi);
        classementDAO.resetClassement(idTournoi);

        if (t.getType() == Tournoi.Type.CHAMPIONNAT) {
            genererChampionnat(idTournoi, equipes, t.getDateDebut());
        } else {
            genererEliminationDirecte(idTournoi, equipes, t.getDateDebut());
        }

        // Passer le tournoi en cours
        t.setStatut(Tournoi.Statut.EN_COURS);
        tournoiDAO.update(t);
    }

    private void genererChampionnat(int idTournoi, List<Equipe> equipes, Date dateDebut) throws Exception {
        int n = equipes.size();
        Calendar cal = Calendar.getInstance();
        if (dateDebut != null) cal.setTime(dateDebut);

        int journee = 1;
        // Algorithme round-robin (chaque équipe vs toutes les autres, aller + retour)
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                // Match aller
                Match m1 = new Match();
                m1.setIdTournoi(idTournoi);
                m1.setEquipe1(equipes.get(i));
                m1.setEquipe2(equipes.get(j));
                m1.setJournee(journee);
                m1.setDateMatch(cal.getTime());
                matchDAO.insert(m1);

                // Match retour
                Match m2 = new Match();
                m2.setIdTournoi(idTournoi);
                m2.setEquipe1(equipes.get(j));
                m2.setEquipe2(equipes.get(i));
                m2.setJournee(journee + (n - 1));
                cal.add(Calendar.DAY_OF_MONTH, 7);
                m2.setDateMatch(cal.getTime());
                matchDAO.insert(m2);

                journee++;
            }
            cal.add(Calendar.DAY_OF_MONTH, 7);
        }
    }

    private void genererEliminationDirecte(int idTournoi, List<Equipe> equipes, Date dateDebut) throws Exception {
        // Mélanger les équipes pour le tirage
        List<Equipe> shuffled = new ArrayList<>(equipes);
        Collections.shuffle(shuffled);

        Calendar cal = Calendar.getInstance();
        if (dateDebut != null) cal.setTime(dateDebut);

        int journee = 1;
        for (int i = 0; i + 1 < shuffled.size(); i += 2) {
            Match m = new Match();
            m.setIdTournoi(idTournoi);
            m.setEquipe1(shuffled.get(i));
            m.setEquipe2(shuffled.get(i + 1));
            m.setJournee(journee);
            m.setDateMatch(cal.getTime());
            matchDAO.insert(m);
            cal.add(Calendar.DAY_OF_MONTH, 7);
        }
    }

    // =================== MATCHS & SCORES ===================

    public List<Match> getMatchsByTournoi(int idTournoi) throws Exception {
        return matchDAO.findByTournoi(idTournoi);
    }

    /**
     * Enregistre un score et met à jour automatiquement le classement (pour championnat).
     */
    public void enregistrerScore(int idMatch, int score1, int score2) throws Exception {
        Match m = matchDAO.findById(idMatch);
        if (m == null) throw new Exception("Match introuvable.");
        if (m.isJoue()) throw new Exception("Ce match a déjà été joué.");

        matchDAO.updateScore(idMatch, score1, score2);

        // Mise à jour du classement uniquement pour les championnats
        Tournoi t = tournoiDAO.findById(m.getIdTournoi());
        if (t != null && t.getType() == Tournoi.Type.CHAMPIONNAT) {
            mettreAJourClassement(t.getId_tournoi(), m.getEquipe1().getId_equipe(), m.getEquipe2().getId_equipe(), score1, score2);
        }
    }

    // =================== CLASSEMENT ===================

    /**
     * Calcul automatique du classement avec gestion des égalités.
     * Victoire = 3 pts, Nul = 1 pt, Défaite = 0 pt
     */
    private void mettreAJourClassement(int idTournoi, int idE1, int idE2, int s1, int s2) throws Exception {
        if (s1 > s2) {
            // Victoire équipe 1
            classementDAO.updateClassement(idTournoi, idE1, 3, 1, 1, 0, 0, s1, s2);
            classementDAO.updateClassement(idTournoi, idE2, 0, 1, 0, 0, 1, s2, s1);
        } else if (s2 > s1) {
            // Victoire équipe 2
            classementDAO.updateClassement(idTournoi, idE1, 0, 1, 0, 0, 1, s1, s2);
            classementDAO.updateClassement(idTournoi, idE2, 3, 1, 1, 0, 0, s2, s1);
        } else {
            // Égalité
            classementDAO.updateClassement(idTournoi, idE1, 1, 1, 0, 1, 0, s1, s2);
            classementDAO.updateClassement(idTournoi, idE2, 1, 1, 0, 1, 0, s2, s1);
        }
    }

    /**
     * Recalcul complet du classement à partir de tous les matchs joués.
     */
    public List<Classement> getClassement(int idTournoi) throws Exception {
        return classementDAO.findByTournoi(idTournoi);
    }

    public void recalculerClassement(int idTournoi) throws Exception {
        classementDAO.resetClassement(idTournoi);
        List<Match> matchs = matchDAO.findByTournoi(idTournoi);
        for (Match m : matchs) {
            if (m.isJoue()) {
                mettreAJourClassement(idTournoi,
                    m.getEquipe1().getId_equipe(), m.getEquipe2().getId_equipe(),
                    m.getScoreEquipe1(), m.getScoreEquipe2());
            }
        }
    }
}
