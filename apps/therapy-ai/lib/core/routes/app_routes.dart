import 'package:flutter/material.dart';
import '../../screens/setup/child_profile_screen.dart';
import '../../screens/setup/voice_cloning_screen.dart';
import '../../screens/therapy/exercise_screen.dart';
import '../../screens/therapy/results_screen.dart';
import '../../screens/home/dashboard_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../main.dart';
import '../../models/exercise.dart';
import '../../models/speech_analysis_result.dart';

class AppRoutes {
  static const String splash = '/';
  static const String childProfile = '/child-profile';
  static const String voiceCloning = '/voice-cloning';
  static const String dashboard = '/home';
  static const String exercise = '/exercise';
  static const String exerciseResult = '/exercise-result';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case splash:
        return _buildRoute(
          const AppStartup(),
          settings: routeSettings,
        );

      case childProfile:
        return _buildRoute(
          const ChildProfileScreen(),
          settings: routeSettings,
        );

      case voiceCloning:
        return _buildRoute(
          const VoiceCloningScreen(),
          settings: routeSettings,
        );

      case dashboard:
        return _buildRoute(
          const DashboardScreen(),
          settings: routeSettings,
        );

      case AppRoutes.settings:
        return _buildRoute(
          const SettingsScreen(),
          settings: routeSettings,
        );

      case exerciseResult:
        final args = routeSettings.arguments;
        if (args is Map<String, dynamic> &&
            args['exercise'] != null &&
            args['result'] != null) {
          return _buildRoute(
            ResultsScreen(
              exercise: args['exercise'] as Exercise,
              result: args['result'] as SpeechAnalysisResult,
            ),
            settings: routeSettings,
          );
        }
        return _errorRoute('Result arguments missing');

      case exercise:
        final args = routeSettings.arguments;
        if (args is Map<String, dynamic> && args['exercise'] != null) {
          return _buildRoute(
            ExerciseScreen(
              exercise: args['exercise'] as Exercise,
            ),
            settings: routeSettings,
          );
        }
        return _errorRoute('Exercise argument missing');

      default:
        return _errorRoute('Route not found: ${routeSettings.name}');
    }
  }

  /// Erstellt eine Route mit sanften Übergangs-Animationen
  static PageRouteBuilder _buildRoute(
    Widget page, {
    required RouteSettings settings,
  }) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Fade + Slide Animation
        const begin = Offset(0.0, 0.1);
        const end = Offset.zero;
        const curve = Curves.easeOutCubic;

        final slideAnimation = Tween(begin: begin, end: end).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );

        final fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: animation,
            curve: curve,
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  static Route<dynamic> _errorRoute(String message) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('Error: $message'),
        ),
      ),
    );
  }
}

