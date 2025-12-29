import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Avatar Service für Avatar-Generierung
class AvatarService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Generiert Avatar aus hochgeladenen Bildern
  Future<String> generateAvatar(List<File> images) async {
    try {
      // 1. Lade Bilder zu Firebase Storage hoch
      final imageUrls = await _uploadImages(images);

      // 2. Speichere Bild-URLs in Firestore
      final avatarId = await _saveAvatarData(imageUrls);

      // 3. Avatar-Generierungs-API wird implementiert (z.B. Ready Player Me)
      // Für jetzt: Speichere nur die Bild-URLs

      return avatarId;
    } catch (e) {
      debugPrint('Fehler bei Avatar-Generierung: $e');
      rethrow;
    }
  }

  /// Lädt Bilder zu Firebase Storage hoch
  Future<List<String>> _uploadImages(List<File> images) async {
    final List<String> urls = [];

    for (int i = 0; i < images.length; i++) {
      final file = images[i];
      final fileName = 'avatar_images/${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
      final ref = _storage.ref().child(fileName);

      await ref.putFile(file);
      final url = await ref.getDownloadURL();
      urls.add(url);
    }

    return urls;
  }

  /// Speichert Avatar-Daten in Firestore
  Future<String> _saveAvatarData(List<String> imageUrls) async {
    final avatarId = DateTime.now().millisecondsSinceEpoch.toString();

    await _firestore.collection('avatars').doc(avatarId).set({
      'imageUrls': imageUrls,
      'createdAt': DateTime.now().toIso8601String(),
      'status': 'pending', // pending, generating, completed, failed
    });

    return avatarId;
  }

  /// Holt Avatar-Daten
  Future<Map<String, dynamic>?> getAvatar(String avatarId) async {
    final doc = await _firestore.collection('avatars').doc(avatarId).get();
    return doc.data();
  }
}

