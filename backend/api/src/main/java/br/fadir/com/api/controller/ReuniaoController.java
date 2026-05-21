package br.fadir.com.api.controller;

import br.fadir.com.api.dto.ReuniaoDTO;
import br.fadir.com.api.model.Reuniao;
import br.fadir.com.api.service.ReuniaoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/reunioes")
@CrossOrigin(origins = "*") // Permite que o Flutter acesse a API sem erros de CORS
public class ReuniaoController {

    @Autowired
    private ReuniaoService reuniaoService;

    // 1. POST: Criar nova reunião usando DTO
    @PostMapping
    public ResponseEntity<Reuniao> criar(@RequestBody ReuniaoDTO dto) {
        System.out.println("🆕 [CONTROLLER] Criando nova reunião: " + dto.getNomeReuniao());
        Reuniao novaReuniao = reuniaoService.criarReuniao(dto);
        return ResponseEntity.status(HttpStatus.CREATED).body(novaReuniao);
    }

    // 2. GET: Apenas a PRÓXIMA Agendada
    @GetMapping("/proxima")
    public ResponseEntity<Reuniao> pegarProxima() {
        System.out.println("📨 [CONTROLLER] Buscando próxima reunião");
        Reuniao reuniao = reuniaoService.buscarProximaAgendada();

        if (reuniao == null) {
            return ResponseEntity.noContent().build();
        }
        return ResponseEntity.ok(reuniao);
    }

    // 3. GET: Histórico (Listar todas)
    @GetMapping("/historico")
    public ResponseEntity<List<Reuniao>> listarHistorico() {
        return ResponseEntity.ok(reuniaoService.listarTodas());
    }

    // 4. PATCH: Encerrar reunião
    @PatchMapping("/{id}/encerrar")
    public ResponseEntity<Reuniao> encerrar(@PathVariable Long id) {
        return ResponseEntity.ok(reuniaoService.encerrarReuniao(id));
    }

    // 5. PUT: Atualiza uma reunião existente usando DTO
    @PutMapping("/{id}")
    public ResponseEntity<Reuniao> editar(@PathVariable Long id, @RequestBody ReuniaoDTO dto) {
        System.out.println("🔄 [CONTROLLER] Atualizando reunião ID: " + id);

        // Chama o service que faz o mapeamento do DTO para o Model
        Reuniao reuniaoAtualizada = reuniaoService.atualizarReuniao(id, dto);

        return ResponseEntity.ok(reuniaoAtualizada);
    }
}