package br.fadir.com.api.dto;

// Usamos 'record' para criar um objeto imutável (apenas para transportar dados)
public record UsuarioDTO(
        String nome,
        String email,
        String senha
) {
}