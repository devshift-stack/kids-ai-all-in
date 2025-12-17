import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'firebase_options.dart';

import 'core/theme/app_theme.dart';
import 'services/age_adaptive_service.dart';
import 'services/user_profile_service.dart';
import 'services/firebase_service.dart';
import 'services/parent_child_service.dart';
import 'screens/language_selection/language_selection_screen.dart';
import 'screens/profile_selection/profile_selection_screen.dart';

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

  // Set preferred orientations for children
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: AppTheme.backgroundColor,
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
        child: const AlankoApp(),
      ),
    ),
  );
}

class AlankoApp extends ConsumerWidget {
  const AlankoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Alanko AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const AppStartup(),
    );
  }
}

class AppStartup extends ConsumerStatefulWidget {
  const AppStartup({super.key});

  @override
  ConsumerState<AppStartup> createState() => _AppStartupState();
}

class _AppStartupState extends ConsumerState<AppStartup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'main.dart:139',
        'message': 'App initialization started',
        'data': {},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion
    
    // Initialize Firebase services
    final firebaseService = ref.read(firebaseServiceProvider);

    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'main.dart:147',
        'message': 'Firebase service obtained',
        'data': {'isSignedIn': firebaseService.isSignedIn},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion

    // Enable offline mode
    await firebaseService.enableOfflineMode();

    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'main.dart:160',
        'message': 'Offline mode enabled',
        'data': {},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion

    // Sign in anonymously to Firebase
    if (!firebaseService.isSignedIn) {
      await firebaseService.signInAnonymously();
      
      // #region agent log
      try {
        final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
        final logData = jsonEncode({
          'location': 'main.dart:171',
          'message': 'Anonymous sign-in completed',
          'data': {'userId': firebaseService.currentUser?.uid},
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'sessionId': 'debug-session',
          'runId': 'run1',
          'hypothesisId': 'A'
        });
        await logFile.writeAsString('$logData\n', mode: FileMode.append);
      } catch (_) {}
      // #endregion
    }

    // Initialize Parent-Child Service (für parentId/childId)
    final parentChildService = ref.read(parentChildServiceProvider);
    await parentChildService.initialize();

    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'main.dart:186',
        'message': 'ParentChildService initialized',
        'data': {
          'parentId': parentChildService.parentId,
          'childId': parentChildService.activeChildId,
          'hasLinkedChildren': parentChildService.hasLinkedChildren
        },
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion

    // Simulate initialization time for splash effect
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isInitialized = true);
      _navigateToApp();
      
      // #region agent log
      try {
        final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
        final logData = jsonEncode({
          'location': 'main.dart:207',
          'message': 'App initialization completed, navigating',
          'data': {},
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'sessionId': 'debug-session',
          'runId': 'run1',
          'hypothesisId': 'A'
        });
        await logFile.writeAsString('$logData\n', mode: FileMode.append);
      } catch (_) {}
      // #endregion
    }
  }

  void _navigateToApp() {
    // Check if profiles exist
    final profileService = ref.read(multiProfileServiceProvider);
    final hasProfiles = profileService.hasProfiles;

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            hasProfiles
                ? const ProfileSelectionScreen()
                : const LanguageSelectionScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F4FD),
              Color(0xFFF8F9FF),
            ],
          ),
        ),
        child: Center(
          child: CustomAnimatedBuilder(
            listenable: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // App Logo
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(alpha: 0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/logo_256.png',
                            width: 150,
                            height: 150,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback falls Asset nicht gefunden
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: AppTheme.alanGradient,
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'A',
                                    style: TextStyle(
                                      fontSize: 72,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Alanko AI',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Learn. Play. Grow.',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 48),
                      if (!_isInitialized)
                        SizedBox(
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor.withValues(alpha: 0.5),
                            ),
                            strokeWidth: 3,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomAnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext context, Widget? child) builder;
  final Widget? child;

  const CustomAnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
