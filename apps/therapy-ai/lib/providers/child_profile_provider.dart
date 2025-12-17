import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/child_profile.dart';

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
      // TODO: Implementiere Firebase-Laden wenn nötig

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

      // Speichere lokal in Hive
      final box = await Hive.openBox(_hiveBoxName);
      await box.put('profile', profile.toJson());

      // Speichere in Firebase
      await _firestore
          .collection('child_profiles')
          .doc(profile.id)
          .set(profile.toJson());

      state = state.copyWith(
        profile: profile,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Fehler beim Speichern: $e',
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
      await _firestore
          .collection('child_profiles')
          .doc(profile.id)
          .set(profile.toJson(), SetOptions(merge: true));
    } catch (e) {
      // Fehler ignorieren, da es nur eine Hintergrund-Synchronisation ist
      print('Fehler bei Firebase-Synchronisation: $e');
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

