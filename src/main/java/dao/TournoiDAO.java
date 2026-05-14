package dao;

import model.Tournoi;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO pour la gestion des tournois.
 * Correction de l'erreur "Column 'id_tournoi' not found".
 */
public class TournoiDAO {

    public List<Tournoi> findAll() throws SQLException {
        List<Tournoi> tournois = new ArrayList<>();
        String sql = "SELECT * FROM tournoi ORDER BY date_debut DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tournois.add(mapRow(rs));
            }
        }
        return tournois;
    }

    public int count() throws SQLException {
        String sql = "SELECT COUNT(*) FROM tournoi";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next())
                return rs.getInt(1);
        }
        return 0;
    }

    public List<Tournoi> findPaginated(int offset, int limit) throws SQLException {
        List<Tournoi> tournois = new ArrayList<>();
        String sql = "SELECT * FROM tournoi ORDER BY date_debut DESC LIMIT ? OFFSET ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setInt(2, offset);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    tournois.add(mapRow(rs));
                }
            }
        }
        return tournois;
    }

    public Tournoi findById(int id) throws SQLException {
        String sql = "SELECT * FROM tournoi WHERE id_tournoi = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return mapRow(rs);
            }
        }
        return null;
    }

    public void insert(Tournoi t) throws SQLException {
        String sql = "INSERT INTO tournoi (nom, type, date_debut, date_fin, statut) VALUES (?, ?, ?, ?, ?)"; // id_tournoi
                                                                                                             // est
                                                                                                             // auto-incrémenté
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, t.getNom());
            ps.setString(2, t.getType() != null ? t.getType().name() : "CHAMPIONNAT");
            ps.setDate(3, t.getDateDebut() != null ? new java.sql.Date(t.getDateDebut().getTime()) : null);
            ps.setDate(4, t.getDateFin() != null ? new java.sql.Date(t.getDateFin().getTime()) : null);
            ps.setString(5, t.getStatut() != null ? t.getStatut().name() : "EN_ATTENTE");
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next())
                        t.setId_tournoi(keys.getInt(1));
                }
            }
        }
    }

    public void update(Tournoi t) throws SQLException {
        String sql = "UPDATE tournoi SET nom = ?, type = ?, date_debut = ?, date_fin = ?, statut = ? WHERE id_tournoi = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, t.getNom());
            ps.setString(2, t.getType() != null ? t.getType().name() : "CHAMPIONNAT");
            ps.setDate(3, t.getDateDebut() != null ? new java.sql.Date(t.getDateDebut().getTime()) : null);
            ps.setDate(4, t.getDateFin() != null ? new java.sql.Date(t.getDateFin().getTime()) : null);
            ps.setString(5, t.getStatut() != null ? t.getStatut().name() : "EN_ATTENTE");
            ps.setInt(6, t.getId_tournoi());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM tournoi WHERE id_tournoi = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void addEquipe(int idTournoi, int idEquipe) throws SQLException {
        String sql = "INSERT IGNORE INTO tournoi_equipe (id_tournoi, id_equipe) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTournoi);
            ps.setInt(2, idEquipe);
            ps.executeUpdate();
        }
    }

    public void removeEquipe(int idTournoi, int idEquipe) throws SQLException {
        String sql = "DELETE FROM tournoi_equipe WHERE id_tournoi = ? AND id_equipe = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, idTournoi);
            ps.setInt(2, idEquipe);
            ps.executeUpdate();
        }
    }

    private Tournoi mapRow(ResultSet rs) throws SQLException {
        Tournoi t = new Tournoi();
        // Correction cruciale : la table 'tournoi' utilise 'id' comme PK
        // Maintenant, la table 'tournoi' utilise 'id_tournoi' comme PK
        t.setId_tournoi(rs.getInt("id_tournoi"));
        t.setNom(rs.getString("nom"));

        t.setType(Tournoi.Type.valueOf(rs.getString("type")));
        t.setStatut(Tournoi.Statut.valueOf(rs.getString("statut")));

        Date dDebut = rs.getDate("date_debut");
        if (dDebut != null)
            t.setDateDebut(new java.util.Date(dDebut.getTime()));

        Date dFin = rs.getDate("date_fin");
        if (dFin != null)
            t.setDateFin(new java.util.Date(dFin.getTime()));

        return t;
    }
}