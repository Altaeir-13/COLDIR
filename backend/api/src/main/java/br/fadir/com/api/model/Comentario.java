package br.fadir.com.api.model;
import jakarta.persistence.*;
import java.time.OffsetDateTime;

@Entity
@Table(name = "comentarios")
public class Comentario {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_comentario")
    private Long id;

    @ManyToOne
    @JoinColumn(name = "id_publicacao")
    private Publicacao publicacao;

    @ManyToOne
    @JoinColumn(name = "id_usuario")
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "id_comentario_pai")
    private Comentario comentarioPai;

    private String conteudo;

    @Column(name = "data_comentario")
    private OffsetDateTime dataComentario = OffsetDateTime.now();

    //getters e setters


    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Publicacao getPublicacao() {
        return publicacao;
    }

    public void setPublicacao(Publicacao publicacao) {
        this.publicacao = publicacao;
    }

    public Usuario getUsuario() {
        return usuario;
    }

    public void setUsuario(Usuario usuario) {
        this.usuario = usuario;
    }

    public Comentario getComentarioPai() {
        return comentarioPai;
    }

    public void setComentarioPai(Comentario comentarioPai) {
        this.comentarioPai = comentarioPai;
    }

    public String getConteudo() {
        return conteudo;
    }

    public void setConteudo(String conteudo) {
        this.conteudo = conteudo;
    }

    public OffsetDateTime getDataComentario() {
        return dataComentario;
    }

    public void setDataComentario(OffsetDateTime dataComentario) {
        this.dataComentario = dataComentario;
    }
}
