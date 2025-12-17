import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../models/exercise.dart';
import '../../models/child_profile.dart';
import '../../widgets/speech_recording_widget.dart';
import '../../widgets/animated_pulse_widget.dart';
import '../../widgets/waveform_widget.dart';
import '../../widgets/loading_animation_widget.dart';
import '../../providers/therapy_session_provider.dart';
import '../../providers/child_profile_provider.dart';
import '../../providers/services_providers.dart';
import '../../services/whisper_speech_service.dart';
import '../../services/audio_analysis_service.dart';
import '../../services/elevenlabs_voice_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../core/design_system.dart';

class ExerciseScreen extends ConsumerStatefulWidget {
  final Exercise exercise;

  const ExerciseScreen({
    super.key,
    required this.exercise,
  });

  @override
  ConsumerState<ExerciseScreen> createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends ConsumerState<ExerciseScreen> {
  final AudioAnalysisService _audioService = AudioAnalysisService();
  String? _recordingPath;
  bool _isProcessing = false;
  String? _errorMessage;
  double _currentVolumeLevel = 0.0;
  Timer? _volumeUpdateTimer;

  @override
  void initState() {
    super.initState();
    _startSessionIfNeeded();
    _playTargetWord();
  }

  @override
  void dispose() {
    _volumeUpdateTimer?.cancel();
    _audioService.dispose();
    super.dispose();
  }

  Future<void> _startSessionIfNeeded() async {
    final sessionState = ref.read(therapySessionProvider);
    final profileState = ref.read(childProfileProvider);

    if (sessionState.currentSession == null && profileState.profile != null) {
      await ref
          .read(therapySessionProvider.notifier)
          .startSession(profileState.profile!.id);
    }

    ref.read(therapySessionProvider.notifier).setCurrentExercise(widget.exercise);
  }

  Future<void> _playTargetWord() async {
    final profileState = ref.read(childProfileProvider);
    final profile = profileState.profile;
    if (profile == null || profile.clonedVoiceId == null) return;

    try {
      final voiceService = ref.read(elevenLabsVoiceServiceProvider);
      final audioPath = await voiceService.speakWithClonedVoice(
        text: widget.exercise.targetWord,
        voiceId: profile.clonedVoiceId!,
      );

      await _audioService.playAudio(audioPath);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Abspielen: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _startRecording() async {
    try {
      ref.read(therapySessionProvider.notifier).setRecording(true);
      final path = await _audioService.startRecording(
        duration: AppConstants.maxRecordingDuration,
      );
      setState(() {
        _recordingPath = path;
        _errorMessage = null;
        _currentVolumeLevel = 0.0;
      });
      
      // Starte Volume-Level Updates während Aufnahme
      _startVolumeTracking(path);
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Starten der Aufnahme: $e';
      });
      ref.read(therapySessionProvider.notifier).setRecording(false);
    }
  }

  void _startVolumeTracking(String audioPath) {
    _volumeUpdateTimer?.cancel();
    _volumeUpdateTimer = Timer.periodic(
      const Duration(milliseconds: 200), // Update alle 200ms
      (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }

        final sessionState = ref.read(therapySessionProvider);
        if (!sessionState.isRecording) {
          timer.cancel();
          return;
        }

        try {
          // Analysiere Audio-Datei während Aufnahme
          final features = await _audioService.analyzeAudioFeatures(audioPath);
          final volume = features['volume'] as double? ?? 0.0;
          
          // Normalisiere zu 0.0-1.0 für Widget
          final normalizedVolume = (volume / 100.0).clamp(0.0, 1.0);
          
          if (mounted) {
            setState(() {
              _currentVolumeLevel = normalizedVolume;
            });
          }
        } catch (e) {
          // Fehler ignorieren während Aufnahme
          // Volume-Level bleibt beim letzten Wert
        }
      },
    );
  }

