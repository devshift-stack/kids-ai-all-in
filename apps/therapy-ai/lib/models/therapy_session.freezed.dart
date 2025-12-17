// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'therapy_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TherapySession _$TherapySessionFromJson(Map<String, dynamic> json) {
  return _TherapySession.fromJson(json);
}

/// @nodoc
mixin _$TherapySession {
  String get id => throw _privateConstructorUsedError;
  String get childProfileId =>
      throw _privateConstructorUsedError; // Session info
  DateTime get startTime => throw _privateConstructorUsedError;
  DateTime? get endTime => throw _privateConstructorUsedError;
  SessionStatus get status =>
      throw _privateConstructorUsedError; // Exercises in this session
  List<ExerciseAttempt> get exerciseAttempts =>
      throw _privateConstructorUsedError; // Session statistics
  int get totalExercises => throw _privateConstructorUsedError;
  int get completedExercises => throw _privateConstructorUsedError;
  int get successfulExercises =>
      throw _privateConstructorUsedError; // Performance metrics
  double get averagePronunciationScore => throw _privateConstructorUsedError;
  double get averageVolumeLevel => throw _privateConstructorUsedError;
  double get averageArticulationScore =>
      throw _privateConstructorUsedError; // Notes
  String? get notes => throw _privateConstructorUsedError;

  /// Serializes this TherapySession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TherapySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TherapySessionCopyWith<TherapySession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TherapySessionCopyWith<$Res> {
  factory $TherapySessionCopyWith(
    TherapySession value,
    $Res Function(TherapySession) then,
  ) = _$TherapySessionCopyWithImpl<$Res, TherapySession>;
  @useResult
  $Res call({
    String id,
    String childProfileId,
    DateTime startTime,
    DateTime? endTime,
    SessionStatus status,
    List<ExerciseAttempt> exerciseAttempts,
    int totalExercises,
    int completedExercises,
    int successfulExercises,
    double averagePronunciationScore,
    double averageVolumeLevel,
    double averageArticulationScore,
    String? notes,
  });
}

/// @nodoc
class _$TherapySessionCopyWithImpl<$Res, $Val extends TherapySession>
    implements $TherapySessionCopyWith<$Res> {
  _$TherapySessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TherapySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childProfileId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? status = null,
    Object? exerciseAttempts = null,
    Object? totalExercises = null,
    Object? completedExercises = null,
    Object? successfulExercises = null,
    Object? averagePronunciationScore = null,
    Object? averageVolumeLevel = null,
    Object? averageArticulationScore = null,
    Object? notes = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            childProfileId: null == childProfileId
                ? _value.childProfileId
                : childProfileId // ignore: cast_nullable_to_non_nullable
                      as String,
            startTime: null == startTime
                ? _value.startTime
                : startTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            endTime: freezed == endTime
                ? _value.endTime
                : endTime // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as SessionStatus,
            exerciseAttempts: null == exerciseAttempts
                ? _value.exerciseAttempts
                : exerciseAttempts // ignore: cast_nullable_to_non_nullable
                      as List<ExerciseAttempt>,
            totalExercises: null == totalExercises
                ? _value.totalExercises
                : totalExercises // ignore: cast_nullable_to_non_nullable
                      as int,
            completedExercises: null == completedExercises
                ? _value.completedExercises
                : completedExercises // ignore: cast_nullable_to_non_nullable
                      as int,
            successfulExercises: null == successfulExercises
                ? _value.successfulExercises
                : successfulExercises // ignore: cast_nullable_to_non_nullable
                      as int,
            averagePronunciationScore: null == averagePronunciationScore
                ? _value.averagePronunciationScore
                : averagePronunciationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            averageVolumeLevel: null == averageVolumeLevel
                ? _value.averageVolumeLevel
                : averageVolumeLevel // ignore: cast_nullable_to_non_nullable
                      as double,
            averageArticulationScore: null == averageArticulationScore
                ? _value.averageArticulationScore
                : averageArticulationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            notes: freezed == notes
                ? _value.notes
                : notes // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TherapySessionImplCopyWith<$Res>
    implements $TherapySessionCopyWith<$Res> {
  factory _$$TherapySessionImplCopyWith(
    _$TherapySessionImpl value,
    $Res Function(_$TherapySessionImpl) then,
  ) = __$$TherapySessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String childProfileId,
    DateTime startTime,
    DateTime? endTime,
    SessionStatus status,
    List<ExerciseAttempt> exerciseAttempts,
    int totalExercises,
    int completedExercises,
    int successfulExercises,
    double averagePronunciationScore,
    double averageVolumeLevel,
    double averageArticulationScore,
    String? notes,
  });
}

