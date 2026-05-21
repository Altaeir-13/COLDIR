package br.fadir.com.api.model;

import jakarta.persistence.*;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

import br.fadir.com.api.model.converter.StringListJsonConverter;

@Entity
@Table(name = "publicacao")
public class Publicacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_publicacao")
    private Long idPublicacao;

    @ManyToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    // Tem que coloca a coluna de reunião

    @Column(name = "tipo_da_publicacao")
    private String tipo;

    private String titulo;
    private String texto;

    @Column(name = "conteudo_url")
    private String conteudoUrl;

    @Column(name = "conteudo_urls", columnDefinition = "TEXT")
    @Convert(converter = StringListJsonConverter.class)
    private List<String> conteudoUrls = new ArrayList<>();

    @Column(name = "thumbnail_url")
    private String thumbnailUrl;

    @Column(name = "data_criacao")
    private OffsetDateTime dataCriacao;

    @PrePersist
    public void prePersist() {
        this.dataCriacao = OffsetDateTime.now();
    }

    // GETTERS E SETTERS
    public Long getIdPublicacao() {
        return idPublicacao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public String getTipo() {
        return tipo;
    }

    public void setTipo(String tipo) {
        this.tipo = tipo;
    }

    public String getTitulo() {
        return titulo;
    }

    public void setTitulo(String titulo) {
        this.titulo = titulo;
    }

    public String getTexto() {
        return texto;
    }

    public void setTexto(String texto) {
        this.texto = texto;
    }

    public String getConteudoUrl() {
        return conteudoUrl;
    }

    public void setConteudoUrl(String conteudoUrl) {
        this.conteudoUrl = conteudoUrl;
    }

    public List<String> getConteudoUrls() {
        return conteudoUrls;
    }

    public void setConteudoUrls(List<String> conteudoUrls) {
        this.conteudoUrls = conteudoUrls;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
    }

    public OffsetDateTime getDataCriacao() {
        return dataCriacao;
    }
}