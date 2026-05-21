package br.fadir.com.api.dto;

import java.util.List;

public class ReuniaoDTO {
    private String nomeReuniao;
    private String campus;
    private String dataInicioReuniao; // Recebe "yyyy-MM-dd" do Flutter
    private String dataFimReuniao;
    private String status;
    private List<CronogramaDTO> cronograma; // Nome deve bater com a chave do JSON

    // Construtor padrão necessário para o Jackson
    public ReuniaoDTO() {}

    // Getters e Setters
    public String getNomeReuniao() { return nomeReuniao; }
    public void setNomeReuniao(String nomeReuniao) { this.nomeReuniao = nomeReuniao; }

    public String getCampus() { return campus; }
    public void setCampus(String campus) { this.campus = campus; }

    public String getDataInicioReuniao() { return dataInicioReuniao; }
    public void setDataInicioReuniao(String dataReuniao) { this.dataInicioReuniao = dataReuniao; }

    public String getDataFimReuniao() { return dataFimReuniao; }
    public void setDataFimReuniao() { this.dataFimReuniao = dataFimReuniao; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public List<CronogramaDTO> getCronograma() { return cronograma; }
    public void setCronograma(List<CronogramaDTO> cronograma) { this.cronograma = cronograma; }
}