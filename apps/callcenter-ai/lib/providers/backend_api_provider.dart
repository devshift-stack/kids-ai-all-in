import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/backend_api_service.dart';

/// Provider für BackendApiService
/// 
/// Konfiguriere die Backend-URL hier:
/// - Lokal: http://localhost:3000
/// - Android Emulator: http://10.0.2.2:3000
/// - iOS Simulator: http://localhost:3000
/// - Production: https://your-backend.com
final backendApiServiceProvider = Provider<BackendApiService>((ref) {
  // Für Android-Emulator: http://10.0.2.2:3000
  // Für iOS Simulator: http://localhost:3000
  // Für physisches Gerät: IP-Adresse deines Macs (z.B. http://192.168.1.100:3000)
  return BackendApiService(
    baseUrl: 'http://10.0.2.2:3000', // Android Emulator
    // baseUrl: 'http://localhost:3000', // iOS Simulator / macOS
  );
});

