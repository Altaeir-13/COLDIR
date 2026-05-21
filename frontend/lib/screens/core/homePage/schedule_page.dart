import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/providers/reuniao_provider.dart';
import 'package:fadir/models/cronograma_model.dart'; 

import 'package:fadir/utils/date_picker_utils.dart'; 
import 'package:fadir/utils/icon_utils.dart'; 

import 'package:fadir/widgets/schedule_header.dart';
import 'package:fadir/widgets/schedule_item.dart';
import 'package:fadir/widgets/custom_buttons.dart';

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

  void _confirmPresence(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(context.t('presenceConfirmed')),
        backgroundColor: Theme.of(context).colorScheme.primary,
        duration: const Duration(seconds: 2),
      ),
    );
    Navigator.pop(context, true);
  }

  // Verifica se o item do cronograma está acontecendo agora
  bool _verificarSeEstaAcontecendo(CronogramaModel item) {
    try {
      final agora = DateTime.now();
      
      // Início do evento (ajustado para o horário local do celular)
      final inicio = item.dataHoraCompleta.toLocal();
      
      // Extrair hora e minuto do fim
      final partesFim = item.horarioFim.split(':');
      if (partesFim.length < 2) return false;

      int horaFim = int.parse(partesFim[0]);
      int minFim = int.parse(partesFim[1]);

      //  Criar o DateTime de fim
      DateTime fim = DateTime(
        inicio.year,
        inicio.month,
        inicio.day,
        horaFim,
        minFim,
      );

      //  LÓGICA DE VIRADA DE DIA: 
      // Se a hora de fim for menor que a de início (ex: início 23:00 e fim 00:00),
      // significa que o evento acaba no dia seguinte.
      if (horaFim < inicio.hour || (horaFim == inicio.hour && minFim < inicio.minute)) {
        fim = fim.add(const Duration(days: 1));
      }

      // Verifica se estamos dentro do intervalo
      return (agora.isAfter(inicio) || agora.isAtSameMomentAs(inicio)) && agora.isBefore(fim);
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final reuniaoProvider = context.watch<ReuniaoProvider>();
    final reuniao = reuniaoProvider.proximaReuniao;
    
    final colors = Theme.of(context).colorScheme;
    final Color tealColor = colors.primary;
    final background = colors.surface;
    final onPrimary = colors.onPrimary;
    String t(String key) => context.t(key);

    if (reuniao == null) {
      return Scaffold(
        backgroundColor: background,
        appBar: AppBar(title: Text(t('schedule')), backgroundColor: tealColor),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // 1. Organizar e ordenar cronograma por data e hora
    final listaOriginal = List<CronogramaModel>.from(reuniao.cronograma);
    listaOriginal.sort((a, b) => a.dataHoraCompleta.compareTo(b.dataHoraCompleta));

    // 2. Agrupar itens por dia (DataEvento)
    Map<String, List<CronogramaModel>> itensAgrupados = {};
    for (var item in listaOriginal) {
      itensAgrupados.putIfAbsent(item.dataEvento, () => []).add(item);
    }
    
    final datasDisponiveis = itensAgrupados.keys.toList();

    final dataInicio = DatePickerUtils.formatarParaBR(reuniao.dataInicioReuniao);
    final dataFim = DatePickerUtils.formatarParaBR(reuniao.dataFimReuniao);

    // Verifica se existe QUALQUER item acontecendo agora na lista toda
    bool existeAlgumAcontecendo = listaOriginal.any((item) => _verificarSeEstaAcontecendo(item));

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: tealColor,
        elevation: 0,
        iconTheme: IconThemeData(color: onPrimary),
        title: Text(
          t('schedule'),
          style: TextStyle(color: onPrimary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ScheduleHeader(
              eventName: reuniao.nomeReuniao,
              location: reuniao.campus,
              date: dataInicio == dataFim ? dataInicio : "$dataInicio - $dataFim",
            ),
            
            const SizedBox(height: 10),

            if (listaOriginal.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text("Nenhuma atividade cadastrada.")),
              )
            else
              ...datasDisponiveis.map((data) {
                final itensDoDia = itensAgrupados[data]!;
                
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: tealColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              data.contains('-') ? DatePickerUtils.formatarParaBR(data) : data,
                              style: TextStyle(color: tealColor, fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ),
                          const Expanded(child: Divider(indent: 10)),
                        ],
                      ),
                    ),
                    
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: itensDoDia.length,
                      itemBuilder: (context, index) {
                        final item = itensDoDia[index];
                        
                        // LÓGICA DE DESTAQUE:
                        // 1. Destaca se estiver acontecendo AGORA.
                        // 2. Se NADA estiver acontecendo agora, destaca o primeiro item da lista original (fallback).
                        bool destaque = _verificarSeEstaAcontecendo(item);
                        if (!existeAlgumAcontecendo && item == listaOriginal.first) {
                          destaque = true;
                        }

                        return ScheduleItem(
                          timeInicio: item.horarioInicio,
                          timeFim: item.horarioFim,
                          title: item.titulo,
                          description: item.descricao,
                          location: item.local.isEmpty ? "Local não definido" : item.local,
                          icon: IconUtils.obterIconePorTexto(item.titulo),
                          iconColor: tealColor, 
                          isHighlight: destaque, 
                          isLast: index == itensDoDia.length - 1, 
                        );
                      },
                    ),
                  ],
                );
              }),

            const SizedBox(height: 30),
            GradientButton(
              text: t('confirmPresence').toUpperCase(),
              onPressed: () => _confirmPresence(context),
            ),
            const SizedBox(height: 20), 
          ],
        ),
      ),
    );
  }
}