import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/cronograma_model.dart';
import '../../../utils/date_picker_utils.dart';
import '../../../utils/icon_utils.dart';

class AddScheduleModal extends StatefulWidget {
  final String initialDate;
  final String finalDate;
  final CronogramaModel? itemParaEditar; // Para suportar edição
  final Function(CronogramaModel) onSave; // Nome alterado para refletir Add/Edit

  const AddScheduleModal({
    super.key,
    required this.initialDate,
    required this.finalDate,
    required this.onSave,
    this.itemParaEditar,
  });

  @override
  State<AddScheduleModal> createState() => _AddScheduleModalState();
}

class _AddScheduleModalState extends State<AddScheduleModal> {
  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  final _localController = TextEditingController();
  late final TextEditingController _dataController;

  TimeOfDay? _inicio;
  TimeOfDay? _fim;

  // Automação de Ícones (Dicionário de palavras-chave)
  IconData _iconeSugerido = Icons.event;
  
  @override
  void initState() {
    super.initState();
    _dataController = TextEditingController(text: widget.initialDate);

    // Se for edição, preenche os campos
    if (widget.itemParaEditar != null) {
      _tituloController.text = widget.itemParaEditar!.titulo;
      _descController.text = widget.itemParaEditar!.descricao;
      _localController.text = widget.itemParaEditar!.local;
      _dataController.text = widget.itemParaEditar!.dataEvento;
      
      // Converte Strings HH:mm de volta para TimeOfDay
      final ini = widget.itemParaEditar!.horarioInicio.split(':');
      final fim = widget.itemParaEditar!.horarioFim.split(':');
      _inicio = TimeOfDay(hour: int.parse(ini[0]), minute: int.parse(ini[1]));
      _fim = TimeOfDay(hour: int.parse(fim[0]), minute: int.parse(fim[1]));
      
      _detectarIcone(_tituloController.text);
    }

    // Listener para automatizar o ícone enquanto digita
    _tituloController.addListener(() => _detectarIcone(_tituloController.text));
  }
  // Lógica para detectar ícone baseado no texto
  void _detectarIcone(String texto) {
    final novoIcone = IconUtils.obterIconePorTexto(texto);

    if (novoIcone != _iconeSugerido) {
      setState(() => _iconeSugerido = novoIcone);
    }
  }
  @override
  void dispose() {
    _tituloController.dispose();
    _descController.dispose();
    _localController.dispose();
    _dataController.dispose();
    super.dispose();
  }
  // Formata TimeOfDay para String HH:mm
  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
  // Validação e submissão do formulário
  void _submit() {
  // O trim() remove espaços em branco acidentais
  final String tituloDigitado = _tituloController.text.trim();
  final String localDigitado = _localController.text.trim();
  final String descDigitada = _descController.text.trim();

  if (tituloDigitado.isEmpty || _inicio == null || _fim == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("O título e os horários são obrigatórios!")),
    );
    return;
  }

  final model = CronogramaModel(
    idCronograma: widget.itemParaEditar?.idCronograma, // Mantém o ID para o Java saber que é update
    titulo: tituloDigitado, 
    descricao: descDigitada,
    local: localDigitado,
    dataEvento: _dataController.text,
    horarioInicio: _formatTime(_inicio!),
    horarioFim: _formatTime(_fim!),
  );

  widget.onSave(model);
  Navigator.pop(context);
}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.itemParaEditar == null ? "Nova Atividade" : "Editar Atividade"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Campo Título
            TextField(
              controller: _tituloController,
              decoration: InputDecoration(
                labelText: "Titulo (Ex: Palestra)",
                prefixIcon: Icon(_iconeSugerido), // Ícone Automático
              ),
            ),
            const SizedBox(height: 10),
            // Campo Descrição
            TextField(
              controller: _descController,
              decoration: InputDecoration(
                labelText: "Descrição",
                prefixIcon: const Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 10),
            // Campo Local
            TextField(
              controller: _localController,
              decoration: const InputDecoration(
                labelText: "Sala / Local",
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 10),
            // Campo Data
            TextField(
              controller: _dataController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Data",
                suffixIcon: Icon(Icons.calendar_today, size: 16),
              ),
              onTap: () {
                DateTime dataMin = DateFormat('dd/MM/yyyy').parse(widget.initialDate);
                DateTime dataMax = DateFormat('dd/MM/yyyy').parse(widget.finalDate);
                DatePickerUtils.selecionarData(
                  context: context,
                  controller: _dataController,
                  initialDate: dataMin,
                  firstDate: dataMin,
                  lastDate: dataMax,
                );
              },
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: _inicio ?? const TimeOfDay(hour: 8, minute: 0),
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (t != null) setState(() => _inicio = t);
                    },
                    child: Text(_inicio == null ? "Início" : _formatTime(_inicio!)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: _fim ?? const TimeOfDay(hour: 9, minute: 0),
                        initialEntryMode: TimePickerEntryMode.input,
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (t != null) setState(() => _fim = t);
                    },
                    child: Text(_fim == null ? "Fim" : _formatTime(_fim!)),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancelar")),
        ElevatedButton(
          onPressed: _submit,
          child: Text(widget.itemParaEditar == null ? "Adicionar" : "Salvar Alteração"),
        )
      ],
    );
  }
}