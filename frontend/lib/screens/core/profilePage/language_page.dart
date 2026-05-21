import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fadir/providers/language_provider.dart';

class LanguagePage extends StatelessWidget {
  const LanguagePage({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final currentLocale = languageProvider.locale;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(AppStrings.of(context, 'language')),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: TextStyle(
          color: colors.onSurface,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            AppStrings.of(context, 'selectLanguage'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          _buildLanguageOption(
            context,
            title: 'Português',
            locale: const Locale('pt'),
            isSelected: currentLocale.languageCode == 'pt',
            onTap: () => languageProvider.setLocale(const Locale('pt')),
          ),
          const SizedBox(height: 15),
          _buildLanguageOption(
            context,
            title: 'English',
            locale: const Locale('en'),
            isSelected: currentLocale.languageCode == 'en',
            onTap: () => languageProvider.setLocale(const Locale('en')),
          ),
          const SizedBox(height: 15),
          _buildLanguageOption(
            context,
            title: 'Español',
            locale: const Locale('es'),
            isSelected: currentLocale.languageCode == 'es',
            onTap: () => languageProvider.setLocale(const Locale('es')),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context, {
    required String title,
    required Locale locale,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: isSelected
              ? Border.all(color: const Color(0xFF0E564D), width: 2)
              : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Bandeira (Simulada com ícone ou texto)
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    locale.languageCode.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0E564D),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? const Color(0xFF0E564D) : Colors.black87,
                  ),
                ),
              ],
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF0E564D),
              ),
          ],
        ),
      ),
    );
  }
}
