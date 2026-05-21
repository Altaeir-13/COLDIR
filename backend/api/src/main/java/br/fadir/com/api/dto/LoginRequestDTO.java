package br.fadir.com.api.dto;
//Representa os dados que o app envia no login, apenas carrega os dados
public class LoginRequestDTO {
    private String email;
    private String senha;

    public LoginRequestDTO(){
    }

    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }

    public String getSenha(){
        return senha;
    }
    public void setSenha(String senha){
        this.senha = senha;
    }
}
