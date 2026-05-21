package br.fadir.com.api.controller;

import br.fadir.com.api.dto.LoginRequestDTO;
import br.fadir.com.api.dto.LoginResponseDTO;
import br.fadir.com.api.dto.UsuarioDTO;
import br.fadir.com.api.dto.VerificacaoRequestDTO;
import br.fadir.com.api.service.AuthService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
public class AuthController {

    private final AuthService authService;

    public AuthController(AuthService authService) {
        this.authService = authService;
    }

    // --- 1. LOGIN (Agora com Try-Catch) ---
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequestDTO loginRequestDTO) {
        try {
            // Tenta fazer login
            LoginResponseDTO response = authService.login(loginRequestDTO);
            return ResponseEntity.ok(response);

        } catch (RuntimeException e) {
            // Se a senha estiver errada ou usuário não existir:
            // Retorna Erro 400 ou 401 com a mensagem "Senha incorreta"
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- 2. CADASTRO (Agora com Try-Catch) ---
    @PostMapping("/cadastro")
    public ResponseEntity<String> cadastrar(@RequestBody UsuarioDTO dados) {
        System.out.println("DEBUG: Chegou no /cadastro com email: " + dados.email());

        try {
            // Tenta iniciar o cadastro
            authService.iniciarCadastro(dados);
            return ResponseEntity.ok("Código de verificação enviado para o e-mail!");

        } catch (RuntimeException e) {
            // Se o email já existir:
            // Retorna Erro 400 com a mensagem "Email já cadastrado"
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    // --- 3. VERIFICAÇÃO (Já estava, mantido seguro) ---
    @PostMapping("/verificar")
    public ResponseEntity<String> verificar(@RequestBody VerificacaoRequestDTO request) {
        try {
            // Tenta finalizar e salvar no banco
            authService.concluirCadastro(request.email(), request.codigo());
            return ResponseEntity.ok("Conta criada com sucesso!");

        } catch (RuntimeException e) {
            // Se o código estiver errado ou expirado:
            // Retorna Erro 400 com a mensagem "Código incorreto"
            return ResponseEntity.badRequest().body(e.getMessage());
        }
    }

    @GetMapping("/verificar")
    public ResponseEntity<UsuarioDTO> verificarSessao(
            @RequestHeader("email") String email
    ) {
        UsuarioDTO usuario = authService.verificarSessao(email);
        return ResponseEntity.ok(usuario);
    }



}