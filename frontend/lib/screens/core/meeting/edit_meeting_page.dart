import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/reuniao_provider.dart';
import 'package:fadir/providers/language_provider.dart';

import 'package:fadir/utils/modal_utils.dart';
import 'package:fadir/utils/date_picker_utils.dart';

import 'package:fadir/models/reuniao_model.dart';
import 'package:fadir/models/cronograma_model.dart';

import 'schedule_item_card.dart';
import 'empty_schedule_widget.dart';
import 'package:fadir/widgets/custom_buttons.dart';

class EditMeetingPage extends StatefulWidget {
  const EditMeetingPage({super.key});

  @override
  State<EditMeetingPage> createState() => _EditMeetingPageState();
}

class _EditMeetingPageState extends State<EditMeetingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _campusController = TextEditingController();
  final _dataInicioReuniaoController = TextEditingController();
  final _dataFimReuniaoController = TextEditingController();

  List<CronogramaModel> _listaCronograma = [];
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      final reuniaoAtual = context.read<ReuniaoProvider>().proximaReuniao;
      if (reuniaoAtual != null) {
        _nomeController.text = reuniaoAtual.nomeReuniao;
        _campusController.text = reuniaoAtual.campus;
        _dataInicioReuniaoController.text = DatePickerUtils.formatarParaBR(reuniaoAtual.dataInicioReuniao);
        _dataFimReuniaoController.text = DatePickerUtils.formatarParaBR(reuniaoAtual.dataFimReuniao);
        _listaCronograma = List.from(reuniaoAtual.cronograma);
        _ordenarLista();
      }
      _isInitialized = true;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _campusController.dispose();
    _dataInicioReuniaoController.dispose();
    _dataFimReuniaoController.dispose();
    super.dispose();
  }
  // Função para ordenar a lista de cronogramas pela data e hora
  void _ordenarLista() {
    _listaCronograma.sort((a, b) => a.dataHoraCompleta.compareTo(b.dataHoraCompleta));
  }

  InputDecoration _decor(BuildContext context, String label, {IconData? prefix, Widget? suffix}) {
    final colors = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: prefix != null ? Icon(prefix, color: colors.onSurfaceVariant) : null,
      suffixIcon: suffix,
      filled: true,
      fillColor: colors.surfaceContainerHighest.withValues(alpha: 0.15),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: colors.primary, width: 1),
      ),
    );
  }
  // Função para abrir o modal de adicionar/editar cronograma
  void _abrirModalCronograma({CronogramaModel? itemParaEditar, int? index}) {
    ModalUtils.abrirModalCronograma(
      context: context,
      dataInicial: _dataInicioReuniaoController.text,
      dataFinal: _dataFimReuniaoController.text,
      itemParaEditar: itemParaEditar,
      onAdd: (itemRecebido) {
        setState(() {
          if (index != null) {
            // SUBSTITUIÇÃO: Garante que o item na lista seja o NOVO objeto
            _listaCronograma[index] = itemRecebido;
          } else {
            _listaCronograma.add(itemRecebido);
          }
          _ordenarLista();
        });
      },
    );
  }
  // Função para atualizar a reunião
  void _atualizarReuniao() async {
    if (!_formKey.currentState!.validate()) return;

    DateTime dataInicio = DateFormat('dd/MM/yyyy').parse(_dataInicioReuniaoController.text);
    DateTime dataFim = DateFormat('dd/MM/yyyy').parse(_dataFimReuniaoController.text);

    if (dataFim.isBefore(dataInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('meetingEndBeforeStart')), backgroundColor: Colors.orange),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final reuniaoEditada = ReuniaoModel(
        idReuniao: context.read<ReuniaoProvider>().proximaReuniao?.idReuniao, 
        nomeReuniao: _nomeController.text,
        campus: _campusController.text,
        dataInicioReuniao: DatePickerUtils.formatarParaJava(_dataInicioReuniaoController.text),
        dataFimReuniao: DatePickerUtils.formatarParaJava(_dataFimReuniaoController.text),
        status: 'AGENDADA',
        cronograma: _listaCronograma,
      );

      await context.read<ReuniaoProvider>().editarReuniao(reuniaoEditada);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('meetingUpdateSuccess')), backgroundColor: Colors.blue)
      );
      Navigator.pop(context);

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${context.t('error')}: $e"), backgroundColor: Colors.red)
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);

    return Scaffold(
      appBar: AppBar(title: Text(t('meetingEditTitle')), centerTitle: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t('meetingGeneralData'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 15),
                
                TextFormField(
                  controller: _nomeController,
                  decoration: _decor(
                    context,
                    t('meetingName'),
                    prefix: Icons.edit_note,
                  ),
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 15),
                
                TextFormField(
                  controller: _campusController,
                  decoration: _decor(
                    context,
                    t('meetingCampus'),
                    prefix: Icons.location_on,
                  ),
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _dataInicioReuniaoController,
                  readOnly: true,
                  decoration: _decor(
                    context,
                    t('meetingStartDate'),
                    prefix: Icons.event,
                    suffix: const Icon(Icons.calendar_month),
                  ),
                  onTap: () async {
                    await DatePickerUtils.selecionarData(context: context, controller: _dataInicioReuniaoController);
                    setState(() {}); 
                  },
                ),
                const SizedBox(height: 15),

                TextFormField(
                  controller: _dataFimReuniaoController,
                  readOnly: true,
                  decoration: _decor(
                    context,
                    t('meetingEndDate'),
                    prefix: Icons.event_available,
                    suffix: const Icon(Icons.calendar_month),
                  ),
                  onTap: () async {
                    DateTime dataMin = DateFormat('dd/MM/yyyy').parse(_dataInicioReuniaoController.text);
                    await DatePickerUtils.selecionarData(context: context, controller: _dataFimReuniaoController, initialDate: dataMin, firstDate: dataMin);
                    setState(() {});
                  },
                ),

                const SizedBox(height: 30),
                const Divider(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('meetingSchedule'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      onPressed: () => _abrirModalCronograma(),
                      icon: const Icon(Icons.add_circle_outline),
                      label: Text(t('meetingAddItem')),
                    )
                  ],
                ),
                
                const SizedBox(height: 10),

                if (_listaCronograma.isEmpty)
                  const EmptyScheduleWidget()
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listaCronograma.length,
                    itemBuilder: (context, index) {
                      final item = _listaCronograma[index];
                      return InkWell(
                        key: ValueKey(item.idCronograma ?? item.hashCode),
                        onTap: () => _abrirModalCronograma(itemParaEditar: item, index: index),
                        child: ScheduleItemCard(
                          item: item,
                          onDelete: () => setState(() => _listaCronograma.removeAt(index)),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 40), 
                GradientButton(
                  text: t('meetingUpdate'),
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _atualizarReuniao, 
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}