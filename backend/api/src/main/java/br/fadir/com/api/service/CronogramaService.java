package br.fadir.com.api.service;

import br.fadir.com.api.model.Cronograma;
import br.fadir.com.api.model.Reuniao;
import br.fadir.com.api.repository.CronogramaRepository;
import br.fadir.com.api.repository.ReuniaoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class CronogramaService {

    @Autowired
    private ReuniaoRepository reuniaoRepository;

    @Autowired
    private CronogramaRepository cronogramaRepository;

    // Cria um novo conograma
    public Cronograma criarCronograma(Long idReuniao, Cronograma cronograma) {

        // Busca a reunião
        Reuniao reuniao = reuniaoRepository.findById(idReuniao)
                .orElseThrow(() -> new RuntimeException("Reunião não encontrada!"));

        // Liga o cronograma à reunião encontrada
        cronograma.setReuniao(reuniao);

        //  Salva no banco de dados
        return cronogramaRepository.save(cronograma);
    }

    // Busca os dados do cronograma de uma reuniao
    public List<Cronograma> listarPorReuniao(Long idReuniao) {
        return cronogramaRepository.findByReuniao_IdReuniao(idReuniao);
    }
}