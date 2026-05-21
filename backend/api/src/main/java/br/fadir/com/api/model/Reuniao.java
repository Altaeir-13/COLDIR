package br.fadir.com.api.model;

import jakarta.persistence.*;
import java.util.List;
import java.util.ArrayList;
import java.time.OffsetDateTime;
import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "reuniao")
public class Reuniao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_reuniao")
    private long idReuniao;

    @Column(name = "nome_reuniao")
    private String nomeReuniao;

    @Column(name = "campus")
    private String campus;

    @Column(name = "data_inicio_reuniao")
    private OffsetDateTime dataInicioReuniao;

    @Column(name = "data_fim_reuniao")
    private OffsetDateTime dataFimReuniao;

    @OneToMany(mappedBy = "reuniao")
    @JsonIgnore
    private List<Usuario> usuarios = new ArrayList<>();

    // AJUSTE: Removido JsonIgnore e adicionado orphanRemoval
    @OneToMany(mappedBy = "reuniao", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<Cronograma> cronogramas = new ArrayList<>();

    @Enumerated(EnumType.STRING)
    @Column(name = "status")
    private StatusReuniao status;

    // --- GETTERS E SETTERS ---

    public long getIdReuniao() { return idReuniao; }
    public void setIdReuniao(long idReuniao) { this.idReuniao = idReuniao; }

    public String getNomeReuniao() { return nomeReuniao; }
    public void setNomeReuniao(String nomeReuniao) { this.nomeReuniao = nomeReuniao; }

    public String getCampus() { return campus; }
    public void setCampus(String campus) { this.campus = campus; }

    public OffsetDateTime getDataInicioReuniao() {
        return dataInicioReuniao;
    }
    public void setDataInicioReuniao(OffsetDateTime dataReuniao) {
        this.dataInicioReuniao = dataReuniao;
    }

    public OffsetDateTime getDataFimReuniao() {
        return dataFimReuniao;
    }

    public void setDataFimReuniao(OffsetDateTime dataFimReuniao) {
        this.dataFimReuniao = dataFimReuniao;
    }

    public List<Usuario> getUsuarios() { return usuarios; }
    public void setUsuarios(List<Usuario> usuarios) { this.usuarios = usuarios; }

    // Dica: No Service, use getCronogramas() em vez de getCronograma() para bater com este nome
    public List<Cronograma> getCronogramas() { return cronogramas; }
    public void setCronogramas(List<Cronograma> cronogramas) { this.cronogramas = cronogramas; }

    public StatusReuniao getStatus() { return status; }
    public void setStatus(StatusReuniao status) { this.status = status; }
}