import 'package:flutter/material.dart';

// BOTÃO COM GRADIENTE
class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed; // Permitir nulo para desabilitar
  final List<Color> colors;
  final bool isLoading; // <-- NOVO CAMPO

  const GradientButton({
    super.key, 
    required this.text, 
    required this.onPressed,
    this.colors = const [Color(0xFF147A6D), Color(0xFF0E564D)],
    this.isLoading = false, // <-- PADRÃO É FALSE
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isLoading ? [Colors.grey, Colors.grey] : colors, // Cinza se carregando
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          if (!isLoading) // Sem sombra se estiver carregando
            BoxShadow(
              color: colors.last.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
        ]
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed, // Trava o clique
          borderRadius: BorderRadius.circular(25),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    text,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}

// BOTÃO QUADRADO COM ÍCONE (Locais, Documentos, ...)
class SquareIconButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const SquareIconButton({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.9),
              color,
            ],
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}