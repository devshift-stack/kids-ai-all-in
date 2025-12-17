// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'speech_analysis_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SpeechAnalysisResult _$SpeechAnalysisResultFromJson(Map<String, dynamic> json) {
  return _SpeechAnalysisResult.fromJson(json);
}

/// @nodoc
mixin _$SpeechAnalysisResult {
  // Transcription
  String get transcription => throw _privateConstructorUsedError;
  String get targetWord => throw _privateConstructorUsedError; // Scores (0-100)
  double get pronunciationScore => throw _privateConstructorUsedError;
  double get volumeLevel => throw _privateConstructorUsedError; // dB
  double get articulationScore => throw _privateConstructorUsedError;
  double get similarityScore => throw _privateConstructorUsedError; // 0-1
  // Phoneme analysis
  List<PhonemeAccuracy> get phonemeBreakdown =>
      throw _privateConstructorUsedError; // Volume analysis
  double get averageVolume => throw _privateConstructorUsedError;
  double get peakVolume => throw _privateConstructorUsedError;
  double get volumeConsistency =>
      throw _privateConstructorUsedError; // Timing analysis
  Duration? get speechDuration => throw _privateConstructorUsedError;
  Duration? get pauseDuration => throw _privateConstructorUsedError; // Feedback
  String get feedbackMessage => throw _privateConstructorUsedError;
  List<String> get recommendations =>
      throw _privateConstructorUsedError; // Overall assessment
  bool get isSuccessful => throw _privateConstructorUsedError;
  bool get needsRepetition => throw _privateConstructorUsedError; // Metadata
  DateTime get analyzedAt => throw _privateConstructorUsedError;
  String? get audioFilePath => throw _privateConstructorUsedError;

  /// Serializes this SpeechAnalysisResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SpeechAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SpeechAnalysisResultCopyWith<SpeechAnalysisResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SpeechAnalysisResultCopyWith<$Res> {
  factory $SpeechAnalysisResultCopyWith(
    SpeechAnalysisResult value,
    $Res Function(SpeechAnalysisResult) then,
  ) = _$SpeechAnalysisResultCopyWithImpl<$Res, SpeechAnalysisResult>;
  @useResult
  $Res call({
    String transcription,
    String targetWord,
    double pronunciationScore,
    double volumeLevel,
    double articulationScore,
    double similarityScore,
    List<PhonemeAccuracy> phonemeBreakdown,
    double averageVolume,
    double peakVolume,
    double volumeConsistency,
    Duration? speechDuration,
    Duration? pauseDuration,
    String feedbackMessage,
    List<String> recommendations,
    bool isSuccessful,
    bool needsRepetition,
    DateTime analyzedAt,
    String? audioFilePath,
  });
}

/// @nodoc
class _$SpeechAnalysisResultCopyWithImpl<
  $Res,
  $Val extends SpeechAnalysisResult
