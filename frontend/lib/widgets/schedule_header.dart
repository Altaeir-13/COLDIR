import 'package:flutter/material.dart';

class ScheduleHeader extends StatelessWidget {
  final String eventName;
  final String location;
  final String date;

  const ScheduleHeader({
    super.key,
    required this.eventName,
    required this.location,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final onSurface = colors.onSurface;
    // Distinct style from list cards: use slightly stronger tint and rounded badge.
    final cardColor = Color.alphaBlend(colors.primary.withValues(alpha: isDark ? 0.14 : 0.08), colors.surface);
    final shadowColor = colors.shadow.withValues(alpha: isDark ? 0.4 : 0.12);
    final borderColor = colors.primary.withValues(alpha: isDark ? 0.45 : 0.3);
    final muted = onSurface.withValues(alpha: 0.72);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colors.onPrimary.withValues(alpha: isDark ? 0.12 : 0.16),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.calendar_today, color: colors.onPrimaryContainer, size: 30),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventName,
                  style: textTheme.titleMedium?.copyWith(color: onSurface),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: muted),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: muted),
                    const SizedBox(width: 4),
                    Text(
                      date,
                      style: textTheme.bodySmall?.copyWith(color: muted),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}