package br.fadir.com.api.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import br.fadir.com.api.model.LikePublicacao;
import br.fadir.com.api.model.Publicacao;
import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.repository.LikePublicacaoRepository;
import br.fadir.com.api.repository.PublicacaoRepository;
import br.fadir.com.api.repository.UsuarioRepository;

@Service
public class LikePublicacaoService {

    //#region Atributos
    @Autowired
    private LikePublicacaoRepository likeRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;
    
    @Autowired
    private PublicacaoRepository publicacaoRepository;
    //#endregion

    //#region Funções
    public boolean alternarLike(Long idUsuario, Long idPublicacao){

        Usuario usuario = usuarioRepository.findById(idUsuario).orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        Publicacao publicacao = publicacaoRepository.findById(idPublicacao).orElseThrow(() -> new RuntimeException("Publicação não encontrada"));

        return likeRepository.findByUsuarioAndPublicacao(usuario, publicacao).map(like -> {
            likeRepository.delete(like);//discurtir
            return false;
        })
        .orElseGet(() -> { //curtir
            LikePublicacao like = new LikePublicacao();
            like.setUsuario(usuario);
            like.setPublicacao(publicacao);
            likeRepository.save(like);
            return true;
        });
    }
    //#endregion

}