/// @nodoc
class __$$TherapySessionImplCopyWithImpl<$Res>
    extends _$TherapySessionCopyWithImpl<$Res, _$TherapySessionImpl>
    implements _$$TherapySessionImplCopyWith<$Res> {
  __$$TherapySessionImplCopyWithImpl(
    _$TherapySessionImpl _value,
    $Res Function(_$TherapySessionImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TherapySession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? childProfileId = null,
    Object? startTime = null,
    Object? endTime = freezed,
    Object? status = null,
    Object? exerciseAttempts = null,
    Object? totalExercises = null,
    Object? completedExercises = null,
    Object? successfulExercises = null,
    Object? averagePronunciationScore = null,
    Object? averageVolumeLevel = null,
    Object? averageArticulationScore = null,
    Object? notes = freezed,
  }) {
    return _then(
      _$TherapySessionImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        childProfileId: null == childProfileId
            ? _value.childProfileId
            : childProfileId // ignore: cast_nullable_to_non_nullable
                  as String,
        startTime: null == startTime
            ? _value.startTime
            : startTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        endTime: freezed == endTime
            ? _value.endTime
            : endTime // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as SessionStatus,
        exerciseAttempts: null == exerciseAttempts
            ? _value._exerciseAttempts
            : exerciseAttempts // ignore: cast_nullable_to_non_nullable
                  as List<ExerciseAttempt>,
        totalExercises: null == totalExercises
            ? _value.totalExercises
            : totalExercises // ignore: cast_nullable_to_non_nullable
                  as int,
        completedExercises: null == completedExercises
            ? _value.completedExercises
            : completedExercises // ignore: cast_nullable_to_non_nullable
                  as int,
        successfulExercises: null == successfulExercises
            ? _value.successfulExercises
            : successfulExercises // ignore: cast_nullable_to_non_nullable
                  as int,
        averagePronunciationScore: null == averagePronunciationScore
            ? _value.averagePronunciationScore
            : averagePronunciationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        averageVolumeLevel: null == averageVolumeLevel
            ? _value.averageVolumeLevel
            : averageVolumeLevel // ignore: cast_nullable_to_non_nullable
                  as double,
        averageArticulationScore: null == averageArticulationScore
            ? _value.averageArticulationScore
            : averageArticulationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        notes: freezed == notes
            ? _value.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TherapySessionImpl implements _TherapySession {
  const _$TherapySessionImpl({
    required this.id,
    required this.childProfileId,
    required this.startTime,
    this.endTime,
    this.status = SessionStatus.inProgress,
    final List<ExerciseAttempt> exerciseAttempts = const [],
    this.totalExercises = 0,
    this.completedExercises = 0,
    this.successfulExercises = 0,
    this.averagePronunciationScore = 0.0,
    this.averageVolumeLevel = 0.0,
    this.averageArticulationScore = 0.0,
    this.notes,
  }) : _exerciseAttempts = exerciseAttempts;

  factory _$TherapySessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TherapySessionImplFromJson(json);

  @override
  final String id;
  @override
  final String childProfileId;
  // Session info
  @override
  final DateTime startTime;
  @override
  final DateTime? endTime;
  @override
  @JsonKey()
  final SessionStatus status;
  // Exercises in this session
  final List<ExerciseAttempt> _exerciseAttempts;
  // Exercises in this session
  @override
  @JsonKey()
  List<ExerciseAttempt> get exerciseAttempts {
    if (_exerciseAttempts is EqualUnmodifiableListView)
      return _exerciseAttempts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_exerciseAttempts);
  }

  // Session statistics
  @override
  @JsonKey()
  final int totalExercises;
  @override
  @JsonKey()
  final int completedExercises;
  @override
  @JsonKey()
  final int successfulExercises;
  // Performance metrics
  @override
  @JsonKey()
  final double averagePronunciationScore;
  @override
  @JsonKey()
  final double averageVolumeLevel;
  @override
  @JsonKey()
  final double averageArticulationScore;
  // Notes
  @override
  final String? notes;

  @override
  String toString() {
    return 'TherapySession(id: $id, childProfileId: $childProfileId, startTime: $startTime, endTime: $endTime, status: $status, exerciseAttempts: $exerciseAttempts, totalExercises: $totalExercises, completedExercises: $completedExercises, successfulExercises: $successfulExercises, averagePronunciationScore: $averagePronunciationScore, averageVolumeLevel: $averageVolumeLevel, averageArticulationScore: $averageArticulationScore, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TherapySessionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.childProfileId, childProfileId) ||
                other.childProfileId == childProfileId) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.status, status) || other.status == status) &&
            const DeepCollectionEquality().equals(
              other._exerciseAttempts,
              _exerciseAttempts,
            ) &&
            (identical(other.totalExercises, totalExercises) ||
                other.totalExercises == totalExercises) &&
            (identical(other.completedExercises, completedExercises) ||
                other.completedExercises == completedExercises) &&
            (identical(other.successfulExercises, successfulExercises) ||
                other.successfulExercises == successfulExercises) &&
            (identical(
                  other.averagePronunciationScore,
                  averagePronunciationScore,
                ) ||
                other.averagePronunciationScore == averagePronunciationScore) &&
            (identical(other.averageVolumeLevel, averageVolumeLevel) ||
                other.averageVolumeLevel == averageVolumeLevel) &&
            (identical(
                  other.averageArticulationScore,
                  averageArticulationScore,
                ) ||
                other.averageArticulationScore == averageArticulationScore) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    childProfileId,
    startTime,
    endTime,
    status,
    const DeepCollectionEquality().hash(_exerciseAttempts),
    totalExercises,
    completedExercises,
    successfulExercises,
    averagePronunciationScore,
    averageVolumeLevel,
    averageArticulationScore,
    notes,
  );

  /// Create a copy of TherapySession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TherapySessionImplCopyWith<_$TherapySessionImpl> get copyWith =>
      __$$TherapySessionImplCopyWithImpl<_$TherapySessionImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$TherapySessionImplToJson(this);
  }
}

