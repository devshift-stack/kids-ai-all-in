// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'speech_analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpeechAnalysisResultImpl _$$SpeechAnalysisResultImplFromJson(
  Map<String, dynamic> json,
) => _$SpeechAnalysisResultImpl(
  transcription: json['transcription'] as String,
  targetWord: json['targetWord'] as String,
  pronunciationScore: (json['pronunciationScore'] as num).toDouble(),
  volumeLevel: (json['volumeLevel'] as num).toDouble(),
  articulationScore: (json['articulationScore'] as num).toDouble(),
  similarityScore: (json['similarityScore'] as num).toDouble(),
  phonemeBreakdown:
      (json['phonemeBreakdown'] as List<dynamic>?)
          ?.map((e) => PhonemeAccuracy.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  averageVolume: (json['averageVolume'] as num?)?.toDouble() ?? 0.0,
  peakVolume: (json['peakVolume'] as num?)?.toDouble() ?? 0.0,
  volumeConsistency: (json['volumeConsistency'] as num?)?.toDouble() ?? 0.0,
  speechDuration: json['speechDuration'] == null
      ? null
      : Duration(microseconds: (json['speechDuration'] as num).toInt()),
  pauseDuration: json['pauseDuration'] == null
      ? null
      : Duration(microseconds: (json['pauseDuration'] as num).toInt()),
  feedbackMessage: json['feedbackMessage'] as String,
  recommendations:
      (json['recommendations'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  isSuccessful: json['isSuccessful'] as bool,
  needsRepetition: json['needsRepetition'] as bool,
  analyzedAt: DateTime.parse(json['analyzedAt'] as String),
  audioFilePath: json['audioFilePath'] as String?,
);

Map<String, dynamic> _$$SpeechAnalysisResultImplToJson(
  _$SpeechAnalysisResultImpl instance,
) => <String, dynamic>{
  'transcription': instance.transcription,
  'targetWord': instance.targetWord,
  'pronunciationScore': instance.pronunciationScore,
  'volumeLevel': instance.volumeLevel,
  'articulationScore': instance.articulationScore,
  'similarityScore': instance.similarityScore,
  'phonemeBreakdown': instance.phonemeBreakdown,
  'averageVolume': instance.averageVolume,
  'peakVolume': instance.peakVolume,
  'volumeConsistency': instance.volumeConsistency,
  'speechDuration': instance.speechDuration?.inMicroseconds,
  'pauseDuration': instance.pauseDuration?.inMicroseconds,
  'feedbackMessage': instance.feedbackMessage,
  'recommendations': instance.recommendations,
  'isSuccessful': instance.isSuccessful,
  'needsRepetition': instance.needsRepetition,
  'analyzedAt': instance.analyzedAt.toIso8601String(),
  'audioFilePath': instance.audioFilePath,
};

_$PhonemeAccuracyImpl _$$PhonemeAccuracyImplFromJson(
  Map<String, dynamic> json,
) => _$PhonemeAccuracyImpl(
  phoneme: json['phoneme'] as String,
  accuracy: (json['accuracy'] as num).toDouble(),
  isCorrect: json['isCorrect'] as bool,
  errorType: json['errorType'] as String?,
);

Map<String, dynamic> _$$PhonemeAccuracyImplToJson(
  _$PhonemeAccuracyImpl instance,
) => <String, dynamic>{
  'phoneme': instance.phoneme,
  'accuracy': instance.accuracy,
  'isCorrect': instance.isCorrect,
  'errorType': instance.errorType,
};
