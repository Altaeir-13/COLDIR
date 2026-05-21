import 'package:flutter/material.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String status;
  final String date;
  final VoidCallback onTap;

  const HistoryItem({
    super.key,
    required this.title,
    required this.status,
    required this.date,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final surface = colors.surface;
    final onSurface = colors.onSurface;
    final textTheme = Theme.of(context).textTheme;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = isDark ? colors.surfaceContainerHighest : surface;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: colors.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.18),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
              spreadRadius: 1,
            ),
            BoxShadow(
              color: colors.primary.withValues(alpha: isDark ? 0.12 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Logo Pequeno
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Image.asset(
                  'assets/logo.png', 
                  fit: BoxFit.contain,
                  errorBuilder: (c,e,s) => const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 15),
            
            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      color: onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    status,
                    style: textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            
            // Seta
            Icon(Icons.north_east, color: colors.onSurfaceVariant, size: 20),
          ],
        ),
      ),
    );
  }
}