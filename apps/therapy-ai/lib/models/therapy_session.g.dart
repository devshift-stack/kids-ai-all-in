// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'therapy_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TherapySessionImpl _$$TherapySessionImplFromJson(Map<String, dynamic> json) =>
    _$TherapySessionImpl(
      id: json['id'] as String,
      childProfileId: json['childProfileId'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      status:
          $enumDecodeNullable(_$SessionStatusEnumMap, json['status']) ??
          SessionStatus.inProgress,
      exerciseAttempts:
          (json['exerciseAttempts'] as List<dynamic>?)
              ?.map((e) => ExerciseAttempt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalExercises: (json['totalExercises'] as num?)?.toInt() ?? 0,
      completedExercises: (json['completedExercises'] as num?)?.toInt() ?? 0,
      successfulExercises: (json['successfulExercises'] as num?)?.toInt() ?? 0,
      averagePronunciationScore:
          (json['averagePronunciationScore'] as num?)?.toDouble() ?? 0.0,
      averageVolumeLevel:
          (json['averageVolumeLevel'] as num?)?.toDouble() ?? 0.0,
      averageArticulationScore:
          (json['averageArticulationScore'] as num?)?.toDouble() ?? 0.0,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TherapySessionImplToJson(
  _$TherapySessionImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'childProfileId': instance.childProfileId,
  'startTime': instance.startTime.toIso8601String(),
  'endTime': instance.endTime?.toIso8601String(),
  'status': _$SessionStatusEnumMap[instance.status]!,
  'exerciseAttempts': instance.exerciseAttempts,
  'totalExercises': instance.totalExercises,
  'completedExercises': instance.completedExercises,
  'successfulExercises': instance.successfulExercises,
  'averagePronunciationScore': instance.averagePronunciationScore,
  'averageVolumeLevel': instance.averageVolumeLevel,
  'averageArticulationScore': instance.averageArticulationScore,
  'notes': instance.notes,
};

const _$SessionStatusEnumMap = {
  SessionStatus.inProgress: 'inProgress',
  SessionStatus.completed: 'completed',
  SessionStatus.paused: 'paused',
  SessionStatus.cancelled: 'cancelled',
};

_$ExerciseAttemptImpl _$$ExerciseAttemptImplFromJson(
  Map<String, dynamic> json,
) => _$ExerciseAttemptImpl(
  id: json['id'] as String,
  exercise: Exercise.fromJson(json['exercise'] as Map<String, dynamic>),
  attemptTime: DateTime.parse(json['attemptTime'] as String),
  result: json['result'] == null
      ? null
      : SpeechAnalysisResult.fromJson(json['result'] as Map<String, dynamic>),
  status:
      $enumDecodeNullable(_$AttemptStatusEnumMap, json['status']) ??
      AttemptStatus.pending,
  attemptNumber: (json['attemptNumber'] as num?)?.toInt() ?? 1,
  duration: json['duration'] == null
      ? null
      : Duration(microseconds: (json['duration'] as num).toInt()),
);

Map<String, dynamic> _$$ExerciseAttemptImplToJson(
  _$ExerciseAttemptImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'exercise': instance.exercise,
  'attemptTime': instance.attemptTime.toIso8601String(),
  'result': instance.result,
  'status': _$AttemptStatusEnumMap[instance.status]!,
  'attemptNumber': instance.attemptNumber,
  'duration': instance.duration?.inMicroseconds,
};

const _$AttemptStatusEnumMap = {
  AttemptStatus.pending: 'pending',
  AttemptStatus.inProgress: 'inProgress',
  AttemptStatus.completed: 'completed',
  AttemptStatus.failed: 'failed',
  AttemptStatus.skipped: 'skipped',
};
