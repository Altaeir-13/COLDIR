package br.fadir.com.api.dto;

public record PythonMetadataDTO(
        String title,
        String description,
        String image,
        String original_url
) {}