package br.fadir.com.api.controller;

import br.fadir.com.api.dto.LinkRequestDTO;
import br.fadir.com.api.dto.PythonMetadataDTO;
import br.fadir.com.api.model.Local;
import br.fadir.com.api.repository.LocalRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.HttpClientErrorException;
import org.springframework.web.client.RestTemplate;
import java.util.List;

@RestController
@RequestMapping("/api/locais")
public class LocalController {

    private final LocalRepository localRepository;

    @Value("${api.python.url}")
    private String pythonApiUrl;

    public LocalController(LocalRepository localRepository) {
        this.localRepository = localRepository;
    }

    // 0. LISTAR TODOS
    @GetMapping
    public ResponseEntity<List<Local>> listarTodos() {
        return ResponseEntity.ok(localRepository.findAll());
    }

    // 1. ADICAO VIA LINK
    // Agora aceita ?categoria=hospedagem na URL
    @PostMapping("/adicionar-por-link")
    public ResponseEntity<?> adicionarPorLink(
            @RequestBody LinkRequestDTO linkDTO,
            @RequestParam String categoria
    ) {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            HttpEntity<LinkRequestDTO> request = new HttpEntity<>(linkDTO, headers);

            ResponseEntity<PythonMetadataDTO> response = restTemplate.postForEntity(
                    pythonApiUrl, request, PythonMetadataDTO.class
            );

            PythonMetadataDTO dadosSite = response.getBody();

            if (dadosSite == null || dadosSite.title() == null) {
                return ResponseEntity.badRequest().body("Site inválido.");
            }

            Local novoLocal = new Local();
            novoLocal.setNome(dadosSite.title());

            String desc = dadosSite.description();
            if (desc != null && desc.length() > 250) desc = desc.substring(0, 247) + "...";
            novoLocal.setDescricao(desc);

            novoLocal.setImagemUrl(dadosSite.image());
            novoLocal.setLinkOriginal(dadosSite.original_url());
            novoLocal.setTipo("WEBSITE");
            novoLocal.setCategoria(categoria); // Salva a categoria
            novoLocal.setEnderecoTexto("Endereço extraído via Web");

            localRepository.save(novoLocal);
            return ResponseEntity.ok(novoLocal);

        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.internalServerError().body("Erro: " + e.getMessage());
        }
    }

    // 2. ADICAO MANUAL
    @PostMapping("/adicionar-manual")
    public ResponseEntity<?> adicionarManual(@RequestBody Local localManual) {
        try {
            localManual.setTipo("MANUAL");
            // A categoria já vem no corpo do JSON (localManual)

            if (localManual.getImagemUrl() == null) localManual.setImagemUrl("");
            if (localManual.getDescricao() == null) localManual.setDescricao("");

            localRepository.save(localManual);
            return ResponseEntity.ok(localManual);
        } catch (Exception e) {
            return ResponseEntity.internalServerError().body("Erro: " + e.getMessage());
        }
    }
}