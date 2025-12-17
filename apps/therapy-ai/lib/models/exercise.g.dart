// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exercise.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExerciseImpl _$$ExerciseImplFromJson(Map<String, dynamic> json) =>
    _$ExerciseImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ExerciseTypeEnumMap, json['type']),
      targetWord: json['targetWord'] as String,
      targetPhrase: json['targetPhrase'] as String?,
      difficultyLevel: (json['difficultyLevel'] as num).toInt(),
      expectedDuration: Duration(
        microseconds: (json['expectedDuration'] as num).toInt(),
      ),
      minPronunciationScore:
          (json['minPronunciationScore'] as num?)?.toDouble() ?? 70.0,
      minVolumeLevel: (json['minVolumeLevel'] as num?)?.toDouble() ?? 60.0,
      minSimilarityScore:
          (json['minSimilarityScore'] as num?)?.toDouble() ?? 0.8,
      focusPhonemes:
          (json['focusPhonemes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      instructions: json['instructions'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ExerciseImplToJson(_$ExerciseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ExerciseTypeEnumMap[instance.type]!,
      'targetWord': instance.targetWord,
      'targetPhrase': instance.targetPhrase,
      'difficultyLevel': instance.difficultyLevel,
      'expectedDuration': instance.expectedDuration.inMicroseconds,
      'minPronunciationScore': instance.minPronunciationScore,
      'minVolumeLevel': instance.minVolumeLevel,
      'minSimilarityScore': instance.minSimilarityScore,
      'focusPhonemes': instance.focusPhonemes,
      'instructions': instance.instructions,
      'tags': instance.tags,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

const _$ExerciseTypeEnumMap = {
  ExerciseType.wordRepetition: 'wordRepetition',
  ExerciseType.sentencePractice: 'sentencePractice',
  ExerciseType.phonemeFocus: 'phonemeFocus',
  ExerciseType.volumeControl: 'volumeControl',
  ExerciseType.articulation: 'articulation',
  ExerciseType.conversation: 'conversation',
};
