import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import '../models/child_profile.dart';
import '../core/error_handler.dart';

/// Child Profile State
class ChildProfileState {
  final ChildProfile? profile;
  final bool isLoading;
  final String? error;

  const ChildProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
  });

  ChildProfileState copyWith({
    ChildProfile? profile,
    bool? isLoading,
    String? error,
  }) {
    return ChildProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Child Profile Notifier
class ChildProfileNotifier extends StateNotifier<ChildProfileState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _hiveBoxName = 'child_profile';

  ChildProfileNotifier() : super(const ChildProfileState()) {
    _loadProfile();
  }

  /// Lädt Profil aus Hive (lokal) oder Firebase
  Future<void> _loadProfile() async {
    try {
      state = state.copyWith(isLoading: true);

      // Versuche zuerst aus Hive zu laden
      final box = await Hive.openBox(_hiveBoxName);
      final profileJson = box.get('profile');

      if (profileJson != null) {
        final profile = ChildProfile.fromJson(profileJson as Map<String, dynamic>);
        state = state.copyWith(profile: profile, isLoading: false);
        
        // Synchronisiere mit Firebase im Hintergrund
        _syncWithFirebase(profile);
        return;
      }

      // Falls nicht lokal vorhanden, lade aus Firebase
      try {
        final profileDoc = await _firestore
            .collection('child_profiles')
            .limit(1)
            .get();

        if (profileDoc.docs.isNotEmpty) {
          final profileData = profileDoc.docs.first.data();
          final profile = ChildProfile.fromJson(profileData);
          
          // Speichere lokal für schnelleren Zugriff
          await box.put('profile', profile.toJson());
          
          state = state.copyWith(profile: profile, isLoading: false);
          return;
        }
      } catch (e) {
        // Firebase-Fehler ignorieren, verwende lokale Daten
        debugPrint('Fehler beim Laden aus Firebase: $e');
      }

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Fehler beim Laden: $e',
      );
    }
  }

  /// Speichert Profil lokal und in Firebase
  Future<void> saveProfile(ChildProfile profile) async {
    try {
      state = state.copyWith(isLoading: true);

      // Speichere lokal in Hive (immer, auch bei Firebase-Fehler)
      final box = await Hive.openBox(_hiveBoxName);
      await box.put('profile', profile.toJson());

      // Speichere in Firebase mit Retry-Logik
      await ErrorHandler.executeWithRetry(
        function: () async {
          await _firestore
              .collection('child_profiles')
              .doc(profile.id)
              .set(profile.toJson());
        },
        onRetry: (attempt, delay) {
          debugPrint('Retry $attempt nach ${delay.inSeconds}s...');
        },
      );

      state = state.copyWith(
        profile: profile,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      // Profil wurde lokal gespeichert, auch wenn Firebase fehlschlägt
      final errorMessage = ErrorHandler.handleFirebaseError(e);
      
      state = state.copyWith(
        profile: profile, // Profil ist lokal gespeichert
        isLoading: false,
        error: 'Warnung: $errorMessage (Daten lokal gespeichert)',
      );
    }
  }

  /// Aktualisiert Voice ID im Profil
  Future<void> updateVoiceId(String voiceId) async {
    if (state.profile == null) return;

    try {
      state = state.copyWith(isLoading: true);

      final updatedProfile = state.profile!.copyWith(
        clonedVoiceId: voiceId,
        updatedAt: DateTime.now(),
      );

      await saveProfile(updatedProfile);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Fehler beim Aktualisieren: $e',
      );
    }
  }

  /// Aktualisiert Skill Level
  Future<void> updateSkillLevel(int skillLevel) async {
    if (state.profile == null) return;

    try {
      final updatedProfile = state.profile!.copyWith(
        currentSkillLevel: skillLevel.clamp(1, 10),
        updatedAt: DateTime.now(),
      );

      await saveProfile(updatedProfile);
    } catch (e) {
      state = state.copyWith(
        error: 'Fehler beim Aktualisieren: $e',
      );
    }
  }

  /// Synchronisiert mit Firebase im Hintergrund
  Future<void> _syncWithFirebase(ChildProfile profile) async {
    try {
      await ErrorHandler.executeWithRetry(
        function: () async {
          await _firestore
              .collection('child_profiles')
              .doc(profile.id)
              .set(profile.toJson(), SetOptions(merge: true));
        },
        maxRetries: 2, // Weniger Retries für Hintergrund-Sync
      );
    } catch (e) {
      // Fehler ignorieren, da es nur eine Hintergrund-Synchronisation ist
      debugPrint('Fehler bei Firebase-Synchronisation: ${ErrorHandler.handleFirebaseError(e)}');
    }
  }

  /// Löscht Profil
  Future<void> deleteProfile() async {
    if (state.profile == null) return;

    try {
      state = state.copyWith(isLoading: true);

      // Lösche lokal
      final box = await Hive.openBox(_hiveBoxName);
      await box.delete('profile');

      // Lösche aus Firebase
      await _firestore
          .collection('child_profiles')
          .doc(state.profile!.id)
          .delete();

      state = const ChildProfileState();
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Fehler beim Löschen: $e',
      );
    }
  }
}

/// Child Profile Provider
final childProfileProvider =
    StateNotifierProvider<ChildProfileNotifier, ChildProfileState>((ref) {
  return ChildProfileNotifier();
});

