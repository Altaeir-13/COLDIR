import 'package:fadir/providers/feed_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'providers/locations_provider.dart';
import 'providers/places_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/language_provider.dart';
import 'providers/reuniao_provider.dart';
import 'theme/app_theme.dart';

import 'screens/onboarding/splash_screen.dart';
import 'screens/core/profilePage/help_support_page.dart';
import 'screens/core/profilePage/contact_us_page.dart';
import 'screens/core/profilePage/privacy_policy_page.dart';
import 'screens/core/profilePage/notifications_page.dart';
import 'screens/core/profilePage/edit_profile_page.dart';
import 'screens/core/profilePage/language_page.dart';
import 'screens/onboarding/registration_page.dart';
import 'screens/core/meeting/create_meeting_page.dart';
import 'screens/core/meeting/edit_meeting_page.dart';

// Arquivo principal da aplicação.
// Configura os Providers, tema, idioma e rotas globais do app.

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => LocationsProvider()),
        ChangeNotifierProvider(create: (_) => PlacesProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => FeedProvider()),
        ChangeNotifierProvider(create: (_) => ReuniaoProvider()),
      ],
      child: Consumer2<ThemeProvider, LanguageProvider>(
        builder: (context, themeProvider, languageProvider, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            locale: languageProvider.locale,
            supportedLocales: const [Locale('pt'), Locale('en')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            themeMode: themeProvider.themeMode,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            home: const SplashScreen(),
            routes: {
              '/create_meeting': (context) => const CreateMeetingPage(),
              '/edit_meeting': (context) => const EditMeetingPage(),
              '/registrarion': (context) => const RegistrationPage(),
              '/edit_profile': (context) => const EditProfilePage(),
              '/notification': (context) => const NotificationsPage(),
              '/language': (context) => const LanguagePage(),
              '/help_support': (context) => const HelpSupportPage(),
              '/contact_us': (context) => const ContactUsPage(),
              '/privacy': (context) => const PrivacyPolicyPage(),
            },
          );
        },
      ),
    );
  }
}
