import 'package:flutter/material.dart';
import '../../screens/dashboard/dashboard_screen.dart';
import '../../screens/children/child_list_screen.dart';
import '../../screens/children/child_detail_screen.dart';
import '../../screens/settings/settings_screen.dart';
import '../../screens/export/export_screen.dart';

/// App Routes für Parent Dashboard
class AppRoutes {
  static const String dashboard = '/';
  static const String childList = '/children';
  static const String childDetail = '/children/:id';
  static const String settings = '/settings';
  static const String export = '/export';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case childList:
        return MaterialPageRoute(
          builder: (_) => const ChildListScreen(),
        );

      case childDetail:
        final childId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ChildDetailScreen(childId: childId ?? ''),
        );

      case settings:
        return MaterialPageRoute(
          builder: (_) => const SettingsScreen(),
        );

      case export:
        return MaterialPageRoute(
          builder: (_) => const ExportScreen(),
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

