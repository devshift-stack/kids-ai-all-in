// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'child_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ChildProfile _$ChildProfileFromJson(Map<String, dynamic> json) {
  return _ChildProfile.fromJson(json);
}

/// @nodoc
mixin _$ChildProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get age => throw _privateConstructorUsedError;
  String get language =>
      throw _privateConstructorUsedError; // Hearing loss profile
  double get leftEarLossPercent => throw _privateConstructorUsedError; // 0-100
  double get rightEarLossPercent => throw _privateConstructorUsedError; // 0-100
  // Skill level
  int get currentSkillLevel => throw _privateConstructorUsedError; // 1-10
  // Voice settings
  String? get clonedVoiceId =>
      throw _privateConstructorUsedError; // ElevenLabs voice ID
  double get preferredVolume => throw _privateConstructorUsedError;
  double get preferredSpeechRate =>
      throw _privateConstructorUsedError; // Therapy goals
  List<String> get therapyGoals =>
      throw _privateConstructorUsedError; // Timestamps
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this ChildProfile to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChildProfileCopyWith<ChildProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChildProfileCopyWith<$Res> {
  factory $ChildProfileCopyWith(
    ChildProfile value,
    $Res Function(ChildProfile) then,
  ) = _$ChildProfileCopyWithImpl<$Res, ChildProfile>;
  @useResult
  $Res call({
    String id,
    String name,
    int age,
    String language,
    double leftEarLossPercent,
    double rightEarLossPercent,
    int currentSkillLevel,
    String? clonedVoiceId,
    double preferredVolume,
    double preferredSpeechRate,
    List<String> therapyGoals,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class _$ChildProfileCopyWithImpl<$Res, $Val extends ChildProfile>
    implements $ChildProfileCopyWith<$Res> {
  _$ChildProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? language = null,
    Object? leftEarLossPercent = null,
    Object? rightEarLossPercent = null,
    Object? currentSkillLevel = null,
    Object? clonedVoiceId = freezed,
    Object? preferredVolume = null,
    Object? preferredSpeechRate = null,
    Object? therapyGoals = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            age: null == age
                ? _value.age
                : age // ignore: cast_nullable_to_non_nullable
                      as int,
            language: null == language
                ? _value.language
                : language // ignore: cast_nullable_to_non_nullable
                      as String,
            leftEarLossPercent: null == leftEarLossPercent
                ? _value.leftEarLossPercent
                : leftEarLossPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            rightEarLossPercent: null == rightEarLossPercent
                ? _value.rightEarLossPercent
                : rightEarLossPercent // ignore: cast_nullable_to_non_nullable
                      as double,
            currentSkillLevel: null == currentSkillLevel
                ? _value.currentSkillLevel
                : currentSkillLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            clonedVoiceId: freezed == clonedVoiceId
                ? _value.clonedVoiceId
                : clonedVoiceId // ignore: cast_nullable_to_non_nullable
                      as String?,
            preferredVolume: null == preferredVolume
                ? _value.preferredVolume
                : preferredVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            preferredSpeechRate: null == preferredSpeechRate
                ? _value.preferredSpeechRate
                : preferredSpeechRate // ignore: cast_nullable_to_non_nullable
                      as double,
            therapyGoals: null == therapyGoals
                ? _value.therapyGoals
                : therapyGoals // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ChildProfileImplCopyWith<$Res>
    implements $ChildProfileCopyWith<$Res> {
  factory _$$ChildProfileImplCopyWith(
    _$ChildProfileImpl value,
    $Res Function(_$ChildProfileImpl) then,
  ) = __$$ChildProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    int age,
    String language,
    double leftEarLossPercent,
    double rightEarLossPercent,
    int currentSkillLevel,
    String? clonedVoiceId,
    double preferredVolume,
    double preferredSpeechRate,
    List<String> therapyGoals,
    DateTime createdAt,
    DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ChildProfileImplCopyWithImpl<$Res>
    extends _$ChildProfileCopyWithImpl<$Res, _$ChildProfileImpl>
    implements _$$ChildProfileImplCopyWith<$Res> {
  __$$ChildProfileImplCopyWithImpl(
    _$ChildProfileImpl _value,
    $Res Function(_$ChildProfileImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? age = null,
    Object? language = null,
    Object? leftEarLossPercent = null,
    Object? rightEarLossPercent = null,
    Object? currentSkillLevel = null,
    Object? clonedVoiceId = freezed,
    Object? preferredVolume = null,
    Object? preferredSpeechRate = null,
    Object? therapyGoals = null,
    Object? createdAt = null,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ChildProfileImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        age: null == age
            ? _value.age
            : age // ignore: cast_nullable_to_non_nullable
                  as int,
        language: null == language
            ? _value.language
            : language // ignore: cast_nullable_to_non_nullable
                  as String,
        leftEarLossPercent: null == leftEarLossPercent
            ? _value.leftEarLossPercent
            : leftEarLossPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        rightEarLossPercent: null == rightEarLossPercent
            ? _value.rightEarLossPercent
            : rightEarLossPercent // ignore: cast_nullable_to_non_nullable
                  as double,
        currentSkillLevel: null == currentSkillLevel
            ? _value.currentSkillLevel
            : currentSkillLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        clonedVoiceId: freezed == clonedVoiceId
            ? _value.clonedVoiceId
            : clonedVoiceId // ignore: cast_nullable_to_non_nullable
                  as String?,
        preferredVolume: null == preferredVolume
            ? _value.preferredVolume
            : preferredVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        preferredSpeechRate: null == preferredSpeechRate
            ? _value.preferredSpeechRate
            : preferredSpeechRate // ignore: cast_nullable_to_non_nullable
                  as double,
        therapyGoals: null == therapyGoals
            ? _value._therapyGoals
            : therapyGoals // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ChildProfileImpl implements _ChildProfile {
  const _$ChildProfileImpl({
    required this.id,
    required this.name,
    required this.age,
    this.language = 'bs',
    required this.leftEarLossPercent,
    required this.rightEarLossPercent,
    this.currentSkillLevel = 1,
    this.clonedVoiceId,
    this.preferredVolume = 1.0,
    this.preferredSpeechRate = 0.5,
    final List<String> therapyGoals = const [],
    required this.createdAt,
    this.updatedAt,
  }) : _therapyGoals = therapyGoals;

  factory _$ChildProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChildProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final int age;
  @override
  @JsonKey()
  final String language;
  // Hearing loss profile
  @override
  final double leftEarLossPercent;
  // 0-100
  @override
  final double rightEarLossPercent;
  // 0-100
  // Skill level
  @override
  @JsonKey()
  final int currentSkillLevel;
  // 1-10
  // Voice settings
  @override
  final String? clonedVoiceId;
  // ElevenLabs voice ID
  @override
  @JsonKey()
  final double preferredVolume;
  @override
  @JsonKey()
  final double preferredSpeechRate;
  // Therapy goals
  final List<String> _therapyGoals;
  // Therapy goals
  @override
  @JsonKey()
  List<String> get therapyGoals {
    if (_therapyGoals is EqualUnmodifiableListView) return _therapyGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_therapyGoals);
  }

  // Timestamps
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'ChildProfile(id: $id, name: $name, age: $age, language: $language, leftEarLossPercent: $leftEarLossPercent, rightEarLossPercent: $rightEarLossPercent, currentSkillLevel: $currentSkillLevel, clonedVoiceId: $clonedVoiceId, preferredVolume: $preferredVolume, preferredSpeechRate: $preferredSpeechRate, therapyGoals: $therapyGoals, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChildProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.age, age) || other.age == age) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.leftEarLossPercent, leftEarLossPercent) ||
                other.leftEarLossPercent == leftEarLossPercent) &&
            (identical(other.rightEarLossPercent, rightEarLossPercent) ||
                other.rightEarLossPercent == rightEarLossPercent) &&
            (identical(other.currentSkillLevel, currentSkillLevel) ||
                other.currentSkillLevel == currentSkillLevel) &&
            (identical(other.clonedVoiceId, clonedVoiceId) ||
                other.clonedVoiceId == clonedVoiceId) &&
            (identical(other.preferredVolume, preferredVolume) ||
                other.preferredVolume == preferredVolume) &&
            (identical(other.preferredSpeechRate, preferredSpeechRate) ||
                other.preferredSpeechRate == preferredSpeechRate) &&
            const DeepCollectionEquality().equals(
              other._therapyGoals,
              _therapyGoals,
            ) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    age,
    language,
    leftEarLossPercent,
    rightEarLossPercent,
    currentSkillLevel,
    clonedVoiceId,
    preferredVolume,
    preferredSpeechRate,
    const DeepCollectionEquality().hash(_therapyGoals),
    createdAt,
    updatedAt,
  );

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      __$$ChildProfileImplCopyWithImpl<_$ChildProfileImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChildProfileImplToJson(this);
  }
}

abstract class _ChildProfile implements ChildProfile {
  const factory _ChildProfile({
    required final String id,
    required final String name,
    required final int age,
    final String language,
    required final double leftEarLossPercent,
    required final double rightEarLossPercent,
    final int currentSkillLevel,
    final String? clonedVoiceId,
    final double preferredVolume,
    final double preferredSpeechRate,
    final List<String> therapyGoals,
    required final DateTime createdAt,
    final DateTime? updatedAt,
  }) = _$ChildProfileImpl;

  factory _ChildProfile.fromJson(Map<String, dynamic> json) =
      _$ChildProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  int get age;
  @override
  String get language; // Hearing loss profile
  @override
  double get leftEarLossPercent; // 0-100
  @override
  double get rightEarLossPercent; // 0-100
  // Skill level
  @override
  int get currentSkillLevel; // 1-10
  // Voice settings
  @override
  String? get clonedVoiceId; // ElevenLabs voice ID
  @override
  double get preferredVolume;
  @override
  double get preferredSpeechRate; // Therapy goals
  @override
  List<String> get therapyGoals; // Timestamps
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;

  /// Create a copy of ChildProfile
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChildProfileImplCopyWith<_$ChildProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
