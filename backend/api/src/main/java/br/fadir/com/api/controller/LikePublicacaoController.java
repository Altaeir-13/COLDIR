package br.fadir.com.api.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import br.fadir.com.api.service.LikePublicacaoService;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;


@RestController
@RequestMapping("/api/publicacoes")
public class LikePublicacaoController {

    @Autowired
    private LikePublicacaoService likeService;


    @PostMapping("/{idPublicacao}/like") //endPoint do like
    public ResponseEntity<Boolean> like(
        @PathVariable Long idPublicacao,
        @RequestParam Long idUsuario
    ){
        boolean curtiu = likeService.alternarLike(idUsuario, idPublicacao);
        return ResponseEntity.ok(curtiu);
    }

    
}
