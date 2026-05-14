package controller;

import metier.TournoiMetier;
import model.Match;
import model.Tournoi;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/matchs")
public class MatchServlet extends HttpServlet {

    private TournoiMetier metier = new TournoiMetier();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null)
            action = "list"; // Action par défaut si non spécifiée

        try {
            switch (action) {
                case "score":
                    int idMatch = getIntParam(req, "id");
                    int idTournoi = getIntParam(req, "idTournoi");

                    if (idMatch <= 0 || idTournoi <= 0) {
                        resp.sendRedirect(req.getContextPath() + "/tournois?action=list");
                        return;
                    }

                    Match match = metier.getMatchDAO().findById(idMatch);
                    Tournoi tournoi = metier.getTournoiById(idTournoi);

                    if (match == null || tournoi == null) {
                        req.setAttribute("error", "Match ou Tournoi introuvable.");
                        dispatch(req, resp, "/jsp/error.jsp");
                        return;
                    }

                    req.setAttribute("match", match);
                    req.setAttribute("tournoi", tournoi); // Pour le retour au calendrier
                    dispatch(req, resp, "/jsp/matchs/score.jsp");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/tournois?action=list");
                    break;
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            dispatch(req, resp, "/jsp/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        try {
            if ("saveScore".equals(action)) {
                int idMatch = getIntParam(req, "idMatch");
                int idTournoi = getIntParam(req, "idTournoi");
                int scoreEquipe1 = getIntParam(req, "scoreEquipe1");
                int scoreEquipe2 = getIntParam(req, "scoreEquipe2");

                try {
                    metier.enregistrerScore(idMatch, scoreEquipe1, scoreEquipe2);
                    resp.sendRedirect(req.getContextPath() + "/tournois?action=view&id=" + idTournoi
                            + "&tab=calendrier&msg=score_enregistre");
                } catch (Exception e) {
                    // En cas d'erreur métier, on recharge les données et on reste sur le formulaire
                    req.setAttribute("error", e.getMessage());
                    req.setAttribute("match", metier.getMatchDAO().findById(idMatch));
                    req.setAttribute("tournoi", metier.getTournoiById(idTournoi));
                    dispatch(req, resp, "/jsp/matchs/score.jsp");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/tournois?action=list");
            }
        } catch (Exception e) {
            if (!resp.isCommitted()) {
                req.setAttribute("error", e.getMessage());
                dispatch(req, resp, "/jsp/error.jsp");
            }
        }
    }

    private int getIntParam(HttpServletRequest req, String name) {
        try {
            String val = req.getParameter(name);
            return (val == null || val.isEmpty()) ? 0 : Integer.parseInt(val);
        } catch (NumberFormatException e) {
            return 0;
        }
    }

    private void dispatch(HttpServletRequest req, HttpServletResponse resp, String path)
            throws ServletException, IOException {
        req.getRequestDispatcher(path).forward(req, resp);
    }
}