>
    implements $SpeechAnalysisResultCopyWith<$Res> {
  _$SpeechAnalysisResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SpeechAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcription = null,
    Object? targetWord = null,
    Object? pronunciationScore = null,
    Object? volumeLevel = null,
    Object? articulationScore = null,
    Object? similarityScore = null,
    Object? phonemeBreakdown = null,
    Object? averageVolume = null,
    Object? peakVolume = null,
    Object? volumeConsistency = null,
    Object? speechDuration = freezed,
    Object? pauseDuration = freezed,
    Object? feedbackMessage = null,
    Object? recommendations = null,
    Object? isSuccessful = null,
    Object? needsRepetition = null,
    Object? analyzedAt = null,
    Object? audioFilePath = freezed,
  }) {
    return _then(
      _value.copyWith(
            transcription: null == transcription
                ? _value.transcription
                : transcription // ignore: cast_nullable_to_non_nullable
                      as String,
            targetWord: null == targetWord
                ? _value.targetWord
                : targetWord // ignore: cast_nullable_to_non_nullable
                      as String,
            pronunciationScore: null == pronunciationScore
                ? _value.pronunciationScore
                : pronunciationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            volumeLevel: null == volumeLevel
                ? _value.volumeLevel
                : volumeLevel // ignore: cast_nullable_to_non_nullable
                      as double,
            articulationScore: null == articulationScore
                ? _value.articulationScore
                : articulationScore // ignore: cast_nullable_to_non_nullable
                      as double,
            similarityScore: null == similarityScore
                ? _value.similarityScore
                : similarityScore // ignore: cast_nullable_to_non_nullable
                      as double,
            phonemeBreakdown: null == phonemeBreakdown
                ? _value.phonemeBreakdown
                : phonemeBreakdown // ignore: cast_nullable_to_non_nullable
                      as List<PhonemeAccuracy>,
            averageVolume: null == averageVolume
                ? _value.averageVolume
                : averageVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            peakVolume: null == peakVolume
                ? _value.peakVolume
                : peakVolume // ignore: cast_nullable_to_non_nullable
                      as double,
            volumeConsistency: null == volumeConsistency
                ? _value.volumeConsistency
                : volumeConsistency // ignore: cast_nullable_to_non_nullable
                      as double,
            speechDuration: freezed == speechDuration
                ? _value.speechDuration
                : speechDuration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
            pauseDuration: freezed == pauseDuration
                ? _value.pauseDuration
                : pauseDuration // ignore: cast_nullable_to_non_nullable
                      as Duration?,
            feedbackMessage: null == feedbackMessage
                ? _value.feedbackMessage
                : feedbackMessage // ignore: cast_nullable_to_non_nullable
                      as String,
            recommendations: null == recommendations
                ? _value.recommendations
                : recommendations // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            isSuccessful: null == isSuccessful
                ? _value.isSuccessful
                : isSuccessful // ignore: cast_nullable_to_non_nullable
                      as bool,
            needsRepetition: null == needsRepetition
                ? _value.needsRepetition
                : needsRepetition // ignore: cast_nullable_to_non_nullable
                      as bool,
            analyzedAt: null == analyzedAt
                ? _value.analyzedAt
                : analyzedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            audioFilePath: freezed == audioFilePath
                ? _value.audioFilePath
                : audioFilePath // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SpeechAnalysisResultImplCopyWith<$Res>
    implements $SpeechAnalysisResultCopyWith<$Res> {
  factory _$$SpeechAnalysisResultImplCopyWith(
    _$SpeechAnalysisResultImpl value,
    $Res Function(_$SpeechAnalysisResultImpl) then,
  ) = __$$SpeechAnalysisResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String transcription,
    String targetWord,
    double pronunciationScore,
    double volumeLevel,
    double articulationScore,
    double similarityScore,
    List<PhonemeAccuracy> phonemeBreakdown,
    double averageVolume,
    double peakVolume,
    double volumeConsistency,
    Duration? speechDuration,
    Duration? pauseDuration,
    String feedbackMessage,
    List<String> recommendations,
    bool isSuccessful,
    bool needsRepetition,
    DateTime analyzedAt,
    String? audioFilePath,
  });
}

/// @nodoc
class __$$SpeechAnalysisResultImplCopyWithImpl<$Res>
    extends _$SpeechAnalysisResultCopyWithImpl<$Res, _$SpeechAnalysisResultImpl>
    implements _$$SpeechAnalysisResultImplCopyWith<$Res> {
  __$$SpeechAnalysisResultImplCopyWithImpl(
    _$SpeechAnalysisResultImpl _value,
    $Res Function(_$SpeechAnalysisResultImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SpeechAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? transcription = null,
    Object? targetWord = null,
    Object? pronunciationScore = null,
    Object? volumeLevel = null,
    Object? articulationScore = null,
    Object? similarityScore = null,
    Object? phonemeBreakdown = null,
    Object? averageVolume = null,
    Object? peakVolume = null,
    Object? volumeConsistency = null,
    Object? speechDuration = freezed,
    Object? pauseDuration = freezed,
    Object? feedbackMessage = null,
    Object? recommendations = null,
    Object? isSuccessful = null,
    Object? needsRepetition = null,
    Object? analyzedAt = null,
    Object? audioFilePath = freezed,
  }) {
    return _then(
      _$SpeechAnalysisResultImpl(
        transcription: null == transcription
            ? _value.transcription
            : transcription // ignore: cast_nullable_to_non_nullable
                  as String,
        targetWord: null == targetWord
            ? _value.targetWord
            : targetWord // ignore: cast_nullable_to_non_nullable
                  as String,
        pronunciationScore: null == pronunciationScore
            ? _value.pronunciationScore
            : pronunciationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        volumeLevel: null == volumeLevel
            ? _value.volumeLevel
            : volumeLevel // ignore: cast_nullable_to_non_nullable
                  as double,
        articulationScore: null == articulationScore
            ? _value.articulationScore
            : articulationScore // ignore: cast_nullable_to_non_nullable
                  as double,
        similarityScore: null == similarityScore
            ? _value.similarityScore
            : similarityScore // ignore: cast_nullable_to_non_nullable
                  as double,
        phonemeBreakdown: null == phonemeBreakdown
            ? _value._phonemeBreakdown
            : phonemeBreakdown // ignore: cast_nullable_to_non_nullable
                  as List<PhonemeAccuracy>,
        averageVolume: null == averageVolume
            ? _value.averageVolume
            : averageVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        peakVolume: null == peakVolume
            ? _value.peakVolume
            : peakVolume // ignore: cast_nullable_to_non_nullable
                  as double,
        volumeConsistency: null == volumeConsistency
            ? _value.volumeConsistency
            : volumeConsistency // ignore: cast_nullable_to_non_nullable
                  as double,
        speechDuration: freezed == speechDuration
            ? _value.speechDuration
            : speechDuration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        pauseDuration: freezed == pauseDuration
            ? _value.pauseDuration
            : pauseDuration // ignore: cast_nullable_to_non_nullable
                  as Duration?,
        feedbackMessage: null == feedbackMessage
            ? _value.feedbackMessage
            : feedbackMessage // ignore: cast_nullable_to_non_nullable
                  as String,
        recommendations: null == recommendations
            ? _value._recommendations
            : recommendations // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        isSuccessful: null == isSuccessful
            ? _value.isSuccessful
            : isSuccessful // ignore: cast_nullable_to_non_nullable
                  as bool,
        needsRepetition: null == needsRepetition
            ? _value.needsRepetition
            : needsRepetition // ignore: cast_nullable_to_non_nullable
                  as bool,
        analyzedAt: null == analyzedAt
            ? _value.analyzedAt
            : analyzedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        audioFilePath: freezed == audioFilePath
            ? _value.audioFilePath
            : audioFilePath // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SpeechAnalysisResultImpl implements _SpeechAnalysisResult {
  const _$SpeechAnalysisResultImpl({
    required this.transcription,
    required this.targetWord,
    required this.pronunciationScore,
    required this.volumeLevel,
    required this.articulationScore,
    required this.similarityScore,
    final List<PhonemeAccuracy> phonemeBreakdown = const [],
    this.averageVolume = 0.0,
    this.peakVolume = 0.0,
    this.volumeConsistency = 0.0,
    this.speechDuration,
    this.pauseDuration,
    required this.feedbackMessage,
    final List<String> recommendations = const [],
    required this.isSuccessful,
    required this.needsRepetition,
    required this.analyzedAt,
    this.audioFilePath,
  }) : _phonemeBreakdown = phonemeBreakdown,
       _recommendations = recommendations;

  factory _$SpeechAnalysisResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$SpeechAnalysisResultImplFromJson(json);

  // Transcription
  @override
  final String transcription;
  @override
  final String targetWord;
  // Scores (0-100)
  @override
  final double pronunciationScore;
  @override
  final double volumeLevel;
  // dB
  @override
  final double articulationScore;
  @override
  final double similarityScore;
  // 0-1
  // Phoneme analysis
  final List<PhonemeAccuracy> _phonemeBreakdown;
  // 0-1
  // Phoneme analysis
  @override
  @JsonKey()
  List<PhonemeAccuracy> get phonemeBreakdown {
    if (_phonemeBreakdown is EqualUnmodifiableListView)
      return _phonemeBreakdown;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_phonemeBreakdown);
  }

  // Volume analysis
  @override
  @JsonKey()
  final double averageVolume;
  @override
  @JsonKey()
  final double peakVolume;
  @override
  @JsonKey()
  final double volumeConsistency;
  // Timing analysis
  @override
  final Duration? speechDuration;
  @override
  final Duration? pauseDuration;
  // Feedback
  @override
  final String feedbackMessage;
  final List<String> _recommendations;
  @override
  @JsonKey()
  List<String> get recommendations {
    if (_recommendations is EqualUnmodifiableListView) return _recommendations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendations);
  }

  // Overall assessment
  @override
  final bool isSuccessful;
  @override
  final bool needsRepetition;
  // Metadata
  @override
  final DateTime analyzedAt;
  @override
  final String? audioFilePath;

  @override
  String toString() {
    return 'SpeechAnalysisResult(transcription: $transcription, targetWord: $targetWord, pronunciationScore: $pronunciationScore, volumeLevel: $volumeLevel, articulationScore: $articulationScore, similarityScore: $similarityScore, phonemeBreakdown: $phonemeBreakdown, averageVolume: $averageVolume, peakVolume: $peakVolume, volumeConsistency: $volumeConsistency, speechDuration: $speechDuration, pauseDuration: $pauseDuration, feedbackMessage: $feedbackMessage, recommendations: $recommendations, isSuccessful: $isSuccessful, needsRepetition: $needsRepetition, analyzedAt: $analyzedAt, audioFilePath: $audioFilePath)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SpeechAnalysisResultImpl &&
            (identical(other.transcription, transcription) ||
                other.transcription == transcription) &&
            (identical(other.targetWord, targetWord) ||
                other.targetWord == targetWord) &&
            (identical(other.pronunciationScore, pronunciationScore) ||
                other.pronunciationScore == pronunciationScore) &&
            (identical(other.volumeLevel, volumeLevel) ||
                other.volumeLevel == volumeLevel) &&
            (identical(other.articulationScore, articulationScore) ||
                other.articulationScore == articulationScore) &&
            (identical(other.similarityScore, similarityScore) ||
                other.similarityScore == similarityScore) &&
            const DeepCollectionEquality().equals(
              other._phonemeBreakdown,
              _phonemeBreakdown,
            ) &&
            (identical(other.averageVolume, averageVolume) ||
                other.averageVolume == averageVolume) &&
            (identical(other.peakVolume, peakVolume) ||
                other.peakVolume == peakVolume) &&
            (identical(other.volumeConsistency, volumeConsistency) ||
                other.volumeConsistency == volumeConsistency) &&
            (identical(other.speechDuration, speechDuration) ||
                other.speechDuration == speechDuration) &&
            (identical(other.pauseDuration, pauseDuration) ||
                other.pauseDuration == pauseDuration) &&
            (identical(other.feedbackMessage, feedbackMessage) ||
                other.feedbackMessage == feedbackMessage) &&
            const DeepCollectionEquality().equals(
              other._recommendations,
              _recommendations,
            ) &&
            (identical(other.isSuccessful, isSuccessful) ||
                other.isSuccessful == isSuccessful) &&
            (identical(other.needsRepetition, needsRepetition) ||
                other.needsRepetition == needsRepetition) &&
            (identical(other.analyzedAt, analyzedAt) ||
                other.analyzedAt == analyzedAt) &&
            (identical(other.audioFilePath, audioFilePath) ||
                other.audioFilePath == audioFilePath));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    transcription,
    targetWord,
    pronunciationScore,
    volumeLevel,
    articulationScore,
    similarityScore,
    const DeepCollectionEquality().hash(_phonemeBreakdown),
    averageVolume,
    peakVolume,
    volumeConsistency,
    speechDuration,
    pauseDuration,
    feedbackMessage,
    const DeepCollectionEquality().hash(_recommendations),
    isSuccessful,
    needsRepetition,
    analyzedAt,
    audioFilePath,
  );

  /// Create a copy of SpeechAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SpeechAnalysisResultImplCopyWith<_$SpeechAnalysisResultImpl>
  get copyWith =>
      __$$SpeechAnalysisResultImplCopyWithImpl<_$SpeechAnalysisResultImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$SpeechAnalysisResultImplToJson(this);
  }
}

