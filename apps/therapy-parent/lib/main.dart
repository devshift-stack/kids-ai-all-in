import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  // Initialize Hive for local storage
  await Hive.initFlutter();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

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
      child: ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const TherapyParentApp(),
      ),
    ),
  );
}

class TherapyParentApp extends ConsumerWidget {
  const TherapyParentApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Therapy Parent Dashboard',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      initialRoute: AppRoutes.dashboard,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}

