package br.fadir.com.api.controller;

import br.fadir.com.api.model.Cronograma;
import br.fadir.com.api.service.CronogramaService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/reunioes") // A URL começa aqui
public class CronogramaController {

    @Autowired
    private CronogramaService cronogramaService;

    // ADICIONAR ITEM NO CRONOGRAMA
    @PostMapping("/{idReuniao}/cronogramas")
    public ResponseEntity<Cronograma> adicionarCronograma(
            @PathVariable Long idReuniao,
            @RequestBody Cronograma cronograma) {

        // Chama o service passando o ID da URL e o Objeto do Body
        Cronograma novoCronograma = cronogramaService.criarCronograma(idReuniao, cronograma);

        return ResponseEntity.ok(novoCronograma);
    }

    //  LISTAR ITENS DO CRONOGRAMA
    @GetMapping("/{idReuniao}/cronogramas")
    public ResponseEntity<List<Cronograma>> listarCronograma(@PathVariable Long idReuniao) {

        List<Cronograma> lista = cronogramaService.listarPorReuniao(idReuniao);

        return ResponseEntity.ok(lista);
    }
}