abstract class _SpeechAnalysisResult implements SpeechAnalysisResult {
  const factory _SpeechAnalysisResult({
    required final String transcription,
    required final String targetWord,
    required final double pronunciationScore,
    required final double volumeLevel,
    required final double articulationScore,
    required final double similarityScore,
    final List<PhonemeAccuracy> phonemeBreakdown,
    final double averageVolume,
    final double peakVolume,
    final double volumeConsistency,
    final Duration? speechDuration,
    final Duration? pauseDuration,
    required final String feedbackMessage,
    final List<String> recommendations,
    required final bool isSuccessful,
    required final bool needsRepetition,
    required final DateTime analyzedAt,
    final String? audioFilePath,
  }) = _$SpeechAnalysisResultImpl;

  factory _SpeechAnalysisResult.fromJson(Map<String, dynamic> json) =
      _$SpeechAnalysisResultImpl.fromJson;

  // Transcription
  @override
  String get transcription;
  @override
  String get targetWord; // Scores (0-100)
  @override
  double get pronunciationScore;
  @override
  double get volumeLevel; // dB
  @override
  double get articulationScore;
  @override
  double get similarityScore; // 0-1
  // Phoneme analysis
  @override
  List<PhonemeAccuracy> get phonemeBreakdown; // Volume analysis
  @override
  double get averageVolume;
  @override
  double get peakVolume;
  @override
  double get volumeConsistency; // Timing analysis
  @override
  Duration? get speechDuration;
  @override
  Duration? get pauseDuration; // Feedback
  @override
  String get feedbackMessage;
  @override
  List<String> get recommendations; // Overall assessment
  @override
  bool get isSuccessful;
  @override
  bool get needsRepetition; // Metadata
  @override
  DateTime get analyzedAt;
  @override
  String? get audioFilePath;

