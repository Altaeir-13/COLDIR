import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class DetailsPage extends StatelessWidget {
  final String title;
  final String status;
  final String date;

  const DetailsPage({
    super.key,
    required this.title,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color onSurface = colors.onSurface;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color background = colors.surface;
    final Color avatarBg = isDark
      ? colors.surfaceContainerHighest
      : colors.surfaceContainerHighest.withValues(alpha: 0.7);
    final Color dividerColor = colors.outline.withValues(alpha: isDark ? 0.35 : 0.18);
    final textTheme = Theme.of(context).textTheme;
    String t(String key) => context.t(key);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: onSurface),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          t('detailsTitle'),
          style: textTheme.titleLarge?.copyWith(color: onSurface),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            
            // Cabeçalho do Evento
            Row(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: avatarBg,
                    shape: BoxShape.circle,
                    border: Border.all(color: colors.outline.withValues(alpha: isDark ? 0.4 : 0.25)),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Image.asset('assets/if.png', fit: BoxFit.contain),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title, // Título dinâmico
                        style: textTheme.titleLarge?.copyWith(color: onSurface),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        status.toUpperCase(),
                        style: textTheme.labelMedium?.copyWith(
                          color: onSurface.withValues(alpha: 0.6),
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Botão do Certificado
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, color: Colors.white),
                label: Text(
                  t('certificateButton'),
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ),

            const SizedBox(height: 30),
            Divider(color: dividerColor, thickness: 1),
            const SizedBox(height: 30),

            // Informações Extras
            Text(
              t('completionDate'),
              style: textTheme.bodyMedium?.copyWith(
                color: onSurface.withValues(alpha: 0.65),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              date, // Data dinâmica
              style: textTheme.titleMedium?.copyWith(
                color: onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              t('meetingDocuments'),
              style: textTheme.titleSmall?.copyWith(color: onSurface),
            ),
            
            // Adicionar lista de documentos e informações extras aqui
          ],
        ),
      ),
    );
  }
}