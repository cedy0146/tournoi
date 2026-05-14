package model;

import java.util.Date;

public class Equipe {

    private int id_equipe;
    private String nom;
    private String ville;
    private String logoUrl;
    private Date dateCreation;

    public Equipe() {}

    public Equipe(int id_equipe, String nom, String ville) {
        this.id_equipe = id_equipe;
        this.nom = nom;
        this.ville = ville;
    }

    // Getters & Setters
    public int getId_equipe() { return id_equipe; }
    public void setId_equipe(int id_equipe) { this.id_equipe = id_equipe; }

    /**
     * Alias pour simplifier l'accès dans les JSPs via Java EL.
     * Permet d'utiliser ${equipe.id} au lieu de ${equipe.id_equipe}.
     */
    public int getId() { return id_equipe; }
    public void setId(int id) { this.id_equipe = id; }

    public String getNom() { return nom; }
    public void setNom(String nom) { this.nom = nom; }

    public String getVille() { return ville; }
    public void setVille(String ville) { this.ville = ville; }

    public String getLogoUrl() { return logoUrl; }
    public void setLogoUrl(String logoUrl) { this.logoUrl = logoUrl; }

    public Date getDateCreation() { return dateCreation; }
    public void setDateCreation(Date dateCreation) { this.dateCreation = dateCreation; }

    @Override
    public String toString() { // Pour le débogage, utile d'afficher le nouvel ID
        return "Equipe{id_equipe=" + id_equipe + ", nom='" + nom + "', ville='" + ville + "'}";
    }
}
