package br.fadir.com.api.repository;

import br.fadir.com.api.model.Comentario;
import br.fadir.com.api.model.Publicacao;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ComentarioRepository extends JpaRepository<Comentario, Long> {

    List<Comentario> findByPublicacaoAndComentarioPaiIsNull(Publicacao publicacao);

    List<Comentario> findByComentarioPaiId(Long idComentarioPai);

    int countByPublicacao(Publicacao publicacao);
}