  /// Create a copy of SpeechAnalysisResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SpeechAnalysisResultImplCopyWith<_$SpeechAnalysisResultImpl>
  get copyWith => throw _privateConstructorUsedError;
}

PhonemeAccuracy _$PhonemeAccuracyFromJson(Map<String, dynamic> json) {
  return _PhonemeAccuracy.fromJson(json);
}

/// @nodoc
mixin _$PhonemeAccuracy {
  String get phoneme => throw _privateConstructorUsedError;
  double get accuracy => throw _privateConstructorUsedError; // 0-1
  bool get isCorrect => throw _privateConstructorUsedError;
  String? get errorType => throw _privateConstructorUsedError;

  /// Serializes this PhonemeAccuracy to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PhonemeAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PhonemeAccuracyCopyWith<PhonemeAccuracy> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PhonemeAccuracyCopyWith<$Res> {
  factory $PhonemeAccuracyCopyWith(
    PhonemeAccuracy value,
    $Res Function(PhonemeAccuracy) then,
  ) = _$PhonemeAccuracyCopyWithImpl<$Res, PhonemeAccuracy>;
  @useResult
  $Res call({
    String phoneme,
    double accuracy,
    bool isCorrect,
    String? errorType,
  });
}

/// @nodoc
class _$PhonemeAccuracyCopyWithImpl<$Res, $Val extends PhonemeAccuracy>
    implements $PhonemeAccuracyCopyWith<$Res> {
  _$PhonemeAccuracyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PhonemeAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneme = null,
    Object? accuracy = null,
    Object? isCorrect = null,
    Object? errorType = freezed,
  }) {
    return _then(
      _value.copyWith(
            phoneme: null == phoneme
                ? _value.phoneme
                : phoneme // ignore: cast_nullable_to_non_nullable
                      as String,
            accuracy: null == accuracy
                ? _value.accuracy
                : accuracy // ignore: cast_nullable_to_non_nullable
                      as double,
            isCorrect: null == isCorrect
                ? _value.isCorrect
                : isCorrect // ignore: cast_nullable_to_non_nullable
                      as bool,
            errorType: freezed == errorType
                ? _value.errorType
                : errorType // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$PhonemeAccuracyImplCopyWith<$Res>
    implements $PhonemeAccuracyCopyWith<$Res> {
  factory _$$PhonemeAccuracyImplCopyWith(
    _$PhonemeAccuracyImpl value,
    $Res Function(_$PhonemeAccuracyImpl) then,
  ) = __$$PhonemeAccuracyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String phoneme,
    double accuracy,
    bool isCorrect,
    String? errorType,
  });
}

/// @nodoc
class __$$PhonemeAccuracyImplCopyWithImpl<$Res>
    extends _$PhonemeAccuracyCopyWithImpl<$Res, _$PhonemeAccuracyImpl>
    implements _$$PhonemeAccuracyImplCopyWith<$Res> {
  __$$PhonemeAccuracyImplCopyWithImpl(
    _$PhonemeAccuracyImpl _value,
    $Res Function(_$PhonemeAccuracyImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PhonemeAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? phoneme = null,
    Object? accuracy = null,
    Object? isCorrect = null,
    Object? errorType = freezed,
  }) {
    return _then(
      _$PhonemeAccuracyImpl(
        phoneme: null == phoneme
            ? _value.phoneme
            : phoneme // ignore: cast_nullable_to_non_nullable
                  as String,
        accuracy: null == accuracy
            ? _value.accuracy
            : accuracy // ignore: cast_nullable_to_non_nullable
                  as double,
        isCorrect: null == isCorrect
            ? _value.isCorrect
            : isCorrect // ignore: cast_nullable_to_non_nullable
                  as bool,
        errorType: freezed == errorType
            ? _value.errorType
            : errorType // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$PhonemeAccuracyImpl implements _PhonemeAccuracy {
  const _$PhonemeAccuracyImpl({
    required this.phoneme,
    required this.accuracy,
    required this.isCorrect,
    this.errorType,
  });

  factory _$PhonemeAccuracyImpl.fromJson(Map<String, dynamic> json) =>
      _$$PhonemeAccuracyImplFromJson(json);

  @override
  final String phoneme;
  @override
  final double accuracy;
  // 0-1
  @override
  final bool isCorrect;
  @override
  final String? errorType;

  @override
  String toString() {
    return 'PhonemeAccuracy(phoneme: $phoneme, accuracy: $accuracy, isCorrect: $isCorrect, errorType: $errorType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PhonemeAccuracyImpl &&
            (identical(other.phoneme, phoneme) || other.phoneme == phoneme) &&
            (identical(other.accuracy, accuracy) ||
                other.accuracy == accuracy) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.errorType, errorType) ||
                other.errorType == errorType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, phoneme, accuracy, isCorrect, errorType);

  /// Create a copy of PhonemeAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PhonemeAccuracyImplCopyWith<_$PhonemeAccuracyImpl> get copyWith =>
      __$$PhonemeAccuracyImplCopyWithImpl<_$PhonemeAccuracyImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$PhonemeAccuracyImplToJson(this);
  }
}

abstract class _PhonemeAccuracy implements PhonemeAccuracy {
  const factory _PhonemeAccuracy({
    required final String phoneme,
    required final double accuracy,
    required final bool isCorrect,
    final String? errorType,
  }) = _$PhonemeAccuracyImpl;

  factory _PhonemeAccuracy.fromJson(Map<String, dynamic> json) =
      _$PhonemeAccuracyImpl.fromJson;

  @override
  String get phoneme;
  @override
  double get accuracy; // 0-1
  @override
  bool get isCorrect;
  @override
  String? get errorType;

  /// Create a copy of PhonemeAccuracy
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PhonemeAccuracyImplCopyWith<_$PhonemeAccuracyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
