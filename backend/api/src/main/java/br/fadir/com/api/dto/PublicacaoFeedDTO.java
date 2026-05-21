package br.fadir.com.api.dto;

import br.fadir.com.api.model.Publicacao;

import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.List;

public class PublicacaoFeedDTO {

    private Long id;
    private String tipo;
    private String titulo;
    private String texto;
    private String conteudoUrl;
    private List<String> conteudoUrls;
    private String thumbnailUrl;
    private OffsetDateTime dataCriacao;
    private String nomeUsuario;

    private long totalLikes;

    private boolean curtiu;

    public PublicacaoFeedDTO(Publicacao p) {
        this.id = p.getIdPublicacao();
        this.tipo = p.getTipo();
        this.titulo = p.getTitulo();
        this.texto = p.getTexto();
        this.conteudoUrls = p.getConteudoUrls() != null
            ? new ArrayList<>(p.getConteudoUrls())
            : new ArrayList<>();

        if (this.conteudoUrls.isEmpty() && p.getConteudoUrl() != null && !p.getConteudoUrl().isBlank()) {
            this.conteudoUrls.add(p.getConteudoUrl());
        }

        this.conteudoUrl = this.conteudoUrls.isEmpty() ? null : this.conteudoUrls.get(0);
        this.thumbnailUrl = p.getThumbnailUrl();
        this.dataCriacao = p.getDataCriacao();
        this.nomeUsuario = p.getUsuario() != null ? p.getUsuario().getNome() : null; // pega o nome do usuário
    }

    // GETTERS

    public Long getId() {
        return id;
    }

    public String getTipo() {
        return tipo;
    }

    public String getTitulo() {
        return titulo;
    }

    public String getTexto() {
        return texto;
    }

    public String getConteudoUrl() {
        return conteudoUrl;
    }

    public List<String> getConteudoUrls() {
        return conteudoUrls;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public OffsetDateTime getDataCriacao() {
        return dataCriacao;
    }

    public String getNomeUsuario() {
        return nomeUsuario;
    }

    public long getTotalLikes() {
        return totalLikes;
    }

    public void setTotalLikes(long totalLikes) {
        this.totalLikes = totalLikes;
    }

    public boolean isCurtiu() {
        return curtiu;
    }

    public void setCurtiu(boolean curtiu) {
        this.curtiu = curtiu;
    }


    

}
