import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

import 'custom_buttons.dart';
import 'countdown_timer.dart';

import 'package:fadir/screens/core/homePage/schedule_page.dart';
import 'package:fadir/screens/core/homePage/documents_page.dart';
import 'package:fadir/screens/core/homePage/locations_page.dart';

import '../../models/reuniao_model.dart';

class HomeEventCard extends StatefulWidget {
  final ReuniaoModel reuniao; 

  const HomeEventCard({
    super.key, 
    required this.reuniao 
  });

  @override
  State<HomeEventCard> createState() => _HomeEventCardState();
}

class _HomeEventCardState extends State<HomeEventCard> {
  bool _isConfirmed = false;
  DateTime? _startDateTime;

  @override
  void initState() {
    super.initState();
    _startDateTime = _resolveStartDateTime(widget.reuniao);
  }

  @override
  void didUpdateWidget(covariant HomeEventCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reuniao != widget.reuniao) {
      _startDateTime = _resolveStartDateTime(widget.reuniao);
    }
  }

  void _markConfirmed() {
    setState(() {
      _isConfirmed = true;
    });
  }

  Future<void> _openSchedule() async {
    final confirmed = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (context) => const SchedulePage()),
    );

    if (!mounted) return;
    if (confirmed == true) {
      _markConfirmed();
    }
  }

  DateTime? _resolveStartDateTime(ReuniaoModel reuniao) {
    DateTime? earliest;
    for (final item in reuniao.cronograma) {
      final dateSource = item.dataEvento.isNotEmpty ? item.dataEvento : reuniao.dataInicioReuniao;
      final candidate = _combineDateAndTime(dateSource, item.horarioInicio);
      if (candidate != null && (earliest == null || candidate.isBefore(earliest))) {
        earliest = candidate;
      }
    }

    if (earliest != null) return earliest;

    // Fallback: usa apenas a data informada para a reunião
    return _combineDateAndTime(reuniao.dataInicioReuniao, null);
  }

  DateTime? _combineDateAndTime(String dateStr, String? timeStr) {
    final date = _parseDate(dateStr);
    if (date == null) return null;

    int hour = 0;
    int minute = 0;

    if (timeStr != null && timeStr.isNotEmpty) {
      final parts = timeStr.split(':');
      if (parts.length >= 2) {
        hour = int.tryParse(parts[0]) ?? 0;
        minute = int.tryParse(parts[1]) ?? 0;
      }
    }

    return DateTime(date.year, date.month, date.day, hour, minute);
  }

  DateTime? _parseDate(String dateStr) {
    if (dateStr.isEmpty) return null;
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      // Continua para tentar outros formatos
    }

    try {
      final parts = dateStr.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        return DateTime(year, month, day);
      }
    } catch (_) {
      // Retorna nulo se não conseguir interpretar a data
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final onSurface = colors.onSurface;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = colors.surface;
    final textTheme = Theme.of(context).textTheme;
    
    final cardColor = isDark
      ? colors.surfaceContainerHighest
      : Color.alphaBlend(colors.primary.withValues(alpha: 0.08), colors.surface);
    final borderColor = colors.outline.withValues(alpha: isDark ? 0.4 : 0.22);
    final Color tealColor = colors.primary;
    
    String t(String key) => context.t(key);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.reuniao.nomeReuniao,
                  style: textTheme.titleSmall?.copyWith(
                    color: onSurface,
                    letterSpacing: -0.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              // Badge de Status
              if (widget.reuniao.status == 'EM_ANDAMENTO')
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    "AO VIVO",
                    style: textTheme.labelSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                )
            ],
          ),
          
          // Meta + cronômetro em linha
          const SizedBox(height: 6),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                widget.reuniao.campus,
                style: textTheme.labelMedium?.copyWith(
                  color: onSurface.withValues(alpha: 0.7),
                ),
              ),
              if (_startDateTime != null)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.timer_outlined, size: 16, color: tealColor),
                    const SizedBox(width: 6),
                    Text(
                      t('startsIn'),
                      style: textTheme.labelMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(width: 6),
                    CountdownTimer(
                      startTime: _startDateTime!,
                      textStyle: textTheme.labelMedium?.copyWith(
                        color: onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 14),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo do evento
              Expanded(
                flex: 4,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: surface,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/if.png',
                      fit: BoxFit.contain,
                      errorBuilder: (c, e, s) => const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),
              
              // Botões de Ação
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    // Fluxo: ver cronograma primeiro; confirmação acontece na tela do cronograma
                    if (!_isConfirmed)
                      GradientButton(
                        text: t('schedule'),
                        onPressed: _openSchedule,
                      )
                    else
                      Column(
                        children: [
                          GradientButton(
                            text: t('schedule'),
                            colors: const [Color(0xFFFFA726), Color(0xFFFB8C00)],
                            onPressed: _openSchedule,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            t('presenceConfirmedLabel'),
                            style: textTheme.labelSmall?.copyWith(
                              color: const Color(0xFF0E564D),
                            ),
                          ),
                        ],
                      ),
                      
                    const SizedBox(height: 10),
                    
                    // Botões Menores
                    Row(
                      children: [
                        Expanded(
                          child: SquareIconButton(
                            color: tealColor, 
                            icon: Icons.location_on_outlined, 
                            label: t('locationsShort'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LocationsPage()),
                              );
                            }
                          )
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SquareIconButton(
                            color: tealColor, 
                            icon: Icons.description_outlined, 
                            label: t('documentsShort'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const DocumentsPage()),
                              );
                            }
                          )
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}