package br.fadir.com.api.service;

import br.fadir.com.api.dto.CriarPublicacaoDTO;
import br.fadir.com.api.dto.PublicacaoFeedDTO;
import br.fadir.com.api.model.Publicacao;
import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.repository.LikePublicacaoRepository;
import br.fadir.com.api.repository.PublicacaoRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;


@Service
public class PublicacaoService {
    private final PublicacaoRepository publicacaoRepository;
    private final LikePublicacaoRepository likeRepository;


public PublicacaoService(
        PublicacaoRepository publicacaoRepository,
        LikePublicacaoRepository likeRepository
) {
    this.publicacaoRepository = publicacaoRepository;
    this.likeRepository = likeRepository;
}


    public PublicacaoFeedDTO criarPublicacao(CriarPublicacaoDTO dto, Usuario usuario) {
        System.out.println("Service: Criando publicação para usuário " + usuario.getNome());

        List<String> conteudoUrls = normalizarConteudoUrls(dto);

        Publicacao pub = new Publicacao();
        pub.setUsuario(usuario);
        pub.setTipo(dto.getTipo());
        pub.setTitulo(dto.getTitulo() != null ? dto.getTitulo() : "");
        pub.setTexto(dto.getTexto() != null ? dto.getTexto() : "");
        pub.setConteudoUrls(conteudoUrls);
        pub.setConteudoUrl(conteudoUrls.isEmpty() ? "" : conteudoUrls.get(0));
        pub.setThumbnailUrl(dto.getThumbnailUrl() != null ? dto.getThumbnailUrl() : "");

        Publicacao salva = publicacaoRepository.save(pub);
        System.out.println("Service: Publicação salva com ID " + salva.getIdPublicacao());

        return new PublicacaoFeedDTO(salva);
    }

public Page<PublicacaoFeedDTO> buscarFeed(Usuario usuario, int page, int size) {

    return publicacaoRepository
            .findAllByOrderByDataCriacaoDesc(PageRequest.of(page, size))
            .map(publicacao -> {

                PublicacaoFeedDTO dto = new PublicacaoFeedDTO(publicacao);

                long totalLikes =
                        likeRepository.countByPublicacao(publicacao);

                boolean curtiu =
                        likeRepository.existsByUsuarioAndPublicacao(
                                usuario, publicacao
                        );

                dto.setTotalLikes(totalLikes);
                dto.setCurtiu(curtiu);

                return dto;
            });
}

    private List<String> normalizarConteudoUrls(CriarPublicacaoDTO dto) {
        List<String> urls = dto.getConteudoUrls() == null
                ? new ArrayList<>()
                : new ArrayList<>(dto.getConteudoUrls());

        urls = urls.stream()
                .filter(Objects::nonNull)
                .map(String::trim)
                .filter(s -> !s.isEmpty())
                .toList();

        if (urls.isEmpty() && dto.getConteudoUrl() != null && !dto.getConteudoUrl().trim().isEmpty()) {
            urls = Collections.singletonList(dto.getConteudoUrl().trim());
        }

        if (urls.size() > 4) {
            throw new IllegalArgumentException("Máximo 4 imagens permitidas");
        }

        boolean hasInvalid = urls.stream()
                .anyMatch(url -> !(url.startsWith("http://") || url.startsWith("https://")));

        if (hasInvalid) {
            throw new IllegalArgumentException("URLs inválidas: use http ou https");
        }

        return new ArrayList<>(urls);
    }

}