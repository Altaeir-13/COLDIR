package br.fadir.com.api.repository;

import br.fadir.com.api.model.Publicacao;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

public interface PublicacaoRepository extends JpaRepository<Publicacao, Long> {

    Page<Publicacao> findAllByOrderByDataCriacaoDesc(Pageable pageable);
}
