import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryText = colors.onSurface;
    final secondaryText = isDark ? Colors.white70 : Colors.grey[700];
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(t('privacyPolicy')),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: TextStyle(color: colors.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                t('lastUpdate'),
                style: TextStyle(color: secondaryText, fontSize: 12),
              ),
              const SizedBox(height: 20),
              _buildSection(
                "1. ${t('privacyIntroTitle')}",
                t('privacyIntro'),
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _buildSection(
                "2. ${t('privacyDataTitle')}",
                t('privacyDataCollection'),
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _buildSection(
                "3. ${t('privacyUsageTitle')}",
                t('privacyUsage'),
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _buildSection(
                "4. ${t('privacySharingTitle')}",
                t('privacySharing'),
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              _buildSection(
                "5. ${t('privacySecurityTitle')}",
                t('privacySecurity'),
                primaryText: primaryText,
                secondaryText: secondaryText,
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  t('privacyFooter'),
                  style: TextStyle(fontWeight: FontWeight.bold, color: colors.primary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, {required Color primaryText, required Color? secondaryText}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: primaryText,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: secondaryText,
              height: 1.5,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
