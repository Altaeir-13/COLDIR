import 'package:flutter/material.dart';

class ProfileMenuItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive; // Para destacar o botão "Sair" em vermelho
  final Widget? trailing;

  const ProfileMenuItem({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark ? colors.surfaceContainerHighest : colors.surface;
    final iconBg = isDestructive
        ? Colors.red.withValues(alpha: 0.12)
        : colors.primary.withValues(alpha: 0.12);
    final iconColor = isDestructive ? Colors.red : colors.primary;
    final textColor = isDestructive ? Colors.red : colors.onSurface;
    final shadowColor = Colors.black.withValues(alpha: isDark ? 0.35 : 0.12);
    final tintedShadow = colors.primary.withValues(alpha: isDark ? 0.12 : 0.05);
    final borderColor = colors.outlineVariant.withValues(alpha: isDark ? 0.35 : 0.18);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Material(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        elevation: 0,
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 18,
                offset: const Offset(0, 8),
                spreadRadius: 1,
              ),
              BoxShadow(
                color: tintedShadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  // Ícone com fundo colorido leve
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconBg,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 15),

                  // Texto
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                  ),

                  // Trailing widget ou Setinha no final
                  if (trailing != null)
                    trailing!
                  else
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: colors.outlineVariant,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}