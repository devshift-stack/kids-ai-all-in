import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service für die Verbindung zwischen Kind-App und Eltern-Dashboard
class ParentLinkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _linkedChildIdKey = 'linked_child_id';
  static const String _linkedAtKey = 'linked_at';

  /// Verbindet Kind-Gerät mit ParentCode
  ///
  /// Der Code wird im ParentsDash generiert und hat ein Ablaufdatum.
  /// Nach erfolgreicher Verbindung werden Einstellungen synchronisiert.
  Future<LinkResult> linkWithParentCode(String code) async {
    try {
      final normalizedCode = code.toUpperCase().replaceAll(' ', '').replaceAll('-', '');

      // 1. Suche Kind mit diesem aktiven Code
      final query = await _firestore
          .collection('children')
          .where('parentCode', isEqualTo: normalizedCode)
          .where('parentCodeExpiresAt', isGreaterThan: Timestamp.now())
          .limit(1)
          .get();

      if (query.docs.isEmpty) {
        return LinkResult.invalid('Code ungültig oder abgelaufen');
      }

      final childDoc = query.docs.first;
      final childId = childDoc.id;
      final childData = childDoc.data();
      final childName = childData['name'] ?? 'Kind';

      // 2. Anonymous Auth für dieses Gerät (falls noch nicht vorhanden)
      if (_auth.currentUser == null) {
        await _auth.signInAnonymously();
      }
      final deviceId = _auth.currentUser!.uid;

      // 3. Gerät zum Kind hinzufügen in Firestore
      await _firestore.collection('children').doc(childId).update({
        'isLinked': true,
        'linkedDeviceIds': FieldValue.arrayUnion([deviceId]),
        'lastLinkedAt': FieldValue.serverTimestamp(),
      });

      // 4. Lokal speichern
      await _saveChildIdLocally(childId);

      return LinkResult.success(
        childId: childId,
        childName: childName,
      );
    } on FirebaseException catch (e) {
      return LinkResult.invalid('Firebase Fehler: ${e.message}');
    } catch (e) {
      return LinkResult.invalid('Verbindung fehlgeschlagen: $e');
    }
  }

  /// Holt die verknüpfte Child-ID aus lokalem Speicher
  Future<String?> getLinkedChildId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_linkedChildIdKey);
  }

  /// Prüft ob dieses Gerät mit einem Kind verknüpft ist
  Future<bool> isLinked() async {
    final childId = await getLinkedChildId();
    return childId != null && childId.isNotEmpty;
  }

  /// Trennt die Verbindung (Logout)
  Future<void> unlink() async {
    try {
      final childId = await getLinkedChildId();
      final deviceId = _auth.currentUser?.uid;

      if (childId != null && deviceId != null) {
        // Gerät aus Firestore entfernen
        await _firestore.collection('children').doc(childId).update({
          'linkedDeviceIds': FieldValue.arrayRemove([deviceId]),
        });
      }

      // Lokale Daten löschen
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_linkedChildIdKey);
      await prefs.remove(_linkedAtKey);

      // Auth abmelden
      await _auth.signOut();
    } catch (e) {
      // Fehler ignorieren beim Logout
    }
  }

  /// Speichert die Child-ID lokal
  Future<void> _saveChildIdLocally(String childId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_linkedChildIdKey, childId);
    await prefs.setString(_linkedAtKey, DateTime.now().toIso8601String());
  }
}

/// Ergebnis der Verknüpfung
class LinkResult {
  final bool isSuccess;
  final String? childId;
  final String? childName;
  final String? errorMessage;

  LinkResult._({
    required this.isSuccess,
    this.childId,
    this.childName,
    this.errorMessage,
  });

  factory LinkResult.success({
    required String childId,
    String? childName,
  }) =>
      LinkResult._(
        isSuccess: true,
        childId: childId,
        childName: childName,
      );

  factory LinkResult.invalid(String message) => LinkResult._(
        isSuccess: false,
        errorMessage: message,
      );
}

// Riverpod Providers
final parentLinkServiceProvider = Provider<ParentLinkService>((ref) {
  return ParentLinkService();
});

/// Provider für den aktuellen Link-Status
final isLinkedProvider = FutureProvider<bool>((ref) async {
  final service = ref.watch(parentLinkServiceProvider);
  return await service.isLinked();
});

/// Provider für die verknüpfte Child-ID
final linkedChildIdProvider = FutureProvider<String?>((ref) async {
  final service = ref.watch(parentLinkServiceProvider);
  return await service.getLinkedChildId();
});
