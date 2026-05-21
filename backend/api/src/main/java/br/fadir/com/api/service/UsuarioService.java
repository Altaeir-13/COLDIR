package br.fadir.com.api.service;

import br.fadir.com.api.model.Reuniao;
import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.repository.ReuniaoRepository;
import br.fadir.com.api.repository.UsuarioRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service // Isso avisa pro Spring: "Eu sou uma classe de lógica!"
public class UsuarioService {

    @Autowired
    private UsuarioRepository usuarioRepository;

    @Autowired
    private ReuniaoRepository reuniaoRepository;

    // Método para colocar um usuário dentro de uma reunião
    public Usuario participarDaReuniao(Long idUsuario, Long idReuniao) {

        // Tenta achar o usuário. Se não achar, dá erro.
        Usuario usuario = usuarioRepository.findById(idUsuario)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado com id: " + idUsuario));

        //  Tenta achar a reunião. Se não achar, dá erro.
        Reuniao reuniao = reuniaoRepository.findById(idReuniao)
                .orElseThrow(() -> new RuntimeException("Reunião não encontrada com id: " + idReuniao));

        // Faz a ligação (Coloca a reunião dentro do objeto usuário)
        usuario.setReuniao(reuniao);

        // Salva a alteração no banco
        return usuarioRepository.save(usuario);
    }
}