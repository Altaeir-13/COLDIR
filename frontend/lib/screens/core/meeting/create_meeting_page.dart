import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/language_provider.dart';

import 'package:fadir/utils/modal_utils.dart';
import 'package:fadir/utils/date_picker_utils.dart';
import 'package:fadir/providers/reuniao_provider.dart';
import 'package:fadir/models/reuniao_model.dart';
import 'package:fadir/models/cronograma_model.dart';

import 'schedule_item_card.dart';
import 'empty_schedule_widget.dart';
import 'package:fadir/widgets/custom_buttons.dart';

// Página para criar uma nova reunião

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _campusController = TextEditingController();
  final _dataInicioReuniaoController = TextEditingController();
  final _dataFimReuniaoController = TextEditingController();

  final List<CronogramaModel> _listaCronograma = [];
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _campusController.dispose();
    _dataInicioReuniaoController.dispose();
    _dataFimReuniaoController.dispose();
    super.dispose();
  }
  // Ordena a lista de cronograma por data e hora
  void _ordenarLista() {
    _listaCronograma.sort((a, b) => a.dataHoraCompleta.compareTo(b.dataHoraCompleta));
  }
  // Abre o modal para adicionar/editar um item do cronograma
  void _abrirModalCronograma({CronogramaModel? itemParaEditar, int? index}) {
    ModalUtils.abrirModalCronograma(
      context: context,
      dataInicial: _dataInicioReuniaoController.text,
      dataFinal: _dataFimReuniaoController.text,
      itemParaEditar: itemParaEditar,
      onAdd: (itemRecebido) {
        setState(() {
          if (index != null) {
            _listaCronograma[index] = itemRecebido;
          } else {
            _listaCronograma.add(itemRecebido);
          }
          _ordenarLista();
        });
      },
    );
  }
  // Salva a nova reunião
  void _salvarReuniao() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Converte para validar lógica de datas
    DateTime dataInicio = DateFormat('dd/MM/yyyy').parse(_dataInicioReuniaoController.text);
    DateTime dataFim = DateFormat('dd/MM/yyyy').parse(_dataFimReuniaoController.text);

    if (dataFim.isBefore(dataInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('meetingEndBeforeStart')), backgroundColor: Colors.orange),
      );
      return;
    }

    if (_listaCronograma.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('meetingAddActivity')))
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // AJUSTE: Enviando as datas formatadas para o JAVA (yyyy-MM-dd)
      final novaReuniao = ReuniaoModel(
        nomeReuniao: _nomeController.text,
        campus: _campusController.text,
        dataInicioReuniao: DatePickerUtils.formatarParaJava(_dataInicioReuniaoController.text),
        dataFimReuniao: DatePickerUtils.formatarParaJava(_dataFimReuniaoController.text),
        status: 'AGENDADA',
        cronograma: _listaCronograma,
      );

      await context.read<ReuniaoProvider>().criarReuniao(novaReuniao);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.t('meetingCreateSuccess')), backgroundColor: Colors.green)
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
      appBar: AppBar(title: Text(t('createMeetingTitle')), centerTitle: true),
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
                  decoration: InputDecoration(labelText: t('meetingName'), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.event)),
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: _campusController,
                  decoration: InputDecoration(labelText: t('meetingCampus'), border: const OutlineInputBorder(), prefixIcon: const Icon(Icons.location_on)),
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 15),
                
                // DATA DE INÍCIO COM SETSTATE NO ONTAP
                TextFormField(
                  controller: _dataInicioReuniaoController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: t('meetingStartDate'), border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_month)),
                  onTap: () async {
                    await DatePickerUtils.selecionarData(context: context, controller: _dataInicioReuniaoController);
                    // IMPORTANTE: Atualiza a tela para o botão do cronograma "ver" a data
                    setState(() {
                      if (_dataFimReuniaoController.text.isEmpty) {
                        _dataFimReuniaoController.text = _dataInicioReuniaoController.text;
                      }
                    });
                  },
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 15),
                
                TextFormField(
                  controller: _dataFimReuniaoController,
                  readOnly: true,
                  decoration: InputDecoration(labelText: t('meetingEndDate'), border: const OutlineInputBorder(), suffixIcon: const Icon(Icons.calendar_month)),
                  onTap: () async {
                    if (_dataInicioReuniaoController.text.isEmpty) return;
                    DateTime dataMinima = DateFormat('dd/MM/yyyy').parse(_dataInicioReuniaoController.text);
                    await DatePickerUtils.selecionarData(context: context, controller: _dataFimReuniaoController, initialDate: dataMinima, firstDate: dataMinima);
                    setState(() {}); // Refresh para garantir consistência
                  },
                  validator: (v) => v!.isEmpty ? t('requiredField') : null,
                ),
                const SizedBox(height: 30),
                const Divider(),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(t('meetingSchedule'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton.icon(
                      // AGORA ELE VAI RECONHECER A DATA DEPOIS DO SETSTATE
                      onPressed: _dataInicioReuniaoController.text.isNotEmpty 
                        ? () => _abrirModalCronograma()
                        : () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(t('meetingSelectStartFirst')))
                          ),
                      icon: const Icon(Icons.add_circle),
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
                      return InkWell(
                        onTap: () => _abrirModalCronograma(itemParaEditar: _listaCronograma[index], index: index),
                        child: ScheduleItemCard(
                          item: _listaCronograma[index],
                          onDelete: () => setState(() => _listaCronograma.removeAt(index)),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 40),
                GradientButton(
                  text: t('meetingSave'),
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _salvarReuniao,
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