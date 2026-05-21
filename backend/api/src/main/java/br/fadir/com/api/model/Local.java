package br.fadir.com.api.model;

import jakarta.persistence.*;

@Entity
@Table(name = "locais")
public class Local {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id_locais")
    private Long id;

    @Column(name = "nome")
    private String nome;

    @Column(name = "tipo")
    private String tipo; // MANUAL ou WEBSITE

    // --- NOVO CAMPO IMPORTANTE ---
    @Column(name = "categoria")
    private String categoria; // Ex: 'hospedagem', 'alimentacao'

    @Column(name = "descricao")
    private String descricao;

    @Column(name = "imagem_url")
    private String imagemUrl;

    @Column(name = "link_original")
    private String linkOriginal;

    @Column(name = "endereco_texto")
    private String enderecoTexto;

    @Column(name = "cidade_texto")
    private String cidadeTexto;

    // Construtor vazio
    public Local() {}

    // --- GETTERS e SETTERS ---
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getTipo() { return tipo; }
    public void setTipo(String tipo) { this.tipo = tipo; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public String getImagemUrl() { return imagemUrl; }
    public void setImagemUrl(String imagemUrl) { this.imagemUrl = imagemUrl; }

    public String getLinkOriginal() { return linkOriginal; }
    public void setLinkOriginal(String linkOriginal) { this.linkOriginal = linkOriginal; }

    public String getEnderecoTexto() { return enderecoTexto; }
    public void setEnderecoTexto(String enderecoTexto) { this.enderecoTexto = enderecoTexto; }

    public String getCidadeTexto() { return cidadeTexto; }
    public void setCidadeTexto(String cidadeTexto) { this.cidadeTexto = cidadeTexto; }
}