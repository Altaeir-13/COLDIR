import 'package:fadir/utils/date_picker_utils.dart';

class CronogramaModel {
  final int? idCronograma;
  final String titulo;
  final String descricao;
  final String local;
  final String dataEvento;
  final String horarioInicio;
  final String horarioFim;

  CronogramaModel({
    this.idCronograma,
    required this.titulo,
    required this.descricao,
    required this.local,
    required this.dataEvento,
    required this.horarioInicio,
    required this.horarioFim,
  });

  DateTime get dataHoraCompleta {
    try {
      if (dataEvento.contains('/')) {
        List<String> d = dataEvento.split('/');
        List<String> h = horarioInicio.split(':');
        return DateTime(
          int.parse(d[2]), 
          int.parse(d[1]), 
          int.parse(d[0]), 
          int.parse(h[0]), 
          int.parse(h[1])
        );
      }
      return DateTime.parse("${dataEvento}T$horarioInicio");
    } catch (e) {
      return DateTime(1900);
    }
  }


  Map<String, dynamic> toJson() => {
    'idCronograma': idCronograma,
    'titulo': titulo,
    'descricao': descricao,
    'local': local,
    'dataEvento': DatePickerUtils.formatarParaJava(dataEvento), 
    'horarioInicio': horarioInicio,
    'horarioFim': horarioFim,
  };

  factory CronogramaModel.fromJson(Map<String, dynamic> json) {
    return CronogramaModel(
      // Suporta tanto o padrão Java quanto o padrão interno do App
      idCronograma: json['idCronograma'] as int?,
      titulo: json['titulo']?.toString() ?? '', 
      descricao: json['descricao']?.toString() ?? '',
      local: json['local']?.toString() ?? '',
      dataEvento: json['dataEvento']?.toString() ?? '',
      horarioInicio: json['horarioInicio']?.toString() ?? '',
      horarioFim: json['horarioFim']?.toString() ?? '',
    );
  }
}