  Future<void> _stopRecording() async {
    try {
      // Stoppe Volume-Tracking
      _volumeUpdateTimer?.cancel();
      _volumeUpdateTimer = null;
      
      final path = await _audioService.stopRecording();
      ref.read(therapySessionProvider.notifier).setRecording(false);

      if (path != null) {
        // Finale Volume-Analyse
        final features = await _audioService.analyzeAudioFeatures(path);
        final finalVolume = features['volume'] as double? ?? 0.0;
        final normalizedVolume = (finalVolume / 100.0).clamp(0.0, 1.0);
        
        setState(() {
          _recordingPath = path;
          _currentVolumeLevel = normalizedVolume;
        });
        await _analyzeRecording(path);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Stoppen der Aufnahme: $e';
      });
      ref.read(therapySessionProvider.notifier).setRecording(false);
    }
  }

  Future<void> _analyzeRecording(String audioPath) async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    ref.read(therapySessionProvider.notifier).setAnalyzing(true);

    try {
      final whisperService = ref.read(whisperSpeechServiceProvider);
      final result = await whisperService.analyzeSpeech(
        audioPath: audioPath,
        targetWord: widget.exercise.targetWord,
        language: ref.read(childProfileProvider).profile?.language,
      );

      // Speichere Ergebnis
      final profileState = ref.read(childProfileProvider);
      if (profileState.profile != null) {
        await ref.read(therapySessionProvider.notifier).recordExerciseResult(
              childId: profileState.profile!.id,
              result: result,
            );
      }

      ref.read(therapySessionProvider.notifier).setAnalyzing(false);

      if (mounted) {
        Navigator.of(context).pushNamed(
          AppRoutes.exerciseResult,
          arguments: {
            'exercise': widget.exercise,
            'result': result,
          },
        );
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler bei der Analyse: $e';
        _isProcessing = false;
      });
      ref.read(therapySessionProvider.notifier).setAnalyzing(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(therapySessionProvider);
    final profileState = ref.watch(childProfileProvider);

    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      appBar: AppBar(
        title: Text('Übung: ${widget.exercise.targetWord}'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // Exercise Info
              _buildExerciseInfo(),
              const SizedBox(height: 32),

              // Target Word Display
              _buildTargetWord(),
              const SizedBox(height: 32),

              // Recording Widget
              _buildRecordingSection(sessionState),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage != null) _buildErrorMessage(),
              const SizedBox(height: 24),

              // Instructions
              if (widget.exercise.instructions != null)
                _buildInstructions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExerciseInfo() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: TherapyDesignSystem.cardDecoration,
      child: Row(
        children: [
          Container(
            width: TherapyDesignSystem.touchTargetIcon,
            height: TherapyDesignSystem.touchTargetIcon,
            padding: const EdgeInsets.all(TherapyDesignSystem.spacingMD),
            decoration: BoxDecoration(
              color: TherapyDesignSystem.statusActiveBg,
              borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusMedium),
            ),
            child: Icon(
              Icons.school,
              color: TherapyDesignSystem.statusActive,
              size: TherapyDesignSystem.touchTargetIcon * 0.6,
            ),
          ),
          SizedBox(width: TherapyDesignSystem.spacingLG),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schwierigkeit: ${widget.exercise.difficultyLevel}/10',
                  style: TherapyDesignSystem.bodyLargeStyle,
                ),
                SizedBox(height: TherapyDesignSystem.spacingSM),
                Text(
                  'Dauer: ~${widget.exercise.expectedDuration.inSeconds}s',
                  style: TherapyDesignSystem.captionStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetWord() {
    return Container(
      padding: EdgeInsets.all(TherapyDesignSystem.spacingXXL),
      decoration: BoxDecoration(
        gradient: KidsGradients.primaryGradient,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusXLarge),
        boxShadow: [
          BoxShadow(
            color: KidsColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Sage nach:',
            style: TherapyDesignSystem.instructionStyle.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: TherapyDesignSystem.spacingXL),
          Text(
            widget.exercise.targetWord,
            style: TherapyDesignSystem.targetWordStyle.copyWith(
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: TherapyDesignSystem.spacingXL),
          SizedBox(
            width: TherapyDesignSystem.touchTargetPrimary,
            height: TherapyDesignSystem.touchTargetPrimary,
            child: IconButton(
              onPressed: () {
                TherapyDesignSystem.hapticSelection();
                _playTargetWord();
              },
              icon: const Icon(Icons.volume_up, color: Colors.white),
              iconSize: TherapyDesignSystem.touchTargetIcon,
              tooltip: 'Nochmal abspielen',
              style: TherapyDesignSystem.iconButtonLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection(TherapySessionState sessionState) {
    return Column(
      children: [
        // Wellenform während Aufnahme
        if (sessionState.isRecording) ...[
          SizedBox(height: TherapyDesignSystem.spacingXL),
          WaveformWidget(
            isActive: sessionState.isRecording,
            volumeLevel: _currentVolumeLevel,
            color: TherapyDesignSystem.statusActive,
            maxBarHeight: 80.0,
          ),
          SizedBox(height: TherapyDesignSystem.spacingXL),
        ],
        
        // Mikrofon-Button mit Pulse-Animation
        AnimatedPulseRing(
          isActive: sessionState.isRecording,
          ringColor: TherapyDesignSystem.statusActive,
          child: AnimatedPulseWidget(
            isActive: sessionState.isRecording,
            minScale: 0.95,
            maxScale: 1.05,
            child: SpeechRecordingWidget(
              isRecording: sessionState.isRecording,
              volumeLevel: _currentVolumeLevel,
              onStartRecording: _startRecording,
              onStopRecording: _stopRecording,
              duration: sessionState.isRecording
                  ? AppConstants.maxRecordingDuration
                  : null,
            ),
          ),
        ),
        if (sessionState.isAnalyzing) ...[
          SizedBox(height: TherapyDesignSystem.spacingXXL),
          Container(
            padding: TherapyDesignSystem.cardPadding,
            decoration: BoxDecoration(
              color: TherapyDesignSystem.statusActiveBg,
              borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
            ),
            child: LoadingAnimationWidget(
              message: 'Analysiere deine Aussprache...',
              color: TherapyDesignSystem.statusActive,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: KidsColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KidsColors.error),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: KidsColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: KidsTypography.bodyMedium.copyWith(
                color: KidsColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: TherapyDesignSystem.cardPadding,
      decoration: BoxDecoration(
        color: TherapyDesignSystem.statusActiveBg,
        borderRadius: BorderRadius.circular(TherapyDesignSystem.radiusLarge),
        border: Border.all(
          color: TherapyDesignSystem.statusActive,
          width: 2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            color: TherapyDesignSystem.statusActive,
            size: TherapyDesignSystem.touchTargetIcon * 0.7,
          ),
          SizedBox(width: TherapyDesignSystem.spacingLG),
          Expanded(
            child: Text(
              widget.exercise.instructions!,
              style: TherapyDesignSystem.bodyLargeStyle,
            ),
          ),
        ],
      ),
    );
  }
}

