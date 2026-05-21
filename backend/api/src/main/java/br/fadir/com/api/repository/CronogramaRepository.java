package br.fadir.com.api.repository;

import br.fadir.com.api.model.Cronograma;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CronogramaRepository extends JpaRepository<Cronograma, Long> {

    List<Cronograma> findByReuniao_IdReuniao(Long idReuniao);

}