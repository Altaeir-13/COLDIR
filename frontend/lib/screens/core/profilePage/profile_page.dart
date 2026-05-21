import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:fadir/providers/theme_provider.dart';
import 'package:fadir/providers/user_provider.dart';
import 'package:fadir/providers/language_provider.dart';
import 'package:fadir/widgets/profile_header.dart';
import 'package:fadir/widgets/profile_menu_item.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  
  // Função para pegar imagem da galeria
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted || pickedFile == null) return;

    // CORREÇÃO: Usando updateProfile em vez de setUserData inexistente
    context.read<UserProvider>().updateProfile(photoUrl: pickedFile.path);
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final themeProvider = context.watch<ThemeProvider>();
    final languageProvider = context.watch<LanguageProvider>();

    String t(String key) => context.t(key);
    String languageLabel() {
      switch (languageProvider.locale.languageCode) {
        case 'en':
          return t('english');
        case 'es':
          return t('spanish');
        case 'pt':
        default:
          return t('portuguese');
      }
    }
    final userName = userProvider.userName;
    final userEmail = userProvider.email;
    final userPhone = userProvider.phoneNumber;

    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // HEADER
            ProfileHeader(
              name: userName,
              email: userEmail,
              phone: userPhone,
              imageUrl: userProvider.profilePicturePath ?? 'assets/default_user.png',
              onEditImage: _pickImage,
            ),

            const SizedBox(height: 20),

            // ITENS DO MENU
            ProfileMenuItem(
              icon: Icons.edit_note,
              title: t('editProfile'),
              onTap: () {
                Navigator.pushNamed(context, "/edit_profile");
              },
            ),

            ProfileMenuItem(
              icon: Icons.notifications_none,
              title: t('notifications'),
              onTap: () {
                Navigator.pushNamed(context, "/notification");
              },
            ),

            ProfileMenuItem(
              icon: Icons.language,
              title: t('language'),
              trailing: Text(
                languageLabel(),
                style: const TextStyle(color: Colors.blue),
              ),
              onTap: () {
                Navigator.pushNamed(context, "/language");
              },
            ),

            const SizedBox(height: 20),

            ProfileMenuItem(
              icon: themeProvider.isDarkMode
                  ? Icons.dark_mode_outlined
                  : Icons.light_mode_outlined,
              title: t('theme'),
              trailing: Text(
                themeProvider.isDarkMode ? t('dark') : t('light'),
                style: const TextStyle(color: Colors.blue),
              ),
              onTap: themeProvider.toggleTheme,
            ),

            const SizedBox(height: 20),

            ProfileMenuItem(
              icon: Icons.help_outline,
              title: t('helpSupport'),
              onTap: () {
                Navigator.pushNamed(context, "/help_support");
              },
            ),

            ProfileMenuItem(
              icon: Icons.phone_in_talk_outlined,
              title: t('contactUs'),
              onTap: () {
                Navigator.pushNamed(context, "/contact_us");
              },
            ),

            ProfileMenuItem(
              icon: Icons.privacy_tip_outlined,
              title: t('privacyPolicy'),
              onTap: () {
                Navigator.pushNamed(context, "/privacy");
              },
            ),

            const SizedBox(height: 20),

            // Botão de Logout
            ProfileMenuItem(
              icon: Icons.logout,
              title: t('logout'),
              isDestructive: true,
              onTap: () {
                context.read<UserProvider>().logout();
                // Navega para a rota inicial '/' (Login) e remove o histórico
                Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}