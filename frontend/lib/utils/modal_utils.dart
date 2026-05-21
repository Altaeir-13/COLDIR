import 'package:flutter/material.dart';
import '../models/cronograma_model.dart';
import '../screens/core/meeting/add_schedule_modal.dart';

class ModalUtils {
  static void abrirModalCronograma({
    required BuildContext context,
    required String dataInicial,
    required String dataFinal,
    required Function(CronogramaModel) onAdd,
    CronogramaModel? itemParaEditar,
  }) {
    showDialog(
      context: context,
      builder: (context) => AddScheduleModal(
        initialDate: dataInicial,
        finalDate: dataFinal,
        itemParaEditar: itemParaEditar,
        onSave: onAdd, 
      ),
    );
  }
}