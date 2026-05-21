package br.fadir.com.api.controller;

import br.fadir.com.api.dto.CriarPublicacaoDTO;
import br.fadir.com.api.dto.PublicacaoFeedDTO;
import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.repository.UsuarioRepository;
import br.fadir.com.api.service.PublicacaoService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/publicacoes")
public class PublicacaoController {
    private final PublicacaoService publicacaoService;
    private final UsuarioRepository usuarioRepository;

    public PublicacaoController(
            PublicacaoService publicacaoService,
            UsuarioRepository usuarioRepository
    ) {
        this.publicacaoService = publicacaoService;
        this.usuarioRepository = usuarioRepository;
    }

    // ---------- FEED ----------
    @GetMapping("/feed")
    public Page<PublicacaoFeedDTO> feed(
            @RequestHeader("email") String email,
            @RequestParam int page,
            @RequestParam(defaultValue = "10") int size
    ) {
        Usuario usuarioLogado = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
        return publicacaoService.buscarFeed(usuarioLogado, page, size);
    }

    // ---------- CRIAR PUBLICAÇÃO ----------
    @PostMapping
    public ResponseEntity<?> criar(
            @RequestHeader("email") String email,
            @Valid @RequestBody CriarPublicacaoDTO dto
    ) {
        try {
            System.out.println("=== CRIAR PUBLICAÇÃO ===");
            System.out.println("Email recebido: '" + email + "'");
            System.out.println("Email length: " + email.length());
            System.out.println("Email trim: '" + email.trim() + "'");
            System.out.println("DTO recebido: " + dto);

            // Buscar com trim e toLowerCase para evitar problemas
            String emailLimpo = email.trim().toLowerCase();
            System.out.println("Buscando usuário com email: '" + emailLimpo + "'");

            Usuario usuarioLogado = usuarioRepository.findByEmail(emailLimpo)
                    .orElseThrow(() -> new RuntimeException("Usuário não encontrado com email: " + emailLimpo));

            System.out.println("Usuário encontrado: " + usuarioLogado.getNome());

            PublicacaoFeedDTO resultado = publicacaoService.criarPublicacao(dto, usuarioLogado);

            System.out.println("Publicação criada com sucesso!");
            return ResponseEntity.ok(resultado);

        } catch (Exception e) {
            System.err.println("ERRO ao criar publicação: " + e.getMessage());
            e.printStackTrace();
            return ResponseEntity.status(500)
                    .body("Erro ao criar publicação: " + e.getMessage());
        }
    }


}