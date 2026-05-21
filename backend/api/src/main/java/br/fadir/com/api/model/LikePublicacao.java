package br.fadir.com.api.model;

import java.time.OffsetDateTime;

import org.hibernate.annotations.ManyToAny;

import jakarta.annotation.Generated;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import jakarta.persistence.UniqueConstraint;

@Entity
@Table (name = "like_publicacao", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"id_usuario", "id_publicacao"}) //para não poder dá mais de um like na mesma publicação
})
public class LikePublicacao {
    
    //#region Atributos
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_like")
    private Long idLike;

    @ManyToOne
    @JoinColumn(name = "id_usuario", nullable = false)
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "id_publicacao", nullable = false)
    private Publicacao publicacao;

    @Column(name = "data_like")
    private OffsetDateTime dataLike = OffsetDateTime.now();
    //#endregion

    //#region Getters e Setters
    public Long getIdLike() {
        return idLike;
    }

    public void setIdLike(Long idLike) {
        this.idLike = idLike;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Publicacao getPublicacao() {
        return publicacao;
    }

    public void setPublicacao(Publicacao publicacao) {
        this.publicacao = publicacao;
    }

    public OffsetDateTime getDataLike() {
        return dataLike;
    }

    public void setDataLike(OffsetDateTime dataLike) {
        this.dataLike = dataLike;
    }
    //#endregion
    
}
