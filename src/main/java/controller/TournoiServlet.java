package controller;

import metier.TournoiMetier;
import model.*;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet("/tournois")
public class TournoiServlet extends HttpServlet {

    private TournoiMetier metier = new TournoiMetier();
    private SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null)
            action = "list";

        try {
            switch (action) {
                case "list":
                    int page = getIntParam(req, "page");
                    if (page <= 0)
                        page = 1;
                    int size = 10; // Nombre de tournois par page

                    req.setAttribute("tournois", metier.getTournoisPaginated(page, size));
                    req.setAttribute("currentPage", page);
                    req.setAttribute("totalPages", metier.getTotalPages(size));
                    dispatch(req, resp, "/jsp/tournois/list.jsp");
                    break;

                case "create":
                    dispatch(req, resp, "/jsp/tournois/form.jsp");
                    break;

                case "edit":
                    int id = getIntParam(req, "id");
                    if (id > 0)
                        req.setAttribute("tournoi", metier.getTournoiById(id));
                    dispatch(req, resp, "/jsp/tournois/form.jsp");
                    break;

                case "view":
                    int idView = getIntParam(req, "id");
                    if (idView <= 0) {
                        resp.sendRedirect(req.getContextPath() + "/tournois?action=list");
                        return;
                    }

                    Tournoi t = metier.getTournoiById(idView);
                    if (t == null) {
                        req.setAttribute("error", "Tournoi introuvable.");
                        dispatch(req, resp, "/jsp/error.jsp");
                        return;
                    }
                    req.setAttribute("tournoi", t);

                    String tab = req.getParameter("tab");
                    if (tab == null || tab.isEmpty()) {
                        tab = "equipes"; // Onglet par défaut
                    }
                    req.setAttribute("currentTab", tab); // Pour marquer l'onglet actif dans la JSP

                    String jspPath = "";
                    switch (tab) {
                        case "equipes":
                            req.setAttribute("toutesEquipes", metier.getAllEquipes()); // Pour le formulaire
                                                                                       // d'inscription
                            jspPath = "/jsp/tournois/equipes.jsp";
                            break;
                        case "calendrier":
                            req.setAttribute("matchs", metier.getMatchsByTournoi(idView));
                            jspPath = "/jsp/tournois/calendrier.jsp";
                            break;
                        case "classement":
                            req.setAttribute("classement", metier.getClassement(idView));
                            jspPath = "/jsp/tournois/classement.jsp";
                            break;
                        default:
                            resp.sendRedirect(
                                    req.getContextPath() + "/tournois?action=view&id=" + idView + "&tab=equipes");
                            return;
                    }
                    dispatch(req, resp, jspPath);
                    break;

                case "delete":
                    int delId = getIntParam(req, "id");
                    if (delId > 0)
                        metier.supprimerTournoi(delId);
                    resp.sendRedirect(req.getContextPath() + "/tournois?action=list&msg=supprime");
                    break;

                case "generer":
                    int genId = getIntParam(req, "id");
                    if (genId > 0)
                        metier.genererCalendrier(genId);
                    resp.sendRedirect(
                            req.getContextPath() + "/tournois?action=view&id=" + genId + "&msg=calendrier_genere");
                    break;

                default:
                    resp.sendRedirect(req.getContextPath() + "/tournois");
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            try {
                dispatch(req, resp, "/jsp/error.jsp");
            } catch (Exception ex) {
                throw new ServletException(ex);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        req.setCharacterEncoding("UTF-8");

        try {
            if ("save".equals(action)) {
                Tournoi t = new Tournoi();
                t.setNom(req.getParameter("nom"));
                String typeStr = req.getParameter("type");
                if (typeStr != null) {
                    try {
                        t.setType(Tournoi.Type.valueOf(typeStr));
                    } catch (IllegalArgumentException ex) {
                        t.setType(Tournoi.Type.CHAMPIONNAT);
                    }
                }

                String dd = req.getParameter("dateDebut");
                String df = req.getParameter("dateFin");
                try {
                    if (dd != null && !dd.isEmpty())
                        t.setDateDebut(sdf.parse(dd));
                    if (df != null && !df.isEmpty())
                        t.setDateFin(sdf.parse(df));
                } catch (Exception ex) {
                    /* Date invalide ignorée */ }

                int id = getIntParam(req, "id");
                if (id > 0) {
                    t.setId_tournoi(id);
                    String statutStr = req.getParameter("statut");
                    if (statutStr != null) {
                        try {
                            t.setStatut(Tournoi.Statut.valueOf(statutStr));
                        } catch (IllegalArgumentException ex) {
                        }
                    }
                    metier.modifierTournoi(t);
                } else {
                    metier.creerTournoi(t);
                }
                resp.sendRedirect(req.getContextPath() + "/tournois?action=list&msg=sauvegarde");

            } else if ("inscrire".equals(action)) {
                int idTournoi = getIntParam(req, "idTournoi");
                int idEquipe = getIntParam(req, "idEquipe");
                metier.inscrireEquipe(idTournoi, idEquipe);
                resp.sendRedirect(req.getContextPath() + "/tournois?action=view&id=" + idTournoi);

            } else if ("desinscrire".equals(action)) {
                int idTournoi = getIntParam(req, "idTournoi");
                int idEquipe = getIntParam(req, "idEquipe");
                metier.desinscrireEquipe(idTournoi, idEquipe);
                resp.sendRedirect(req.getContextPath() + "/tournois?action=view&id=" + idTournoi);
            }
        } catch (Exception e) {
            req.setAttribute("error", e.getMessage());
            try {
                dispatch(req, resp, "/jsp/error.jsp");
            } catch (Exception ex) {
                throw new ServletException(ex);
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
