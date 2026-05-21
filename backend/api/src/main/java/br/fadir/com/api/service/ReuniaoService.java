package br.fadir.com.api.service;

import br.fadir.com.api.dto.ReuniaoDTO;
import br.fadir.com.api.dto.CronogramaDTO;
import br.fadir.com.api.model.Reuniao;
import br.fadir.com.api.model.Cronograma;
import br.fadir.com.api.model.StatusReuniao;
import br.fadir.com.api.repository.ReuniaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalTime;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class ReuniaoService {

    @Autowired
    private ReuniaoRepository reuniaoRepository;

    @Transactional
    public Reuniao criarReuniao(ReuniaoDTO dto) {
        Reuniao novaReuniao = new Reuniao();
        return mapearESalvar(novaReuniao, dto);
    }

    @Transactional
    public Reuniao atualizarReuniao(Long id, ReuniaoDTO dto) {
        Reuniao reuniaoExistente = reuniaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reunião não encontrada com id: " + id));
        return mapearESalvar(reuniaoExistente, dto);
    }

    private Reuniao mapearESalvar(Reuniao reuniao, ReuniaoDTO dto) {
        reuniao.setNomeReuniao(dto.getNomeReuniao());
        reuniao.setCampus(dto.getCampus());

        // CONVERSÃO DA DATA DE INÍCIO
        if (dto.getDataInicioReuniao() != null && !dto.getDataInicioReuniao().isEmpty()) {
            LocalDate dataInicio = LocalDate.parse(dto.getDataInicioReuniao().substring(0, 10));
            reuniao.setDataInicioReuniao(dataInicio.atStartOfDay().atOffset(ZoneOffset.UTC));
        }

        // CONVERSÃO DA DATA DE ENCERRAMENTO
        if (dto.getDataFimReuniao() != null && !dto.getDataFimReuniao().isEmpty()) {
            LocalDate dataFim = LocalDate.parse(dto.getDataFimReuniao().substring(0, 10));
            reuniao.setDataFimReuniao(dataFim.atStartOfDay().atOffset(ZoneOffset.UTC));
        }

        reuniao.setStatus(dto.getStatus() != null ?
                StatusReuniao.valueOf(dto.getStatus()) : StatusReuniao.AGENDADA);

        // Mapeamento do Cronograma
        if (dto.getCronograma() != null) {
            // Limpa a lista atual para evitar duplicatas (orphanRemoval deve estar true na Entity)
            reuniao.getCronogramas().clear();

            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");

            for (CronogramaDTO itemDto : dto.getCronograma()) {
                Cronograma item = new Cronograma();
                item.setTitulo(itemDto.getTitulo());
                item.setLocal(itemDto.getLocal());
                item.setDescricao(itemDto.getDescricao());
                item.setDataEvento(LocalDate.parse(itemDto.getDataEvento(), dateFormatter));
                item.setHorarioInicio(LocalTime.parse(itemDto.getHorarioInicio(), timeFormatter));
                item.setHorarioFim(LocalTime.parse(itemDto.getHorarioFim(), timeFormatter));

                item.setReuniao(reuniao);
                reuniao.getCronogramas().add(item);
            }
        }

        return reuniaoRepository.save(reuniao);
    }

    public Reuniao encerrarReuniao(Long id) {
        Reuniao reuniao = reuniaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Reunião não encontrada!"));
        reuniao.setStatus(StatusReuniao.ENCERRADA);
        return reuniaoRepository.save(reuniao);
    }

    public Reuniao buscarProximaAgendada() {
        return reuniaoRepository.findTopByStatusOrderByDataInicioReuniaoAsc(StatusReuniao.AGENDADA)
                .orElse(null);
    }

    public List<Reuniao> listarTodas() {
        return reuniaoRepository.findAll();
    }
}