abstract class _TherapySession implements TherapySession {
  const factory _TherapySession({
    required final String id,
    required final String childProfileId,
    required final DateTime startTime,
    final DateTime? endTime,
    final SessionStatus status,
    final List<ExerciseAttempt> exerciseAttempts,
    final int totalExercises,
    final int completedExercises,
    final int successfulExercises,
    final double averagePronunciationScore,
    final double averageVolumeLevel,
    final double averageArticulationScore,
    final String? notes,
  }) = _$TherapySessionImpl;

  factory _TherapySession.fromJson(Map<String, dynamic> json) =
      _$TherapySessionImpl.fromJson;

  @override
  String get id;
  @override
  String get childProfileId; // Session info
  @override
  DateTime get startTime;
  @override
  DateTime? get endTime;
  @override
  SessionStatus get status; // Exercises in this session
  @override
  List<ExerciseAttempt> get exerciseAttempts; // Session statistics
  @override
  int get totalExercises;
  @override
  int get completedExercises;
  @override
  int get successfulExercises; // Performance metrics
  @override
  double get averagePronunciationScore;
  @override
  double get averageVolumeLevel;
  @override
  double get averageArticulationScore; // Notes
  @override
  String? get notes;

  /// Create a copy of TherapySession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TherapySessionImplCopyWith<_$TherapySessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ExerciseAttempt _$ExerciseAttemptFromJson(Map<String, dynamic> json) {
  return _ExerciseAttempt.fromJson(json);
}

