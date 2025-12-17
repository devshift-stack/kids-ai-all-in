import 'package:flutter/material.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/avatar/avatar_upload_screen.dart';
import '../../screens/language/language_settings_screen.dart';
import '../../screens/phoneme/phoneme_settings_screen.dart';

/// App Routes für Web UI
class AppRoutes {
  static const String settings = '/';
  static const String avatar = '/avatar';
  static const String language = '/language';
  static const String phoneme = '/phoneme';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case AppRoutes.avatar:
        return MaterialPageRoute(
          builder: (_) => const AvatarUploadScreen(),
        );

      case AppRoutes.language:
        return MaterialPageRoute(
          builder: (_) => const LanguageSettingsScreen(),
        );

      case AppRoutes.phoneme:
        return MaterialPageRoute(
          builder: (_) => const PhonemeSettingsScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Route ${settings.name} nicht gefunden'),
            ),
          ),
        );
    }
  }
}

