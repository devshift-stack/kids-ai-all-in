import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/parent_child_service.dart';
import '../services/firebase_service.dart';

/// Provider für die aktuelle Parent-ID
final currentParentIdProvider = Provider<String?>((ref) {
  return ref.watch(parentChildServiceProvider).parentId;
});

/// Provider für die aktuelle Child-ID
final currentChildIdProvider = Provider<String?>((ref) {
  return ref.watch(parentChildServiceProvider).activeChildId;
});

/// Provider für Firebase Service mit automatischem Context
final firebaseServiceWithContextProvider = Provider<FirebaseServiceWithContext>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  final parentId = ref.watch(currentParentIdProvider);
  final childId = ref.watch(currentChildIdProvider);
  
  return FirebaseServiceWithContext(
    firebaseService: firebaseService,
    parentId: parentId,
    childId: childId,
  );
});

/// Wrapper für FirebaseService mit automatischem Context
class FirebaseServiceWithContext {
  final FirebaseService firebaseService;
  final String? parentId;
  final String? childId;

  FirebaseServiceWithContext({
    required this.firebaseService,
    this.parentId,
    this.childId,
  });

  Future<void> saveChildProfile({
    required String name,
    required int age,
    required String preferredLanguage,
    String? gender,
  }) {
    return firebaseService.saveChildProfile(
      name: name,
      age: age,
      preferredLanguage: preferredLanguage,
      gender: gender,
      parentId: parentId,
      childId: childId,
    );
  }

  Future<Map<String, dynamic>?> getChildProfile() {
    return firebaseService.getChildProfile(
      parentId: parentId,
      childId: childId,
    );
  }

  Future<void> saveLearningProgress({
    required String topic,
    required int score,
    required int totalQuestions,
    required Duration timeSpent,
  }) {
    return firebaseService.saveLearningProgress(
      topic: topic,
      score: score,
      totalQuestions: totalQuestions,
      timeSpent: timeSpent,
      parentId: parentId,
      childId: childId,
    );
  }

  Future<List<Map<String, dynamic>>> getLearningProgress({
    String? topic,
    int limit = 50,
  }) {
    return firebaseService.getLearningProgress(
      topic: topic,
      limit: limit,
      parentId: parentId,
      childId: childId,
    );
  }

  // Weitere Methoden delegieren
  User? get currentUser => firebaseService.currentUser;
  bool get isSignedIn => firebaseService.isSignedIn;
  Future<void> enableOfflineMode() => firebaseService.enableOfflineMode();
  Future<UserCredential?> signInAnonymously() => firebaseService.signInAnonymously();
  Future<void> signOut() => firebaseService.signOut();
  Future<void> logEvent(String name, Map<String, dynamic>? parameters) => 
      firebaseService.logEvent(name, parameters);
  Future<void> logScreenView(String screenName) => 
      firebaseService.logScreenView(screenName);
  Future<void> setUserProperties({required int age, required String language}) => 
      firebaseService.setUserProperties(age: age, language: language);
  Future<void> saveLeaderboardScore({
    required String gameType,
    required int score,
    required String displayName,
  }) => firebaseService.saveLeaderboardScore(
    gameType: gameType,
    score: score,
    displayName: displayName,
  );
  Future<List<Map<String, dynamic>>> getLeaderboard({
    required String gameType,
    int limit = 10,
  }) => firebaseService.getLeaderboard(gameType: gameType, limit: limit);
}

