import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Service für Parent-Child Verknüpfung
/// Ermöglicht Eltern, Kinderprofile zu verwalten
class ParentChildService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  String? _parentId;
  String? _activeChildId;
  List<LinkedChild> _linkedChildren = [];
  bool _isInitialized = false;
  
  String? get parentId => _parentId;
  String? get activeChildId => _activeChildId;
  List<LinkedChild> get linkedChildren => List.unmodifiable(_linkedChildren);
  bool get hasLinkedChildren => _linkedChildren.isNotEmpty;
  bool get isInitialized => _isInitialized;
  
  /// Initialisiert den Service
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'parent_child_service.dart:28',
        'message': 'ParentChildService.initialize() called',
        'data': {'isInitialized': _isInitialized},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion
    
    final prefs = await SharedPreferences.getInstance();
    _parentId = prefs.getString('parent_id');
    _activeChildId = prefs.getString('active_child_id');
    
    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'parent_child_service.dart:40',
        'message': 'Loaded parentId and childId from SharedPreferences',
        'data': {'parentId': _parentId, 'activeChildId': _activeChildId},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion
    
    if (_parentId != null) {
      await _loadLinkedChildren();
      
      // #region agent log
      try {
        final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
        final logData = jsonEncode({
          'location': 'parent_child_service.dart:52',
          'message': 'Linked children loaded',
          'data': {'linkedChildrenCount': _linkedChildren.length},
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'sessionId': 'debug-session',
          'runId': 'run1',
          'hypothesisId': 'A'
        });
        await logFile.writeAsString('$logData\n', mode: FileMode.append);
      } catch (_) {}
      // #endregion
    }
    
    _isInitialized = true;
    notifyListeners();
    
    // #region agent log
    try {
      final logFile = File('/Users/dsselmanovic/cursor project/kids-ai-all-in/.cursor/debug.log');
      final logData = jsonEncode({
        'location': 'parent_child_service.dart:62',
        'message': 'ParentChildService initialization completed',
        'data': {'isInitialized': _isInitialized, 'hasParentId': _parentId != null, 'hasChildId': _activeChildId != null},
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'sessionId': 'debug-session',
        'runId': 'run1',
        'hypothesisId': 'A'
      });
      await logFile.writeAsString('$logData\n', mode: FileMode.append);
    } catch (_) {}
    // #endregion
  }
  
  /// Generiert eine einzigartige Parent ID
  Future<String> createParentAccount({
    required String pin,
    String? email,
  }) async {
    final parentId = _generateId();
    
    await _firestore.collection('parents').doc(parentId).set({
      'pin': _hashPin(pin),
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parent_id', parentId);
    await prefs.setString('parent_pin', _hashPin(pin));
    
    _parentId = parentId;
    notifyListeners();
    
    return parentId;
  }
  
  /// Verifiziert Parent PIN
  Future<bool> verifyPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString('parent_pin');
    return storedHash == _hashPin(pin);
  }
  
  /// Aktualisiert Parent PIN
  Future<void> updatePin(String oldPin, String newPin) async {
    if (!await verifyPin(oldPin)) {
      throw Exception('Falscher PIN');
    }
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('parent_pin', _hashPin(newPin));
    
    if (_parentId != null) {
      await _firestore.collection('parents').doc(_parentId).update({
        'pin': _hashPin(newPin),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }
  }
  
  /// Erstellt ein neues Kinderprofil und verknüpft es
  Future<String> createChildProfile({
    required String name,
    required int age,
    required String language,
    String? avatarUrl,
  }) async {
    if (_parentId == null) {
      throw Exception('Kein Parent Account vorhanden');
    }
    
    final childId = _generateId();
    
    // Kind in verschachtelter Struktur erstellen (parents/{parentId}/children/{childId})
    await _firestore
        .collection('parents')
        .doc(_parentId)
        .collection('children')
        .doc(childId)
        .set({
      'name': name,
      'age': age,
      'preferredLanguage': language,
      'avatarUrl': avatarUrl,
      'parentId': _parentId,
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    await _loadLinkedChildren();
    await setActiveChild(childId);
    
    return childId;
  }
  
  /// Lädt verknüpfte Kinder
  Future<void> _loadLinkedChildren() async {
    if (_parentId == null) return;
    
    try {
      final snapshot = await _firestore
          .collection('parents')
          .doc(_parentId)
          .collection('children')
          .get();
      
      _linkedChildren = snapshot.docs
          .map((doc) => LinkedChild.fromMap(doc.id, doc.data()))
          .toList();
      
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading linked children: $e');
    }
  }
  
  /// Setzt das aktive Kind
  Future<void> setActiveChild(String childId) async {
    _activeChildId = childId;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('active_child_id', childId);
    
    notifyListeners();
  }
  
  /// Holt das aktive Kind-Profil
  Future<Map<String, dynamic>?> getActiveChildProfile() async {
    if (_activeChildId == null || _parentId == null) return null;
    
    try {
      final doc = await _firestore
          .collection('parents')
          .doc(_parentId)
          .collection('children')
          .doc(_activeChildId)
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }
  
  /// Aktualisiert Kinderprofil
  Future<void> updateChildProfile(String childId, Map<String, dynamic> data) async {
    if (_parentId == null) return;
    
    await _firestore
        .collection('parents')
        .doc(_parentId)
        .collection('children')
        .doc(childId)
        .update({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    });
    
    await _loadLinkedChildren();
  }
  
  /// Speichert YouTube Einstellungen für aktives Kind
  Future<void> saveYouTubeSettings(Map<String, dynamic> settings) async {
    if (_activeChildId == null || _parentId == null) return;
    
    await _firestore
        .collection('parents')
        .doc(_parentId)
        .collection('children')
        .doc(_activeChildId)
        .collection('settings')
        .doc('youtube')
        .set(settings, SetOptions(merge: true));
  }
  
  /// Lädt YouTube Einstellungen für aktives Kind
  Future<Map<String, dynamic>?> loadYouTubeSettings() async {
    if (_activeChildId == null || _parentId == null) return null;
    
    try {
      final doc = await _firestore
          .collection('parents')
          .doc(_parentId)
          .collection('children')
          .doc(_activeChildId)
          .collection('settings')
          .doc('youtube')
          .get();
      return doc.data();
    } catch (e) {
      return null;
    }
  }
  
  /// Löscht ein Kinderprofil (nur für Parents)
  Future<void> deleteChildProfile(String childId) async {
    if (_parentId == null) return;
    
    // Kind-Dokument löschen (verschachtelte Struktur)
    await _firestore
        .collection('parents')
        .doc(_parentId)
        .collection('children')
        .doc(childId)
        .delete();
    
    await _loadLinkedChildren();
    
    // Wenn aktives Kind gelöscht wurde, neues setzen
    if (_activeChildId == childId) {
      _activeChildId = _linkedChildren.isNotEmpty 
          ? _linkedChildren.first.childId 
          : null;
      
      final prefs = await SharedPreferences.getInstance();
      if (_activeChildId != null) {
        await prefs.setString('active_child_id', _activeChildId!);
      } else {
        await prefs.remove('active_child_id');
      }
    }
    
    notifyListeners();
  }
  
  String _generateId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(20, (index) => chars[random.nextInt(chars.length)]).join();
  }
  
  String _hashPin(String pin) {
    // Einfacher Hash für Demo - in Produktion bcrypt/argon2 verwenden!
    return pin.codeUnits.fold(0, (prev, elem) => prev + elem).toString();
  }
}

/// Verknüpftes Kind Model
class LinkedChild {
  final String childId;
  final String name;
  final DateTime? linkedAt;
  
  LinkedChild({
    required this.childId,
    required this.name,
    this.linkedAt,
  });
  
  factory LinkedChild.fromMap(String id, Map<String, dynamic> map) {
    return LinkedChild(
      childId: id,
      name: map['name'] ?? '',
      linkedAt: (map['linkedAt'] as Timestamp?)?.toDate(),
    );
  }
}

// Providers
final parentChildServiceProvider = ChangeNotifierProvider<ParentChildService>((ref) {
  return ParentChildService();
});

final activeChildIdProvider = Provider<String?>((ref) {
  return ref.watch(parentChildServiceProvider).activeChildId;
});

final linkedChildrenProvider = Provider<List<LinkedChild>>((ref) {
  return ref.watch(parentChildServiceProvider).linkedChildren;
});
