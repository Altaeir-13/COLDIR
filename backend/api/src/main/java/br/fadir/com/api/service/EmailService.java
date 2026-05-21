package br.fadir.com.api.service;

import jakarta.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    private final String LAMBDA_URL = "https://eso4expi7q4q3mcsjukblpgl7a0xzccs.lambda-url.us-east-1.on.aws/mail";

    /**
     * Envia e-mail via SMTP local/configurado
     */
    @Async
    public void enviarEmailHtml(String para, String assunto, String corpoHtml) {
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");

            helper.setFrom("nao-responda@fadir.com");
            helper.setTo(para);
            helper.setSubject(assunto);
            helper.setText(corpoHtml, true);

            mailSender.send(mimeMessage);
            System.out.println("Email SMTP enviado com sucesso para: " + para);
        } catch (Exception e) {
            System.out.println("Erro ao enviar email SMTP: " + e.getMessage());
        }
    }

    /**
     * Envia e-mail fazendo uma requisição POST para a API Lambda
     */
    @Async
    public void enviarEmailTexto(String para, String assunto, String corpoHtml) {
        try {
            RestTemplate restTemplate = new RestTemplate();

            // Montando o payload exatamente como o JSON esperado
            Map<String, Object> payload = new HashMap<>();
            payload.put("subject", assunto);
            payload.put("to", Collections.singletonList(para));
            payload.put("text", "email");
            payload.put("html", corpoHtml);

            // Configurando headers
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(payload, headers);

            // Executando a requisição
            String response = restTemplate.postForObject(LAMBDA_URL, entity, String.class);

            System.out.println("Requisição Lambda enviada! Resposta: " + response);

        } catch (Exception e) {
            System.err.println("Erro ao chamar API Lambda: " + e.getMessage());
        }
    }
}