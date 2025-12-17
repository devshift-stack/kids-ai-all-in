import 'package:flutter/material.dart';
import '../../screens/setup/child_profile_screen.dart';
import '../../screens/setup/voice_cloning_screen.dart';
import '../../screens/therapy/exercise_screen.dart';
import '../../screens/therapy/results_screen.dart';
import '../../screens/home/dashboard_screen.dart';
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

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const AppStartup(),
        );

      case childProfile:
        return MaterialPageRoute(
          builder: (_) => const ChildProfileScreen(),
        );

      case voiceCloning:
        return MaterialPageRoute(
          builder: (_) => const VoiceCloningScreen(),
        );

      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case exercise:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null && args['exercise'] != null) {
          return MaterialPageRoute(
            builder: (_) => ExerciseScreen(
              exercise: args['exercise'] as Exercise,
            ),
          );
        }
        return _errorRoute('Exercise argument missing');

      case exerciseResult:
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null &&
            args['exercise'] != null &&
            args['result'] != null) {
          return MaterialPageRoute(
            builder: (_) => ResultsScreen(
              exercise: args['exercise'] as Exercise,
              result: args['result'] as SpeechAnalysisResult,
            ),
          );
        }
        return _errorRoute('Result arguments missing');

      default:
        return _errorRoute('Route not found: ${settings.name}');
    }
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

