import 'package:flutter/material.dart';

class IconUtils {
  static const Map<String, IconData> sugestoesIcones = {
    // Alimentação
    'café': Icons.coffee,
    'coffee': Icons.coffee_maker,
    'lanche': Icons.restaurant,
    'almoço': Icons.restaurant_menu,
    'jantar': Icons.dinner_dining,
    
    // Comunicação e Falas
    'abertura': Icons.campaign,
    'palestra': Icons.mic,
    'apresentação': Icons.present_to_all,
    'debate': Icons.groups,
    'mesa': Icons.forum,
    'pronunciamento': Icons.record_voice_over,
    
    // Trabalho e Prática
    'workshop': Icons.computer,
    'minicurso': Icons.terminal,
    'treinamento': Icons.model_training,
    'prática': Icons.build,
    'oficina': Icons.architecture,
    
    // Administrativo e Documentos
    'credenciamento': Icons.how_to_reg,
    'votação': Icons.how_to_vote,
    'ata': Icons.assignment,
    'leitura': Icons.menu_book,
    'documento': Icons.description,
    
    // Outros
    'encerramento': Icons.check_circle,
    'aviso': Icons.notification_important,
    'intervalo': Icons.pause_circle_filled,
    'visita': Icons.explore,
    'foto': Icons.camera_alt,
  };

  /// Função lógica para encontrar o ícone baseado no texto
  static IconData obterIconePorTexto(String texto) {
    String t = texto.toLowerCase();
    IconData iconeEncontrado = Icons.event; // Ícone padrão

    sugestoesIcones.forEach((chave, icone) {
      if (t.contains(chave)) {
        iconeEncontrado = icone;
      }
    });

    return iconeEncontrado;
  }
}