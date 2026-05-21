import 'cronograma_model.dart'; 
import 'package:fadir/utils/date_picker_utils.dart';

class ReuniaoModel {
  final int? idReuniao;
  final String nomeReuniao;
  final String campus;
  final String dataInicioReuniao;
  final String dataFimReuniao;
  final String status;
  final List<CronogramaModel> cronograma; 

  ReuniaoModel({
    this.idReuniao,
    required this.nomeReuniao,
    required this.campus,
    required this.dataInicioReuniao,
    required this.dataFimReuniao,
    required this.status,
    this.cronograma = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'idReuniao': idReuniao,
      'nomeReuniao': nomeReuniao,
      'campus': campus,
      'dataInicioReuniao': DatePickerUtils.formatarParaJava(dataInicioReuniao), 
      'dataFimReuniao': DatePickerUtils.formatarParaJava(dataFimReuniao),
      'status': status,
      'cronograma': cronograma.map((item) => item.toJson()).toList(),
    };
  }

  factory ReuniaoModel.fromJson(Map<String, dynamic> json) {
    var listaJson = json['cronogramas'] ?? json['cronograma'] ?? [];
    
    List<CronogramaModel> itensConvertidos = [];
    if (listaJson is List) {
      itensConvertidos = listaJson
          .map((item) => CronogramaModel.fromJson(item))
          .toList();
    }

    return ReuniaoModel(
      idReuniao: json['idReuniao'] as int?,
      nomeReuniao: json['nomeReuniao'] ?? '',
      campus: json['campus'] ?? '',
      dataInicioReuniao: json['dataInicioReuniao'] ?? '',
      dataFimReuniao: json['dataFimReuniao'] ?? '',
      status: json['status'] ?? 'AGENDADA',
      cronograma: itensConvertidos,
    );
  }
}