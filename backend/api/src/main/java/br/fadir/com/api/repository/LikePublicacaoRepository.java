package br.fadir.com.api.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import br.fadir.com.api.model.LikePublicacao;
import br.fadir.com.api.model.Publicacao;
import br.fadir.com.api.model.Usuario;

public interface LikePublicacaoRepository extends JpaRepository<LikePublicacao, Long>{
    boolean existsByUsuarioAndPublicacao(Usuario usuario, Publicacao publicacao);

    Optional<LikePublicacao> findByUsuarioAndPublicacao(
        Usuario usuario,
        Publicacao publicacao
    );

    long countByPublicacao(Publicacao publicacao);
    
}
