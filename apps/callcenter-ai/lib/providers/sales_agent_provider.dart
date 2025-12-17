import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/sales_agent_service.dart';

/// Provider für SalesAgentService (Singleton)
final salesAgentServiceProvider = Provider<SalesAgentService>((ref) {
  return SalesAgentService();
});

