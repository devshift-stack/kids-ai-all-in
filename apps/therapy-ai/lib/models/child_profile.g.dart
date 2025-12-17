// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'child_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChildProfileImpl _$$ChildProfileImplFromJson(Map<String, dynamic> json) =>
    _$ChildProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      language: json['language'] as String? ?? 'bs',
      leftEarLossPercent: (json['leftEarLossPercent'] as num).toDouble(),
      rightEarLossPercent: (json['rightEarLossPercent'] as num).toDouble(),
      currentSkillLevel: (json['currentSkillLevel'] as num?)?.toInt() ?? 1,
      clonedVoiceId: json['clonedVoiceId'] as String?,
      preferredVolume: (json['preferredVolume'] as num?)?.toDouble() ?? 1.0,
      preferredSpeechRate:
          (json['preferredSpeechRate'] as num?)?.toDouble() ?? 0.5,
      therapyGoals:
          (json['therapyGoals'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChildProfileImplToJson(_$ChildProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'age': instance.age,
      'language': instance.language,
      'leftEarLossPercent': instance.leftEarLossPercent,
      'rightEarLossPercent': instance.rightEarLossPercent,
      'currentSkillLevel': instance.currentSkillLevel,
      'clonedVoiceId': instance.clonedVoiceId,
      'preferredVolume': instance.preferredVolume,
      'preferredSpeechRate': instance.preferredSpeechRate,
      'therapyGoals': instance.therapyGoals,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
