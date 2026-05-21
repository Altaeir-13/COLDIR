import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(
          t('helpSupport'),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: TextStyle(color: colors.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            t('faqTitle'),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          _buildFaqItem(
            t('faqChangePasswordQ'),
            t('faqChangePasswordA'),
          ),
          _buildFaqItem(
            t('faqSeeSchedulesQ'),
            t('faqSeeSchedulesA'),
          ),
          _buildFaqItem(
            t('faqContactCoordinationQ'),
            t('faqContactCoordinationA'),
          ),
          _buildFaqItem(
            t('faqOfflineQ'),
            t('faqOfflineA'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              answer,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
