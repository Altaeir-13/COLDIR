import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePickerUtils {
  
  /// --- 1. MÉDOTO QUE VOCÊ JÁ TINHA: ABRE O CALENDÁRIO ---
  static Future<void> selecionarData({
    required BuildContext context,
    required TextEditingController controller,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime(2030),
      locale: const Locale('pt', 'BR'),
    );

    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  // ---  CONVERTE DATA DO JAVA PARA EXIBIÇÃO NO APP ---
  // Exemplo: "2026-01-28" -> "28/01/2026"
  static String formatarParaBR(String? dataBruta) {
    if (dataBruta == null || dataBruta.isEmpty) return "";
    try {
      // Remove horas/minutos caso venham do banco (ex: 2026-01-28 14:00:00)
      String dataApenas = dataBruta.substring(0, 10); 
      if (dataApenas.contains('-')) {
        var partes = dataApenas.split('-');
        return "${partes[2]}/${partes[1]}/${partes[0]}";
      }
    } catch (e) {
      return dataBruta; // Se falhar, mostra o original para não sumir o dado
    }
    return dataBruta;
  }

  // --- MÉTODO INVERSO: CONVERTE DO APP PARA O JAVA ---
  // Exemplo: "28/01/2026" -> "2026-01-28"
  static String formatarParaJava(String dataBr) {
    if (dataBr.isEmpty) return "";
    try {
      var partes = dataBr.split('/');
      return "${partes[2]}-${partes[1]}-${partes[0]}";
    } catch (e) {
      return dataBr;
    }
  }
}