package br.fadir.com.api.dto;

import jakarta.validation.constraints.NotBlank;

import java.util.List;

public class CriarPublicacaoDTO {
    @NotBlank(message = "O tipo da publicação é obrigatório")
    private String tipo;

    private String titulo;
    private String texto;
    private String conteudoUrl;
    private List<String> conteudoUrls;
    private String thumbnailUrl;

    // GETTERS E SETTERS
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

    @Override
    public String toString() {
        return "CriarPublicacaoDTO{" +
                "tipo='" + tipo + '\'' +
                ", titulo='" + titulo + '\'' +
                ", texto='" + texto + '\'' +
                ", conteudoUrl='" + conteudoUrl + '\'' +
                ", conteudoUrls=" + conteudoUrls +
                ", thumbnailUrl='" + thumbnailUrl + '\'' +
                '}';
    }
}