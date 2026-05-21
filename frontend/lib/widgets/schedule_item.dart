import 'package:flutter/material.dart';

// Widget para exibir um item do cronograma

class ScheduleItem extends StatelessWidget {
  final String timeInicio;
  final String timeFim;
  final String title;
  final String description;
  final String location;
  final bool isHighlight;
  final IconData icon;
  final Color? iconColor; 
  final bool isLast;

  const ScheduleItem({
    super.key,
    required this.timeInicio,
    required this.timeFim,
    required this.title,
    required this.description,
    required this.location,
    required this.icon,
    this.iconColor,
    this.isHighlight = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = colors.onSurface;
    
    final outline = colors.outline.withValues(alpha: isDark ? 0.35 : 0.22);
    final lineColor = colors.outline.withValues(alpha: isDark ? 0.35 : 0.2);
    final cardBase = isDark ? colors.surfaceContainerHighest : colors.surface;
    
    final cardColor = isHighlight
        ? Color.alphaBlend(colors.primary.withValues(alpha: isDark ? 0.12 : 0.08), cardBase)
        : cardBase;
        
    final borderColor = isHighlight
        ? colors.primary.withValues(alpha: isDark ? 0.5 : 0.35)
        : outline;
        
    final mutedText = onSurface.withValues(alpha: 0.7);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 55,
            child: Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Horário de início
                  Text(
                    timeInicio,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isHighlight ? colors.primary : onSurface,
                    ),
                  ),
                  // Horário de fim
                  Text(
                    timeFim,
                    style: TextStyle(
                      fontSize: 11,
                      color: mutedText,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Ícone e linha vertical
          Column(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: isHighlight ? colors.primary : cardBase,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isHighlight ? Colors.transparent : outline,
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 18,
                  color: isHighlight ? colors.onPrimary : (iconColor ?? mutedText),
                ),
              ),
              // Linha vertical conectando os itens
              Expanded(
                child: isLast 
                  ? const SizedBox.shrink() 
                  : Container(
                      width: 2, 
                      color: lineColor,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                    ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Detalhes do item
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: borderColor, width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title.trim().isEmpty ? "Sem título" : title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isHighlight ? colors.primary : onSurface,
                      ),
                    ),
                    if (description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(color: mutedText, fontSize: 13, height: 1.3),
                      ),
                    ],
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined, size: 14, color: isHighlight ? colors.primary : mutedText),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: TextStyle(
                                color: isHighlight ? colors.primary.withValues(alpha: 0.9) : mutedText,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}