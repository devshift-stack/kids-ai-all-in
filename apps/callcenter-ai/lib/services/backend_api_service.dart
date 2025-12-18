import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

/// Backend API Service für Multi-Session Support
/// 
/// Kommuniziert mit dem Backend-Server statt direkt mit Gemini
class BackendApiService {
  final String baseUrl;
  String? _currentSessionId;

  BackendApiService({
    String? baseUrl,
  }) : baseUrl = baseUrl ?? 'http://localhost:3000';

  /// Aktuelle Session ID
  String? get currentSessionId => _currentSessionId;

  /// Prüft ob Backend erreichbar ist
  Future<bool> checkHealth() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/health'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Backend Health Check fehlgeschlagen: $e');
      }
      return false;
    }
  }

  /// Erstellt eine neue Chat-Session
  Future<SessionResponse> createSession({String language = 'german'}) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/sessions'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'language': language}),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _currentSessionId = data['sessionId'] as String;
        
        return SessionResponse(
          sessionId: _currentSessionId!,
          greeting: data['greeting'] as String,
          success: true,
          language: data['language'] as String? ?? language,
        );
      } else {
        throw Exception('Session-Erstellung fehlgeschlagen: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Session-Erstellung Fehler: $e');
      }
      return SessionResponse(
        sessionId: '',
        greeting: '',
        success: false,
        error: e.toString(),
        language: language,
      );
    }
  }

  /// Sendet eine Nachricht an die aktuelle Session
  Future<ChatResponse> sendMessage(String message) async {
    if (_currentSessionId == null) {
      // Session erstellen falls nicht vorhanden
      final session = await createSession();
      if (!session.success) {
        return ChatResponse(
          response: 'Fehler: Konnte keine Session erstellen',
          success: false,
          error: session.error,
        );
      }
    }

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/v1/sessions/$_currentSessionId/chat'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ChatResponse(
          response: data['response'] as String,
          success: true,
        );
      } else {
        final errorData = json.decode(response.body);
        return ChatResponse(
          response: errorData['error'] as String? ?? 'Unbekannter Fehler',
          success: false,
          error: errorData['error'] as String?,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Chat-Fehler: $e');
      }
      return ChatResponse(
        response: 'Entschuldigung, es ist ein Fehler aufgetreten. Können Sie Ihre Frage bitte wiederholen?',
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Beendet die aktuelle Session
  Future<void> endSession() async {
    if (_currentSessionId == null) return;

    try {
      await http.delete(
        Uri.parse('$baseUrl/api/v1/sessions/$_currentSessionId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 5));
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Session-Beendung Fehler: $e');
      }
    } finally {
      _currentSessionId = null;
    }
  }
}

/// Response-Model für Session-Erstellung
class SessionResponse {
  final String sessionId;
  final String greeting;
  final bool success;
  final String? error;
  final String language;

  SessionResponse({
    required this.sessionId,
    required this.greeting,
    required this.success,
    this.error,
    this.language = 'german',
  });
}

/// Response-Model für Chat-Nachrichten
class ChatResponse {
  final String response;
  final bool success;
  final String? error;

  ChatResponse({
    required this.response,
    required this.success,
    this.error,
  });
}