/// @nodoc
mixin _$ExerciseAttempt {
  String get id => throw _privateConstructorUsedError;
  Exercise get exercise => throw _privateConstructorUsedError;
  DateTime get attemptTime => throw _privateConstructorUsedError; // Result
  SpeechAnalysisResult? get result =>
      throw _privateConstructorUsedError; // Attempt status
  AttemptStatus get status =>
      throw _privateConstructorUsedError; // Number of tries
  int get attemptNumber => throw _privateConstructorUsedError; // Duration
  Duration? get duration => throw _privateConstructorUsedError;

  /// Serializes this ExerciseAttempt to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ExerciseAttemptCopyWith<ExerciseAttempt> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExerciseAttemptCopyWith<$Res> {
  factory $ExerciseAttemptCopyWith(
    ExerciseAttempt value,
    $Res Function(ExerciseAttempt) then,
  ) = _$ExerciseAttemptCopyWithImpl<$Res, ExerciseAttempt>;
  @useResult
  $Res call({
    String id,
    Exercise exercise,
    DateTime attemptTime,
    SpeechAnalysisResult? result,
    AttemptStatus status,
    int attemptNumber,
    Duration? duration,
  });

  $ExerciseCopyWith<$Res> get exercise;
  $SpeechAnalysisResultCopyWith<$Res>? get result;
}

