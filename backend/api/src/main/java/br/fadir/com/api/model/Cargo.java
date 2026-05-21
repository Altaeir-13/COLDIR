package br.fadir.com.api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "cargo")
public class Cargo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_cargo")
    private Long idCargo;

    @Enumerated(EnumType.STRING) // 👇 Salva como Texto (USUARIO, ADM, etc)
    @Column(name = "tipo_de_cargo", nullable = false)
    private TipoCargo tipoDeCargo; // 👈 Mudou de String para TipoCargo

    public Cargo() {}

    // Getters e Setters atualizados
    public Long getIdCargo() { return idCargo; }
    public void setIdCargo(Long idCargo) { this.idCargo = idCargo; }

    public TipoCargo getTipoDeCargo() { return tipoDeCargo; }
    public void setTipoDeCargo(TipoCargo tipoDeCargo) { this.tipoDeCargo = tipoDeCargo; }
}