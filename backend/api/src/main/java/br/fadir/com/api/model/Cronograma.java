package br.fadir.com.api.model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonFormat;
import java.time.LocalTime;
import java.time.LocalDate;

@Entity
@Table(name = "cronograma")
public class Cronograma {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cronograma")
    private Long idCronograma;

    @ManyToOne
    @JoinColumn(name = "id_reuniao")
    @JsonIgnore
    private Reuniao reuniao;

    @Column(name = "titulo")
    private String titulo;

    @Column(name = "data_evento")
    @JsonFormat(pattern = "dd/MM/yyyy")
    private LocalDate dataEvento;

    @Column(name = "descricao")
    private String descricao;

    @Column(name = "local")
    private String local;

    @Column(name = "horario_inicio")
    @JsonFormat(pattern = "HH:mm")
    private LocalTime horarioInicio;

    @Column(name = "horario_fim")
    @JsonFormat(pattern = "HH:mm")
    private LocalTime horarioFim;

    // --- GETTERS E SETTERS ---

    public Long getIdCronograma() {
        return idCronograma;
    }

    public void setIdCronograma(Long idCronograma) {
        this.idCronograma = idCronograma;
    }

    public Reuniao getReuniao() {
        return reuniao;
    }

    public void setReuniao(Reuniao reuniao) {
        this.reuniao = reuniao;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getDescricao() {
        return descricao;
    }

    public void setDescricao(String descricao) {
        this.descricao = descricao;
    }

    public LocalDate getDataEvento() {
        return dataEvento;
    }

    public void setDataEvento(LocalDate dataEvento) {
        this.dataEvento = dataEvento;
    }

    public String getLocal() {
        return local;
    }

    public void setLocal(String local) {
        this.local = local;
    }

    public LocalTime getHorarioInicio() {
        return horarioInicio;
    }

    public void setHorarioInicio(LocalTime horarioInicio) {
        this.horarioInicio = horarioInicio;
    }

    public LocalTime getHorarioFim() {
        return horarioFim;
    }

    public void setHorarioFim(LocalTime horarioFim) {
        this.horarioFim = horarioFim;
    }
}