import 'dart:async';
import 'package:dio/dio.dart';

/// Error Handler für API-Calls
/// Bietet Retry-Logik und Error-Kategorisierung
class ErrorHandler {
  ErrorHandler._();

  /// Maximale Anzahl von Retry-Versuchen
  static const int maxRetries = 3;

  /// Basis-Delay für Exponential Backoff (in Sekunden)
  static const int baseDelaySeconds = 1;

  /// Führt eine Funktion mit Retry-Logik aus
  /// 
  /// [function] - Die auszuführende Funktion
  /// [maxRetries] - Maximale Anzahl von Versuchen (default: 3)
  /// [onRetry] - Callback vor jedem Retry
  /// 
  /// Returns: Ergebnis der Funktion
  static Future<T> executeWithRetry<T>({
    required Future<T> Function() function,
    int maxRetries = ErrorHandler.maxRetries,
    void Function(int attempt, Duration delay)? onRetry,
  }) async {
    int attempt = 0;
    Exception? lastException;

    while (attempt < maxRetries) {
      try {
        return await function();
      } on DioException catch (e) {
        lastException = e;
        attempt++;

        // Prüfe ob Retry sinnvoll ist
        if (!_shouldRetry(e) || attempt >= maxRetries) {
          throw _handleDioError(e);
        }

        // Exponential Backoff
        final delay = Duration(seconds: baseDelaySeconds * (1 << (attempt - 1)));
        
        if (onRetry != null) {
          onRetry(attempt, delay);
        }

        await Future.delayed(delay);
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());
        attempt++;

        if (attempt >= maxRetries) {
          break;
        }

        // Exponential Backoff
        final delay = Duration(seconds: baseDelaySeconds * (1 << (attempt - 1)));
        
        if (onRetry != null) {
          onRetry(attempt, delay);
        }

        await Future.delayed(delay);
      }
    }

    throw lastException ?? Exception('Unbekannter Fehler');
  }

  /// Prüft ob ein Fehler retry-würdig ist
  static bool _shouldRetry(DioException error) {
    // Retry bei Netzwerk-Fehlern oder Server-Fehlern (5xx)
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    // Retry bei Server-Fehlern (5xx)
    if (error.response != null) {
      final statusCode = error.response!.statusCode;
      if (statusCode != null && statusCode >= 500 && statusCode < 600) {
        return true;
      }
    }

    // Kein Retry bei Client-Fehlern (4xx) oder anderen Fehlern
    return false;
  }

  /// Behandelt DioException und gibt benutzerfreundliche Fehlermeldung
  static Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Verbindungs-Timeout. Bitte überprüfe deine Internetverbindung.');

      case DioExceptionType.connectionError:
        return Exception('Keine Internetverbindung. Bitte überprüfe deine Netzwerk-Einstellungen.');

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return Exception('Authentifizierung fehlgeschlagen. Bitte melde dich erneut an.');
        } else if (statusCode == 403) {
          return Exception('Zugriff verweigert. Du hast keine Berechtigung für diese Aktion.');
        } else if (statusCode == 404) {
          return Exception('Ressource nicht gefunden.');
        } else if (statusCode == 429) {
          return Exception('Zu viele Anfragen. Bitte warte einen Moment und versuche es erneut.');
        } else if (statusCode != null && statusCode >= 500) {
          return Exception('Server-Fehler. Bitte versuche es später erneut.');
        }
        return Exception('Fehler beim Laden der Daten. Status: $statusCode');

      case DioExceptionType.cancel:
        return Exception('Anfrage wurde abgebrochen.');

      case DioExceptionType.unknown:
      default:
        return Exception('Unbekannter Fehler: ${error.message}');
    }
  }


  /// Behandelt Firebase-Fehler
  static String handleFirebaseError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('permission') || errorString.contains('permission-denied')) {
      return 'Zugriff verweigert. Bitte überprüfe deine Berechtigungen.';
    }

    if (errorString.contains('network') || errorString.contains('unavailable')) {
      return 'Keine Internetverbindung. Die Daten werden lokal gespeichert und später synchronisiert.';
    }

    if (errorString.contains('not-found')) {
      return 'Daten nicht gefunden.';
    }

    if (errorString.contains('already-exists')) {
      return 'Diese Daten existieren bereits.';
    }

    if (errorString.contains('quota') || errorString.contains('limit')) {
      return 'Speicher-Limit erreicht. Bitte kontaktiere den Support.';
    }

    return 'Fehler beim Speichern: ${error.toString()}';
  }

  /// Behandelt allgemeine Fehler und gibt benutzerfreundliche Meldung
  static String handleError(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error).toString().replaceFirst('Exception: ', '');
    }

    if (error is Exception) {
      return error.toString().replaceFirst('Exception: ', '');
    }

    return 'Ein unerwarteter Fehler ist aufgetreten: ${error.toString()}';
  }

  /// Prüft ob ein Fehler retry-würdig ist (allgemein)
  static bool isRetryable(dynamic error) {
    if (error is DioException) {
      return _shouldRetry(error);
    }

    // Für andere Fehler: Standardmäßig nicht retry-würdig
    return false;
  }
}

/// Error-Kategorien für besseres Error-Handling
enum ErrorCategory {
  network,
  authentication,
  authorization,
  notFound,
  serverError,
  clientError,
  unknown,
}

/// Extension für Error-Kategorisierung
extension ErrorCategoryExtension on dynamic {
  ErrorCategory get category {
    if (this is DioException) {
      final dioError = this as DioException;
      
      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.connectionError) {
        return ErrorCategory.network;
      }

      final statusCode = dioError.response?.statusCode;
      if (statusCode == 401) {
        return ErrorCategory.authentication;
      } else if (statusCode == 403) {
        return ErrorCategory.authorization;
      } else if (statusCode == 404) {
        return ErrorCategory.notFound;
      } else if (statusCode != null && statusCode >= 500) {
        return ErrorCategory.serverError;
      } else if (statusCode != null && statusCode >= 400) {
        return ErrorCategory.clientError;
      }
    }

    return ErrorCategory.unknown;
  }
}

