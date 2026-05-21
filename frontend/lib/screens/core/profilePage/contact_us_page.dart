import 'package:flutter/material.dart';
import 'package:fadir/providers/language_provider.dart';

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    String t(String key) => context.t(key);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(t('contactUs')),
        centerTitle: true,
        backgroundColor: colors.surface,
        elevation: 0,
        iconTheme: IconThemeData(color: colors.onSurface),
        titleTextStyle: TextStyle(color: colors.onSurface, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              t('contactHeading'),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              t('contactDescription'),
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
            const SizedBox(height: 30),
            
            _buildContactCard(
              context: context,
              icon: Icons.email_outlined,
              title: t('emailLabel'),
              content: "suporte@fadir.edu.br",
              color: Colors.blue,
              onTap: () {
                // Lógica para abrir app de email
              },
            ),
            _buildContactCard(
              context: context,
              icon: Icons.phone_outlined,
              title: t('phoneLabel'),
              content: "(99) 3421-0000",
              color: Colors.green,
              onTap: () {
                // Lógica para discar
              },
            ),
            _buildContactCard(
              context: context,
              icon: Icons.location_on_outlined,
              title: t('addressLabel'),
              content: "Campus Caxias - MA\nRodovia MA-034, Km 02",
              color: Colors.red,
              onTap: () {
                // Lógica para abrir mapa
              },
            ),

            const SizedBox(height: 30),
            Text(
              t('socialNetworks'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(Icons.facebook, Colors.blue[800]!),
                _buildSocialButton(Icons.camera_alt, Colors.pink), // Instagram fake icon
                _buildSocialButton(Icons.language, Colors.blue), // Website
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String content,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: Theme.of(context).brightness == Brightness.dark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(15),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          content,
          style: TextStyle(color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
