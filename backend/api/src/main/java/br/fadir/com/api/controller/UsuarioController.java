package br.fadir.com.api.controller;

import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.service.UsuarioService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/usuarios") // A rota base é /usuarios
public class UsuarioController {

    @Autowired
    private UsuarioService usuarioService;


    // Colocar usuário na reunião
    // Exemplo de URL: PUT http://localhost:8080/usuarios/1/participar/5
    @PutMapping("/{idUsuario}/participar/{idReuniao}")
    public ResponseEntity<Usuario> participarReuniao(
            @PathVariable Long idUsuario,
            @PathVariable Long idReuniao) {

        Usuario usuarioAtualizado = usuarioService.participarDaReuniao(idUsuario, idReuniao);

        return ResponseEntity.ok(usuarioAtualizado);
    }
}