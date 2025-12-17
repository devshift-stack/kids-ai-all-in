import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Service für Lianko
/// Verwaltet Authentifizierung, Benutzerdaten und Lernfortschritt
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Aktuelle User-ID
  String? get currentUserId => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;

  // ============================================================
  // AUTHENTICATION
  // ============================================================

  /// Anonyme Anmeldung (für Kinder ohne Account)
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      if (kDebugMode) {
        print('Signed in anonymously: ${credential.user?.uid}');
      }
      return credential;
    } catch (e) {
      if (kDebugMode) {
        print('Anonymous sign-in failed: $e');
      }
      return null;
    }
  }

  /// Abmelden
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print('Sign out failed: $e');
      }
    }
  }

  // ============================================================
  // CHILD PROFILE
  // ============================================================

  /// Speichert Kinderprofil
  Future<void> saveChildProfile({
    required String name,
    required int age,
    required String preferredLanguage,
    String? avatarUrl,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      await _firestore.collection('children').doc(uid).set({
        'name': name,
        'age': age,
        'preferredLanguage': preferredLanguage,
        'avatarUrl': avatarUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      if (kDebugMode) {
        print('Save child profile failed: $e');
      }
    }
  }

  /// Lädt Kinderprofil
  Future<Map<String, dynamic>?> getChildProfile() async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final doc = await _firestore.collection('children').doc(uid).get();
      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('Get child profile failed: $e');
      }
      return null;
    }
  }

  // ============================================================
  // LEARNING PROGRESS
  // ============================================================

  /// Speichert Lernfortschritt
  Future<void> saveLearningProgress({
    required String topic,
    required int score,
    required int totalQuestions,
    required Duration timeSpent,
    String? difficulty,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      // Einzelnen Fortschritt speichern
      await _firestore
          .collection('children')
          .doc(uid)
          .collection('progress')
          .add({
        'topic': topic,
        'score': score,
        'totalQuestions': totalQuestions,
        'percentage': (score / totalQuestions * 100).round(),
        'timeSpentSeconds': timeSpent.inSeconds,
        'difficulty': difficulty,
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Gesamtstatistik aktualisieren
      await _updateOverallStats(topic, score, totalQuestions);
    } catch (e) {
      if (kDebugMode) {
        print('Save learning progress failed: $e');
      }
    }
  }

  /// Aktualisiert Gesamtstatistik
  Future<void> _updateOverallStats(
    String topic,
    int score,
    int totalQuestions,
  ) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      final statsRef = _firestore
          .collection('children')
          .doc(uid)
          .collection('stats')
          .doc(topic);

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(statsRef);

        if (snapshot.exists) {
          final data = snapshot.data()!;
          final totalAttempts = (data['totalAttempts'] ?? 0) + 1;
          final totalScore = (data['totalScore'] ?? 0) + score;
          final totalPossible =
              (data['totalPossible'] ?? 0) + totalQuestions;

          transaction.update(statsRef, {
            'totalAttempts': totalAttempts,
            'totalScore': totalScore,
            'totalPossible': totalPossible,
            'averagePercentage': (totalScore / totalPossible * 100).round(),
            'lastPlayedAt': FieldValue.serverTimestamp(),
          });
        } else {
          transaction.set(statsRef, {
            'topic': topic,
            'totalAttempts': 1,
            'totalScore': score,
            'totalPossible': totalQuestions,
            'averagePercentage': (score / totalQuestions * 100).round(),
            'firstPlayedAt': FieldValue.serverTimestamp(),
            'lastPlayedAt': FieldValue.serverTimestamp(),
          });
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Update overall stats failed: $e');
      }
    }
  }

  /// Lädt Lernfortschritt für ein Thema
  Future<Map<String, dynamic>?> getTopicStats(String topic) async {
    final uid = currentUserId;
    if (uid == null) return null;

    try {
      final doc = await _firestore
          .collection('children')
          .doc(uid)
          .collection('stats')
          .doc(topic)
          .get();
      return doc.data();
    } catch (e) {
      if (kDebugMode) {
        print('Get topic stats failed: $e');
      }
      return null;
    }
  }

  /// Lädt alle Statistiken
  Future<List<Map<String, dynamic>>> getAllStats() async {
    final uid = currentUserId;
    if (uid == null) return [];

    try {
      final snapshot = await _firestore
          .collection('children')
          .doc(uid)
          .collection('stats')
          .get();
      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Get all stats failed: $e');
      }
      return [];
    }
  }

  // ============================================================
  // ANALYTICS / EVENTS
  // ============================================================

  /// Loggt ein Event (für Analytics)
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('children')
          .doc(uid)
          .collection('events')
          .add({
        'name': name,
        'parameters': parameters,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Log event failed: $e');
      }
    }
  }

  /// Loggt Screen View
  Future<void> logScreenView(String screenName) async {
    await logEvent('screen_view', {'screen_name': screenName});
  }

  /// Setzt User Properties
  Future<void> setUserProperties({
    required int age,
    required String language,
  }) async {
    final uid = currentUserId;
    if (uid == null) return;

    try {
      await _firestore.collection('children').doc(uid).update({
        'age': age,
        'preferredLanguage': language,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      if (kDebugMode) {
        print('Set user properties failed: $e');
      }
    }
  }
}

// ============================================================
// RIVERPOD PROVIDERS
// ============================================================

/// Firebase Service Provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService();
});

/// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Current User Provider
final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authStateProvider).value;
});

/// Child Profile Provider
final childProfileProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final service = ref.watch(firebaseServiceProvider);
  return service.getChildProfile();
});
