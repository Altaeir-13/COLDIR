package br.fadir.com.api.dto;

public class LoginResponseDTO {

    private Long idUsuario;
    private String nome;
    private String email;
    private String cargo;
    private String fotoPerfil;

    // --- CORREÇÃO AQUI ---
    public LoginResponseDTO(Long idUsuario, String nome, String email, String cargo, String fotoPerfil) {
        this.idUsuario = idUsuario;
        this.nome = nome;
        this.email = email;
        this.cargo = cargo;
        this.fotoPerfil = fotoPerfil;
    }

    // ... Seus Getters e Setters continuam iguais ...
    public Long getIdUsuario() { return idUsuario; }
    public void setIdUsuario(Long idUsuario) { this.idUsuario = idUsuario; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getCargo() { return cargo; }
    public void setCargo(String cargo) { this.cargo = cargo; }

    public String getFotoPerfil() { return fotoPerfil; }
    public void setFotoPerfil(String fotoPerfil) { this.fotoPerfil = fotoPerfil; }
}