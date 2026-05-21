package br.fadir.com.api.repository;

import br.fadir.com.api.model.Reuniao;
import br.fadir.com.api.model.StatusReuniao; // Não te esqueças de importar o Enum
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ReuniaoRepository extends JpaRepository<Reuniao, Long> {

    // Metodo 1: Pega so a primeira reuniao com status de Agendada ou Em Andamento
    // "findTop" garante que vem só o primeiro
    Optional<Reuniao> findTopByStatusOrderByDataInicioReuniaoAsc(StatusReuniao status);

    // Metodo 2: Pega a lista de reunios encerradas -- sera usado no historico
    // Aqui não tem "Top", então ele traz todos que achar
    List<Reuniao> findByStatus(StatusReuniao status);
}