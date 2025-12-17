import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show DateTimeRange;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';

import 'audiogram_service.dart';
import 'speech_therapy_service.dart';

/// Fortschritts-Export Service
///
/// Erstellt PDF-Reports für:
/// - HNO-Ärzte / Audiologen
/// - Logopäden
/// - Eltern
///
/// Enthält:
/// - Hörtraining-Fortschritt
/// - Audiogramm-Daten
/// - Sprach-Entwicklung
/// - Empfehlungen
class ProgressExportService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Ref _ref;

  ProgressExportService(this._ref);

  // ============================================================
  // PDF GENERIEREN
  // ============================================================

  /// Erstellt vollständigen Fortschritts-Report als PDF
  Future<File?> generateProgressReport({
    required ReportType type,
    required DateTimeRange dateRange,
    bool includeAudiogram = true,
    bool includeTherapyProgress = true,
    bool includeRecommendations = true,
  }) async {
    try {
      final childId = _ref.read(currentChildIdProvider);
      if (childId == null) return null;

      // Daten sammeln
      final childData = await _getChildData(childId);
      final progressData = await _getProgressData(childId, dateRange);
      final audiogramData = includeAudiogram
          ? await _ref.read(audiogramServiceProvider).loadCurrentAudiogram()
          : null;
      final therapyData = includeTherapyProgress
          ? await _getTherapyData(childId, dateRange)
          : null;

      // PDF erstellen
      final pdf = pw.Document();

      // Standard-PDF-Schriftarten verwenden (keine externen Fonts nötig)
      final ttfRegular = pw.Font.helvetica();
      final ttfBold = pw.Font.helveticaBold();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            _buildHeader(childData, type, dateRange, ttfBold),
            pw.SizedBox(height: 20),
            _buildChildInfo(childData, ttfRegular, ttfBold),
            pw.SizedBox(height: 20),
            _buildProgressSummary(progressData, ttfRegular, ttfBold),
            if (audiogramData != null) ...[
              pw.SizedBox(height: 20),
              _buildAudiogramSection(audiogramData, ttfRegular, ttfBold),
            ],
            if (therapyData != null) ...[
              pw.SizedBox(height: 20),
              _buildTherapySection(therapyData, ttfRegular, ttfBold),
            ],
            if (includeRecommendations) ...[
              pw.SizedBox(height: 20),
              _buildRecommendations(progressData, audiogramData, ttfRegular, ttfBold),
            ],
            pw.SizedBox(height: 30),
            _buildFooter(ttfRegular),
          ],
        ),
      );

      // PDF speichern
      final outputDir = await getApplicationDocumentsDirectory();
      final dateStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final fileName = 'Lianko_Report_${childData['name']}_$dateStr.pdf';
      final file = File('${outputDir.path}/$fileName');

      await file.writeAsBytes(await pdf.save());

      if (kDebugMode) print('PDF erstellt: ${file.path}');

      return file;
    } catch (e) {
      if (kDebugMode) print('PDF Fehler: $e');
      return null;
    }
  }

  /// Teilt den Report
  Future<void> shareReport(File reportFile) async {
    await Share.shareXFiles(
      [XFile(reportFile.path)],
      subject: 'Lianko Fortschritts-Report',
    );
  }

  // ============================================================
  // DATEN SAMMELN
  // ============================================================

  Future<Map<String, dynamic>> _getChildData(String childId) async {
    final doc = await _firestore.collection('children').doc(childId).get();
    return doc.data() ?? {};
  }

  Future<ProgressData> _getProgressData(
    String childId,
    DateTimeRange dateRange,
  ) async {
    // Lern-Sessions abrufen
    final sessionsSnapshot = await _firestore
        .collection('children')
        .doc(childId)
        .collection('learningSessions')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end))
        .get();

    int totalSessions = sessionsSnapshot.docs.length;
    int totalMinutes = 0;
    int wordsLearned = 0;
    int correctAnswers = 0;
    int totalAnswers = 0;
    Map<String, int> categoryProgress = {};

    for (final doc in sessionsSnapshot.docs) {
      final data = doc.data();
      totalMinutes += (data['durationMinutes'] ?? 0) as int;
      wordsLearned += (data['wordsCompleted'] ?? 0) as int;
      correctAnswers += (data['correctAnswers'] ?? 0) as int;
      totalAnswers += (data['totalAnswers'] ?? 0) as int;

      final category = data['category'] as String?;
      if (category != null) {
        categoryProgress[category] = (categoryProgress[category] ?? 0) + 1;
      }
    }

    // Hörgeräte-Statistik
    final hearingAidSnapshot = await _firestore
        .collection('children')
        .doc(childId)
        .collection('hearingAidLogs')
        .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
        .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end))
        .get();

    int hearingAidChecks = hearingAidSnapshot.docs.length;
    int hearingAidWorn = hearingAidSnapshot.docs
        .where((doc) => doc.data()['wasWearing'] == true)
        .length;

    return ProgressData(
      totalSessions: totalSessions,
      totalMinutes: totalMinutes,
      wordsLearned: wordsLearned,
      correctAnswers: correctAnswers,
      totalAnswers: totalAnswers,
      categoryProgress: categoryProgress,
      hearingAidChecks: hearingAidChecks,
      hearingAidWornCount: hearingAidWorn,
    );
  }

  Future<TherapyProgressData?> _getTherapyData(
    String childId,
    DateTimeRange dateRange,
  ) async {
    try {
      final resultsSnapshot = await _firestore
          .collection('children')
          .doc(childId)
          .collection('exerciseResults')
          .where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(dateRange.start))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(dateRange.end))
          .get();

      if (resultsSnapshot.docs.isEmpty) return null;

      Map<String, PhonemeStats> phonemeStats = {};

      for (final doc in resultsSnapshot.docs) {
        final data = doc.data();
        final phonemes = List<String>.from(data['targetPhonemes'] ?? []);
        final wasSuccessful = data['wasSuccessful'] == true;

        for (final phoneme in phonemes) {
          phonemeStats.putIfAbsent(
            phoneme,
            () => PhonemeStats(phoneme: phoneme),
          );
          phonemeStats[phoneme]!.totalAttempts++;
          if (wasSuccessful) phonemeStats[phoneme]!.successfulAttempts++;
        }
      }

      return TherapyProgressData(
        totalExercises: resultsSnapshot.docs.length,
        phonemeStats: phonemeStats,
      );
    } catch (e) {
      return null;
    }
  }

  // ============================================================
  // PDF SECTIONS
  // ============================================================

  pw.Widget _buildHeader(
    Map<String, dynamic> childData,
    ReportType type,
    DateTimeRange dateRange,
    pw.Font fontBold,
  ) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final reportTitle = switch (type) {
      ReportType.audiologist => 'Audiologischer Fortschritts-Report',
      ReportType.speechTherapist => 'Logopädischer Fortschritts-Report',
      ReportType.parent => 'Eltern-Fortschritts-Report',
    };

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'LIANKO',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 24,
                color: PdfColors.blue800,
              ),
            ),
            pw.Text(
              'Hörtraining für Kinder',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
              ),
            ),
          ],
        ),
        pw.Divider(color: PdfColors.blue800, thickness: 2),
        pw.SizedBox(height: 10),
        pw.Text(
          reportTitle,
          style: pw.TextStyle(
            font: fontBold,
            fontSize: 18,
          ),
        ),
        pw.Text(
          'Zeitraum: ${dateFormat.format(dateRange.start)} - ${dateFormat.format(dateRange.end)}',
          style: const pw.TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  pw.Widget _buildChildInfo(
    Map<String, dynamic> childData,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Kind-Informationen',
            style: pw.TextStyle(font: fontBold, fontSize: 14),
          ),
          pw.SizedBox(height: 10),
          pw.Row(
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Name', childData['name'] ?? 'Unbekannt', fontRegular),
                    _buildInfoRow('Alter', '${childData['age'] ?? '?'} Jahre', fontRegular),
                  ],
                ),
              ),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Hörgeräte-Typ', childData['hearingAidType'] ?? 'Nicht angegeben', fontRegular),
                    _buildInfoRow('Seit', childData['createdAt'] != null
                        ? DateFormat('MM/yyyy').format((childData['createdAt'] as Timestamp).toDate())
                        : 'Unbekannt', fontRegular),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildInfoRow(String label, String value, pw.Font font) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        children: [
          pw.Text('$label: ', style: pw.TextStyle(color: PdfColors.grey700, fontSize: 10)),
          pw.Text(value, style: pw.TextStyle(font: font, fontSize: 10)),
        ],
      ),
    );
  }

  pw.Widget _buildProgressSummary(
    ProgressData data,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Lern-Fortschritt',
          style: pw.TextStyle(font: fontBold, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        pw.Row(
          children: [
            _buildStatBox('Sessions', '${data.totalSessions}', PdfColors.blue100, fontBold),
            pw.SizedBox(width: 10),
            _buildStatBox('Minuten', '${data.totalMinutes}', PdfColors.green100, fontBold),
            pw.SizedBox(width: 10),
            _buildStatBox('Wörter', '${data.wordsLearned}', PdfColors.orange100, fontBold),
            pw.SizedBox(width: 10),
            _buildStatBox(
              'Erfolgsrate',
              data.totalAnswers > 0
                  ? '${(data.correctAnswers / data.totalAnswers * 100).round()}%'
                  : '-',
              PdfColors.purple100,
              fontBold,
            ),
          ],
        ),
        pw.SizedBox(height: 15),
        // Hörgeräte-Nutzung
        pw.Text(
          'Hörgeräte-Nutzung',
          style: pw.TextStyle(font: fontBold, fontSize: 12),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          data.hearingAidChecks > 0
              ? '${data.hearingAidWornCount} von ${data.hearingAidChecks} Checks positiv (${(data.hearingAidWornCount / data.hearingAidChecks * 100).round()}%)'
              : 'Keine Daten verfügbar',
          style: const pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildStatBox(String label, String value, PdfColor color, pw.Font fontBold) {
    return pw.Expanded(
      child: pw.Container(
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: color,
          borderRadius: pw.BorderRadius.circular(8),
        ),
        child: pw.Column(
          children: [
            pw.Text(value, style: pw.TextStyle(font: fontBold, fontSize: 20)),
            pw.Text(label, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ),
    );
  }

  pw.Widget _buildAudiogramSection(
    AudiogramData audiogram,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Audiogramm-Daten',
          style: pw.TextStyle(font: fontBold, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400),
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _buildTableCell('Frequenz (Hz)', fontBold, isHeader: true),
                ...AudiogramData.standardFrequencies.map(
                  (f) => _buildTableCell('$f', fontBold, isHeader: true),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell('Links (dB)', fontRegular),
                ...AudiogramData.standardFrequencies.map(
                  (f) => _buildTableCell('${audiogram.leftEar[f] ?? '-'}', fontRegular),
                ),
              ],
            ),
            pw.TableRow(
              children: [
                _buildTableCell('Rechts (dB)', fontRegular),
                ...AudiogramData.standardFrequencies.map(
                  (f) => _buildTableCell('${audiogram.rightEar[f] ?? '-'}', fontRegular),
                ),
              ],
            ),
          ],
        ),
        if (audiogram.notes != null && audiogram.notes!.isNotEmpty) ...[
          pw.SizedBox(height: 5),
          pw.Text('Notizen: ${audiogram.notes}', style: const pw.TextStyle(fontSize: 9)),
        ],
      ],
    );
  }

  pw.Widget _buildTableCell(String text, pw.Font font, {bool isHeader = false}) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: isHeader ? font : null,
          fontSize: 9,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _buildTherapySection(
    TherapyProgressData data,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final sortedPhonemes = data.phonemeStats.entries.toList()
      ..sort((a, b) => a.value.successRate.compareTo(b.value.successRate));

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Logopädischer Fortschritt',
          style: pw.TextStyle(font: fontBold, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        pw.Text('Gesamt-Übungen: ${data.totalExercises}', style: const pw.TextStyle(fontSize: 10)),
        pw.SizedBox(height: 10),
        pw.Text('Phonem-Fortschritt:', style: pw.TextStyle(font: fontBold, fontSize: 11)),
        pw.SizedBox(height: 5),
        pw.Wrap(
          spacing: 5,
          runSpacing: 5,
          children: sortedPhonemes.take(15).map((entry) {
            final color = entry.value.successRate >= 0.8
                ? PdfColors.green100
                : entry.value.successRate >= 0.5
                    ? PdfColors.yellow100
                    : PdfColors.red100;
            return pw.Container(
              padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: pw.BoxDecoration(
                color: color,
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Text(
                '${entry.key}: ${(entry.value.successRate * 100).round()}%',
                style: const pw.TextStyle(fontSize: 9),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  pw.Widget _buildRecommendations(
    ProgressData progress,
    AudiogramData? audiogram,
    pw.Font fontRegular,
    pw.Font fontBold,
  ) {
    final recommendations = <String>[];

    // Basierend auf Nutzung
    if (progress.totalSessions < 10) {
      recommendations.add('• Regelmäßigere Nutzung empfohlen (aktuell: ${progress.totalSessions} Sessions)');
    }

    // Basierend auf Hörgeräte-Nutzung
    if (progress.hearingAidChecks > 0) {
      final wearingRate = progress.hearingAidWornCount / progress.hearingAidChecks;
      if (wearingRate < 0.8) {
        recommendations.add('• Hörgeräte-Trageverhalten verbessern (${(wearingRate * 100).round()}% Tragezeit)');
      }
    }

    // Basierend auf Erfolgsrate
    if (progress.totalAnswers > 0) {
      final successRate = progress.correctAnswers / progress.totalAnswers;
      if (successRate < 0.6) {
        recommendations.add('• Schwierigkeitsgrad der Übungen anpassen');
      }
    }

    if (recommendations.isEmpty) {
      recommendations.add('• Weiter so! Das Kind macht gute Fortschritte.');
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Empfehlungen',
          style: pw.TextStyle(font: fontBold, fontSize: 14),
        ),
        pw.SizedBox(height: 10),
        ...recommendations.map(
          (r) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 5),
            child: pw.Text(r, style: const pw.TextStyle(fontSize: 10)),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Font font) {
    return pw.Column(
      children: [
        pw.Divider(color: PdfColors.grey400),
        pw.SizedBox(height: 5),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'Erstellt mit Lianko - Hörtraining für Kinder',
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
            pw.Text(
              DateFormat('dd.MM.yyyy HH:mm').format(DateTime.now()),
              style: pw.TextStyle(fontSize: 8, color: PdfColors.grey600),
            ),
          ],
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Dieser Report ersetzt keine ärztliche Diagnose.',
          style: pw.TextStyle(fontSize: 7, color: PdfColors.grey500, fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }
}

// ============================================================
// MODELS
// ============================================================

/// Report-Typ
enum ReportType {
  audiologist,      // Für HNO/Audiologen
  speechTherapist,  // Für Logopäden
  parent,           // Für Eltern
}

/// Fortschritts-Daten
class ProgressData {
  final int totalSessions;
  final int totalMinutes;
  final int wordsLearned;
  final int correctAnswers;
  final int totalAnswers;
  final Map<String, int> categoryProgress;
  final int hearingAidChecks;
  final int hearingAidWornCount;

  ProgressData({
    required this.totalSessions,
    required this.totalMinutes,
    required this.wordsLearned,
    required this.correctAnswers,
    required this.totalAnswers,
    required this.categoryProgress,
    required this.hearingAidChecks,
    required this.hearingAidWornCount,
  });
}

/// Therapie-Fortschritts-Daten
class TherapyProgressData {
  final int totalExercises;
  final Map<String, PhonemeStats> phonemeStats;

  TherapyProgressData({
    required this.totalExercises,
    required this.phonemeStats,
  });
}

/// Phonem-Statistik
class PhonemeStats {
  final String phoneme;
  int totalAttempts = 0;
  int successfulAttempts = 0;

  PhonemeStats({required this.phoneme});

  double get successRate =>
      totalAttempts > 0 ? successfulAttempts / totalAttempts : 0;
}

// ============================================================
// PROVIDERS
// ============================================================

final currentChildIdProvider = Provider<String?>((ref) => null);

final progressExportServiceProvider = Provider<ProgressExportService>((ref) {
  return ProgressExportService(ref);
});
