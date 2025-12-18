import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Firebase Service für Therapy AI
/// Verwaltet Authentifizierung, Benutzerdaten und Therapie-Fortschritt
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  bool _offlineEnabled = false;

  // Current user
  User? get currentUser => _auth.currentUser;
  bool get isSignedIn => currentUser != null;

  // Enable offline persistence
  Future<void> enableOfflineMode() async {
    if (_offlineEnabled) return;
    try {
      _firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      _offlineEnabled = true;
      debugPrint('Firebase: Offline mode enabled');
    } catch (e) {
      debugPrint('Firebase Offline Error: $e');
    }
  }

  // Auth methods
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      debugPrint('Firebase: Signed in anonymously as ${credential.user?.uid}');
      return credential;
    } catch (e) {
      debugPrint('Firebase Auth Error: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      debugPrint('Firebase: Signed out');
    } catch (e) {
      debugPrint('Firebase Sign Out Error: $e');
    }
  }

  // Firestore - Child Profile
  Future<void> saveChildProfile({
    required String name,
    required int age,
    required String preferredLanguage,
    String? gender,
    String? parentId,
    String? childId,
  }) async {
    if (currentUser == null) {
      await signInAnonymously();
    }
    
    final uid = currentUser?.uid ?? childId;
    if (uid == null) return;

    try {
      final profileData = {
        'name': name,
        'age': age,
        'preferredLanguage': preferredLanguage,
        'gender': gender,
        'parentId': parentId,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (parentId != null) {
        await _firestore
            .collection('parents')
            .doc(parentId)
            .collection('children')
            .doc(uid)
            .set(profileData, SetOptions(merge: true));
      } else {
        await _firestore.collection('children').doc(uid).set(profileData, SetOptions(merge: true));
      }

      debugPrint('Firebase: Child profile saved');
    } catch (e) {
      debugPrint('Firebase Save Error: $e');
    }
  }

  // Firestore - Therapy Session
  Future<void> saveTherapySession({
    required String childId,
    required Map<String, dynamic> sessionData,
  }) async {
    if (currentUser == null) {
      await signInAnonymously();
    }

    final uid = currentUser?.uid ?? childId;
    if (uid == null) return;

    try {
      await _firestore
          .collection('children')
          .doc(uid)
          .collection('therapy_sessions')
          .add({
        ...sessionData,
        'createdAt': FieldValue.serverTimestamp(),
      });

      debugPrint('Firebase: Therapy session saved');
    } catch (e) {
      debugPrint('Firebase Save Session Error: $e');
    }
  }

  // Analytics
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) async {
    try {
      await _analytics.logEvent(name: name, parameters: parameters);
    } catch (e) {
      debugPrint('Analytics Error: $e');
    }
  }
}
