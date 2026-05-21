package br.fadir.com.api.service;

import br.fadir.com.api.dto.LoginRequestDTO;
import br.fadir.com.api.dto.LoginResponseDTO;
import br.fadir.com.api.dto.UsuarioDTO;
import br.fadir.com.api.model.Cargo;
import br.fadir.com.api.model.Usuario;
import br.fadir.com.api.repository.UsuarioRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.time.OffsetDateTime; // Importante para compatibilidade com o Modelo Usuario
import java.util.Map;
import java.util.Optional;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

@Service
public class AuthService {

    private final UsuarioRepository usuarioRepository;
    private final EmailService emailService;

    // A Memória guarda os dados temporários
    private final Map<String, DadosTemporarios> memoriaCadastro = new ConcurrentHashMap<>();

    // Record para agrupar os dados na memória (Sala de Espera)
    private record DadosTemporarios(UsuarioDTO dadosUsuario, String codigo, LocalDateTime expiracao) {}

    public AuthService(UsuarioRepository usuarioRepository, EmailService emailService) {
        this.usuarioRepository = usuarioRepository;
        this.emailService = emailService;
    }

    // --- LOGIN ---
    public LoginResponseDTO login(LoginRequestDTO loginRequestDTO) {

        Optional<Usuario> usuarioOptional =
                usuarioRepository.findByEmail(loginRequestDTO.getEmail());

        if (usuarioOptional.isEmpty()) {
            throw new RuntimeException("Usuário não encontrado");
        }

        Usuario usuario = usuarioOptional.get();

        if (!usuario.getSenha().equals(loginRequestDTO.getSenha())) {
            throw new RuntimeException("Senha incorreta");
        }

        String nomeCargo = "USUARIO";
        if (usuario.getCargo() != null && usuario.getCargo().getTipoDeCargo() != null) {
            nomeCargo = usuario.getCargo().getTipoDeCargo().name();
        }

        return new LoginResponseDTO(
                usuario.getIdUsuario(),
                usuario.getNome(),
                usuario.getEmail(),
                nomeCargo,
                usuario.getFotoPerfil()
        );
    }

    // --- CADASTRO (COM HTML BONITO) ---
    public void iniciarCadastro(UsuarioDTO dados) {

        // 1. Verifica se já existe no Banco REAL
        if (usuarioRepository.existsByEmail(dados.email())) {
            throw new RuntimeException("Este email já está cadastrado!");
        }

        // 2. Gera o código
        String codigo = String.valueOf(100000 + new Random().nextInt(900000));
        LocalDateTime expiracao = LocalDateTime.now().plusMinutes(15);

        // 3. GUARDA NA MEMÓRIA
        memoriaCadastro.put(dados.email(), new DadosTemporarios(dados, codigo, expiracao));

        // 4. Envia o E-mail (HTML Formatado)
        String assunto = "FADIR - Seu código de verificação";

        // Template HTML usando Text Blocks do Java
        // %s será substituído pelas variáveis no .formatted()
        String corpoHtml = """
                <!DOCTYPE html>
                <html lang="pt-BR">
                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Verificação de Conta</title>
                </head>
                <body style="font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4; margin: 0; padding: 0;">
                    <div style="max-width: 600px; margin: 40px auto; background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
                        
                        <!-- Cabeçalho -->
                        <div style="background-color: #0E564D; padding: 30px; text-align: center;">
                            <h1 style="color: #ffffff; margin: 0; font-size: 28px; letter-spacing: 2px;">FADIR</h1>
                        </div>

                        <!-- Conteúdo -->
                        <div style="padding: 40px 30px; text-align: center; color: #333333;">
                            <h2 style="color: #0E564D; margin-top: 0;">Olá, %s! 👋</h2>
                            
                            <p style="font-size: 16px; line-height: 1.5; color: #555;">
                                Obrigado por se cadastrar no FADIR. Para garantir a segurança da sua conta, use o código abaixo para concluir seu registro:
                            </p>

                            <!-- Caixa do Código -->
                            <div style="background-color: #f0fdfa; border: 2px dashed #0E564D; border-radius: 8px; padding: 15px; margin: 30px auto; width: fit-content; min-width: 200px;">
                                <span style="display: block; font-size: 36px; font-weight: bold; color: #0E564D; letter-spacing: 8px;">%s</span>
                            </div>

                            <p style="font-size: 14px; color: #777; margin-bottom: 0;">
                                ⏳ Este código expira em <strong>15 minutos</strong>.
                            </p>
                        </div>

                        <!-- Rodapé -->
                        <div style="background-color: #eeeeee; padding: 20px; text-align: center; font-size: 12px; color: #888;">
                            <p style="margin: 5px 0;">Se você não solicitou este código, ignore este e-mail.</p>
                            <p style="margin: 0;">&copy; 2026 Equipe FADIR. Todos os direitos reservados.</p>
                        </div>
                    </div>
                </body>
                </html>
                """.formatted(dados.nome(), codigo);

        // Envia para a Lambda (que aceita o parâmetro html no JSON)
        emailService.enviarEmailTexto(dados.email(), assunto, corpoHtml);

        System.out.println("⏳ Usuário na SALA DE ESPERA (RAM). Código: " + codigo);
    }

    // --- VERIFICAÇÃO ---
    public void concluirCadastro(String email, String codigoDigitado) {

        DadosTemporarios temp = memoriaCadastro.get(email);

        if (temp == null) {
            throw new RuntimeException("Código expirado ou email inválido (Cadastre-se novamente)");
        }

        if (temp.expiracao().isBefore(LocalDateTime.now())) {
            memoriaCadastro.remove(email);
            throw new RuntimeException("Código expirado!");
        }
        if (!temp.codigo().equals(codigoDigitado)) {
            throw new RuntimeException("Código incorreto!");
        }

        UsuarioDTO dados = temp.dadosUsuario();

        Usuario novoUsuario = new Usuario();
        novoUsuario.setNome(dados.nome());
        novoUsuario.setEmail(dados.email());
        novoUsuario.setSenha(dados.senha());
        novoUsuario.setAtivo(true);

        // Ajuste para OffsetDateTime (compatibilidade com Usuario.java)
        novoUsuario.setDataCriacao(OffsetDateTime.now());

        // Define Cargo (Padrão ID 1 - USUARIO)
        Cargo cargo = new Cargo();
        cargo.setIdCargo(1L);
        novoUsuario.setCargo(cargo);

        usuarioRepository.save(novoUsuario);
        System.out.println("✅ Usuário SALVO NO BANCO com sucesso!");

        memoriaCadastro.remove(email);
    }

    public UsuarioDTO verificarSessao(String email) {
        Usuario usuario = usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));

        return new UsuarioDTO(
                usuario.getNome(),
                usuario.getEmail(),
                null // Senha null
        );
    }
}