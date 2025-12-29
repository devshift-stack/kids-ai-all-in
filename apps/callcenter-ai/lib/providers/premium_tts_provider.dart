import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/premium_tts_service.dart';

/// Provider für Premium TTS Service
final premiumTtsServiceProvider = Provider<PremiumTtsService>((ref) {
  return PremiumTtsService();
});