/// @nodoc
class _$ExerciseAttemptCopyWithImpl<$Res, $Val extends ExerciseAttempt>
    implements $ExerciseAttemptCopyWith<$Res> {
  _$ExerciseAttemptCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exercise = null,
    Object? attemptTime = null,
    Object? result = freezed,
    Object? status = null,
    Object? attemptNumber = null,
    Object? duration = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            exercise: null == exercise
                ? _value.exercise
                : exercise // ignore: cast_nullable_to_non_nullable
                      as Exercise,
            attemptTime: null == attemptTime
                ? _value.attemptTime
                : attemptTime // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            result: freezed == result
                ? _value.result
                : result // ignore: cast_nullable_to_non_nullable
                      as SpeechAnalysisResult?,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as AttemptStatus,
            attemptNumber: null == attemptNumber
                ? _value.attemptNumber
                : attemptNumber // ignore: cast_nullable_to_non_nullable
                      as int,
            duration: freezed == duration
                ? _value.duration
                : duration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
          )
          as $Val,
    );
  }

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ExerciseCopyWith<$Res> get exercise {
    return $ExerciseCopyWith<$Res>(_value.exercise, (value) {
      return _then(_value.copyWith(exercise: value) as $Val);
    });
  }

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpeechAnalysisResultCopyWith<$Res>? get result {
    if (_value.result == null) {
      return null;
    }

    return $SpeechAnalysisResultCopyWith<$Res>(_value.result!, (value) {
      return _then(_value.copyWith(result: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ExerciseAttemptImplCopyWith<$Res>
    implements $ExerciseAttemptCopyWith<$Res> {
  factory _$$ExerciseAttemptImplCopyWith(
    _$ExerciseAttemptImpl value,
    $Res Function(_$ExerciseAttemptImpl) then,
  ) = __$$ExerciseAttemptImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    Exercise exercise,
    DateTime attemptTime,
    SpeechAnalysisResult? result,
    AttemptStatus status,
    int attemptNumber,
    Duration? duration,
  });

  @override
  $ExerciseCopyWith<$Res> get exercise;
  @override
  $SpeechAnalysisResultCopyWith<$Res>? get result;
}

/// @nodoc
class __$$ExerciseAttemptImplCopyWithImpl<$Res>
    extends _$ExerciseAttemptCopyWithImpl<$Res, _$ExerciseAttemptImpl>
    implements _$$ExerciseAttemptImplCopyWith<$Res> {
  __$$ExerciseAttemptImplCopyWithImpl(
    _$ExerciseAttemptImpl _value,
    $Res Function(_$ExerciseAttemptImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? exercise = null,
    Object? attemptTime = null,
    Object? result = freezed,
    Object? status = null,
    Object? attemptNumber = null,
    Object? duration = freezed,
  }) {
    return _then(
      _$ExerciseAttemptImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        exercise: null == exercise
            ? _value.exercise
            : exercise // ignore: cast_nullable_to_non_nullable
                  as Exercise,
        attemptTime: null == attemptTime
            ? _value.attemptTime
            : attemptTime // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        result: freezed == result
            ? _value.result
            : result // ignore: cast_nullable_to_non_nullable
                  as SpeechAnalysisResult?,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as AttemptStatus,
        attemptNumber: null == attemptNumber
            ? _value.attemptNumber
            : attemptNumber // ignore: cast_nullable_to_non_nullable
                  as int,
        duration: freezed == duration
            ? _value.duration
            : duration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ExerciseAttemptImpl implements _ExerciseAttempt {
  const _$ExerciseAttemptImpl({
    required this.id,
    required this.exercise,
    required this.attemptTime,
    this.result,
    this.status = AttemptStatus.pending,
    this.attemptNumber = 1,
    this.duration,
  });

  factory _$ExerciseAttemptImpl.fromJson(Map<String, dynamic> json) =>
      _$$ExerciseAttemptImplFromJson(json);

  @override
  final String id;
  @override
  final Exercise exercise;
  @override
  final DateTime attemptTime;
  // Result
  @override
  final SpeechAnalysisResult? result;
  // Attempt status
  @override
  @JsonKey()
  final AttemptStatus status;
  // Number of tries
  @override
  @JsonKey()
  final int attemptNumber;
  // Duration
  @override
  final Duration? duration;

  @override
  String toString() {
    return 'ExerciseAttempt(id: $id, exercise: $exercise, attemptTime: $attemptTime, result: $result, status: $status, attemptNumber: $attemptNumber, duration: $duration)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExerciseAttemptImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.exercise, exercise) ||
                other.exercise == exercise) &&
            (identical(other.attemptTime, attemptTime) ||
                other.attemptTime == attemptTime) &&
            (identical(other.result, result) || other.result == result) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.attemptNumber, attemptNumber) ||
                other.attemptNumber == attemptNumber) &&
            (identical(other.duration, duration) ||
                other.duration == duration));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    exercise,
    attemptTime,
    result,
    status,
    attemptNumber,
    duration,
  );

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ExerciseAttemptImplCopyWith<_$ExerciseAttemptImpl> get copyWith =>
      __$$ExerciseAttemptImplCopyWithImpl<_$ExerciseAttemptImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ExerciseAttemptImplToJson(this);
  }
}

abstract class _ExerciseAttempt implements ExerciseAttempt {
  const factory _ExerciseAttempt({
    required final String id,
    required final Exercise exercise,
    required final DateTime attemptTime,
    final SpeechAnalysisResult? result,
    final AttemptStatus status,
    final int attemptNumber,
    final Duration? duration,
  }) = _$ExerciseAttemptImpl;

  factory _ExerciseAttempt.fromJson(Map<String, dynamic> json) =
      _$ExerciseAttemptImpl.fromJson;

  @override
  String get id;
  @override
  Exercise get exercise;
  @override
  DateTime get attemptTime; // Result
  @override
  SpeechAnalysisResult? get result; // Attempt status
  @override
  AttemptStatus get status; // Number of tries
  @override
  int get attemptNumber; // Duration
  @override
  Duration? get duration;

  /// Create a copy of ExerciseAttempt
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ExerciseAttemptImplCopyWith<_$ExerciseAttemptImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
