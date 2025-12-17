import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Sign in anonymously if needed
  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('bs'), // Bosnian (default)
        Locale('en'), // English
        Locale('hr'), // Croatian
        Locale('sr'), // Serbian
        Locale('de'), // German
        Locale('tr'), // Turkish
      ],
      path: 'assets/locales',
      fallbackLocale: const Locale('bs'),
      startLocale: const Locale('bs'),
      child: const ProviderScope(
        child: TherapyWebApp(),
      ),
    ),
  );
}

class TherapyWebApp extends StatelessWidget {
  const TherapyWebApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Therapy AI - Web UI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: AppRoutes.settings,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

