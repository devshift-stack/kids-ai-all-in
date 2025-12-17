// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'exercise.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Exercise _$ExerciseFromJson(Map<String, dynamic> json) {
  return _Exercise.fromJson(json);
}

/// @nodoc
mixin _$Exercise {
  String get id => throw _privateConstructorUsedError;
  ExerciseType get type => throw _privateConstructorUsedError;
  String get targetWord => throw _privateConstructorUsedError;
  String? get targetPhrase =>
      throw _privateConstructorUsedError; // For sentence exercises
  int get difficultyLevel => throw _privateConstructorUsedError; // 1-10
  Duration get expectedDuration =>
      throw _privateConstructorUsedError; // Success criteria
  double get minPronunciationScore =>
      throw _privateConstructorUsedError; // 0-100
  double get minVolumeLevel => throw _privateConstructorUsedError; // dB
  double get minSimilarityScore => throw _privateConstructorUsedError; // 0-1
  // Phoneme focus (optional)
  List<String> get focusPhonemes =>
      throw _privateConstructorUsedError; // Instructions
  String? get instructions => throw _privateConstructorUsedError; // Metadata
  List<String> get tags => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Exercise to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseCopyWith<Exercise> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseCopyWith<$Res> {
  factory $ExerciseCopyWith(Exercise value, $Res Function(Exercise) then) =
      _$ExerciseCopyWithImpl<$Res, Exercise>;
  @useResult
  $Res call({
    String id,
    ExerciseType type,
    String targetWord,
    String? targetPhrase,
    int difficultyLevel,
    Duration expectedDuration,
    double minPronunciationScore,
    double minVolumeLevel,
    double minSimilarityScore,
    List<String> focusPhonemes,
    String? instructions,
    List<String> tags,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ExerciseCopyWithImpl<$Res, $Val extends Exercise>
    implements $ExerciseCopyWith<$Res> {
  _$ExerciseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? targetWord = null,
    Object? targetPhrase = freezed,
    Object? difficultyLevel = null,
    Object? expectedDuration = null,
    Object? minPronunciationScore = null,
    Object? minVolumeLevel = null,
    Object? minSimilarityScore = null,
    Object? focusPhonemes = null,
    Object? instructions = freezed,
    Object? tags = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            type: null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                      as ExerciseType,
            targetWord: null == targetWord
                ? _value.targetWord
                : targetWord // ignore: cast_nullable_to_non_nullable
                      as String,
            targetPhrase: freezed == targetPhrase
                ? _value.targetPhrase
                : targetPhrase // ignore: cast_nullable_to_non_nullable
                      as String?,
            difficultyLevel: null == difficultyLevel
                ? _value.difficultyLevel
                : difficultyLevel // ignore: cast_nullable_to_non_nullable
                      as int,
            expectedDuration: null == expectedDuration
                ? _value.expectedDuration
                : expectedDuration // ignore: cast_nullable_to_non_nullable
                      as Duration,
            minPronunciationScore: null == minPronunciationScore
                ? _value.minPronunciationScore
                : minPronunciationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            minVolumeLevel: null == minVolumeLevel
                ? _value.minVolumeLevel
                : minVolumeLevel // ignore: cast_nullable_to_non_nullable
                      as double,
            minSimilarityScore: null == minSimilarityScore
                ? _value.minSimilarityScore
                : minSimilarityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            focusPhonemes: null == focusPhonemes
                ? _value.focusPhonemes
                : focusPhonemes // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            instructions: freezed == instructions
                ? _value.instructions
                : instructions // ignore: cast_nullable_to_non_nullable
                      as String?,
            tags: null == tags
                ? _value.tags
                : tags // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ExerciseImplCopyWith<$Res>
    implements $ExerciseCopyWith<$Res> {
  factory _$$ExerciseImplCopyWith(
    _$ExerciseImpl value,
    $Res Function(_$ExerciseImpl) then,
  ) = __$$ExerciseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    ExerciseType type,
    String targetWord,
    String? targetPhrase,
    int difficultyLevel,
    Duration expectedDuration,
    double minPronunciationScore,
    double minVolumeLevel,
    double minSimilarityScore,
    List<String> focusPhonemes,
    String? instructions,
    List<String> tags,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ExerciseImplCopyWithImpl<$Res>
    extends _$ExerciseCopyWithImpl<$Res, _$ExerciseImpl>
    implements _$$ExerciseImplCopyWith<$Res> {
  __$$ExerciseImplCopyWithImpl(
    _$ExerciseImpl _value,
    $Res Function(_$ExerciseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? targetWord = null,
    Object? targetPhrase = freezed,
    Object? difficultyLevel = null,
    Object? expectedDuration = null,
    Object? minPronunciationScore = null,
    Object? minVolumeLevel = null,
    Object? minSimilarityScore = null,
    Object? focusPhonemes = null,
    Object? instructions = freezed,
    Object? tags = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ExerciseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as ExerciseType,
        targetWord: null == targetWord
            ? _value.targetWord
            : targetWord // ignore: cast_nullable_to_non_nullable
                  as String,
        targetPhrase: freezed == targetPhrase
            ? _value.targetPhrase
            : targetPhrase // ignore: cast_nullable_to_non_nullable
                  as String?,
        difficultyLevel: null == difficultyLevel
            ? _value.difficultyLevel
            : difficultyLevel // ignore: cast_nullable_to_non_nullable
                  as int,
        expectedDuration: null == expectedDuration
            ? _value.expectedDuration
            : expectedDuration // ignore: cast_nullable_to_non_nullable
                  as Duration,
        minPronunciationScore: null == minPronunciationScore
            ? _value.minPronunciationScore
            : minPronunciationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        minVolumeLevel: null == minVolumeLevel
            ? _value.minVolumeLevel
            : minVolumeLevel // ignore: cast_nullable_to_non_nullable
                  as double,
        minSimilarityScore: null == minSimilarityScore
            ? _value.minSimilarityScore
            : minSimilarityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        focusPhonemes: null == focusPhonemes
            ? _value._focusPhonemes
            : focusPhonemes // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        instructions: freezed == instructions
            ? _value.instructions
            : instructions // ignore: cast_nullable_to_non_nullable
                  as String?,
        tags: null == tags
            ? _value._tags
            : tags // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseImpl implements _Exercise {
  const _$ExerciseImpl({
    required this.id,
    required this.type,
    required this.targetWord,
    this.targetPhrase,
    required this.difficultyLevel,
    required this.expectedDuration,
    this.minPronunciationScore = 70.0,
    this.minVolumeLevel = 60.0,
    this.minSimilarityScore = 0.8,
    final List<String> focusPhonemes = const [],
    this.instructions,
    final List<String> tags = const [],
    this.createdAt,
  }) : _focusPhonemes = focusPhonemes,
       _tags = tags;

  factory _$ExerciseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseImplFromJson(json);

  @override
  final String id;
  @override
  final ExerciseType type;
  @override
  final String targetWord;
  @override
  final String? targetPhrase;
  // For sentence exercises
  @override
  final int difficultyLevel;
  // 1-10
  @override
  final Duration expectedDuration;
  // Success criteria
  @override
  @JsonKey()
  final double minPronunciationScore;
  // 0-100
  @override
  @JsonKey()
  final double minVolumeLevel;
  // dB
  @override
  @JsonKey()
  final double minSimilarityScore;
  // 0-1
  // Phoneme focus (optional)
  final List<String> _focusPhonemes;
  // 0-1
  // Phoneme focus (optional)
  @override
  @JsonKey()
  List<String> get focusPhonemes {
    if (_focusPhonemes is EqualUnmodifiableListView) return _focusPhonemes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_focusPhonemes);
  }

  // Instructions
  @override
  final String? instructions;
  // Metadata
  final List<String> _tags;
  // Metadata
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Exercise(id: $id, type: $type, targetWord: $targetWord, targetPhrase: $targetPhrase, difficultyLevel: $difficultyLevel, expectedDuration: $expectedDuration, minPronunciationScore: $minPronunciationScore, minVolumeLevel: $minVolumeLevel, minSimilarityScore: $minSimilarityScore, focusPhonemes: $focusPhonemes, instructions: $instructions, tags: $tags, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.targetWord, targetWord) ||
                other.targetWord == targetWord) &&
            (identical(other.targetPhrase, targetPhrase) ||
                other.targetPhrase == targetPhrase) &&
            (identical(other.difficultyLevel, difficultyLevel) ||
                other.difficultyLevel == difficultyLevel) &&
            (identical(other.expectedDuration, expectedDuration) ||
                other.expectedDuration == expectedDuration) &&
            (identical(other.minPronunciationScore, minPronunciationScore) ||
                other.minPronunciationScore == minPronunciationScore) &&
            (identical(other.minVolumeLevel, minVolumeLevel) ||
                other.minVolumeLevel == minVolumeLevel) &&
            (identical(other.minSimilarityScore, minSimilarityScore) ||
                other.minSimilarityScore == minSimilarityScore) &&
            const DeepCollectionEquality().equals(
              other._focusPhonemes,
              _focusPhonemes,
            ) &&
            (identical(other.instructions, instructions) ||
                other.instructions == instructions) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    type,
    targetWord,
    targetPhrase,
    difficultyLevel,
    expectedDuration,
    minPronunciationScore,
    minVolumeLevel,
    minSimilarityScore,
    const DeepCollectionEquality().hash(_focusPhonemes),
    instructions,
    const DeepCollectionEquality().hash(_tags),
    createdAt,
  );

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      __$$ExerciseImplCopyWithImpl<_$ExerciseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseImplToJson(this);
  }
}

abstract class _Exercise implements Exercise {
  const factory _Exercise({
    required final String id,
    required final ExerciseType type,
    required final String targetWord,
    final String? targetPhrase,
    required final int difficultyLevel,
    required final Duration expectedDuration,
    final double minPronunciationScore,
    final double minVolumeLevel,
    final double minSimilarityScore,
    final List<String> focusPhonemes,
    final String? instructions,
    final List<String> tags,
    final DateTime? createdAt,
  }) = _$ExerciseImpl;

  factory _Exercise.fromJson(Map<String, dynamic> json) =
      _$ExerciseImpl.fromJson;

  @override
  String get id;
  @override
  ExerciseType get type;
  @override
  String get targetWord;
  @override
  String? get targetPhrase; // For sentence exercises
  @override
  int get difficultyLevel; // 1-10
  @override
  Duration get expectedDuration; // Success criteria
  @override
  double get minPronunciationScore; // 0-100
  @override
  double get minVolumeLevel; // dB
  @override
  double get minSimilarityScore; // 0-1
  // Phoneme focus (optional)
  @override
  List<String> get focusPhonemes; // Instructions
  @override
  String? get instructions; // Metadata
  @override
  List<String> get tags;
  @override
  DateTime? get createdAt;

  /// Create a copy of Exercise
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseImplCopyWith<_$ExerciseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
