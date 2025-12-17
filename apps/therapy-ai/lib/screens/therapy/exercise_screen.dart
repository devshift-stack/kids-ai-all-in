import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../models/exercise.dart';
import '../../models/child_profile.dart';
import '../../widgets/speech_recording_widget.dart';
import '../../providers/therapy_session_provider.dart';
import '../../providers/child_profile_provider.dart';
import '../../providers/services_providers.dart';
import '../../services/whisper_speech_service.dart';
import '../../services/audio_analysis_service.dart';
import '../../services/elevenlabs_voice_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/app_constants.dart';

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

  @override
  void initState() {
    super.initState();
    _startSessionIfNeeded();
    _playTargetWord();
  }

  @override
  void dispose() {
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
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Starten der Aufnahme: $e';
      });
      ref.read(therapySessionProvider.notifier).setRecording(false);
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioService.stopRecording();
      ref.read(therapySessionProvider.notifier).setRecording(false);

      if (path != null) {
        setState(() {
          _recordingPath = path;
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
      final result = await whisperService.transcribeAudio(audioPath);

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
          '/exercise-result',
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: KidsColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.school,
              color: KidsColors.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Schwierigkeit: ${widget.exercise.difficultyLevel}/10',
                  style: KidsTypography.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  'Dauer: ~${widget.exercise.expectedDuration.inSeconds}s',
                  style: KidsTypography.caption.copyWith(
                    color: KidsColors.textSecondary,
                  ),
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
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: KidsGradients.primaryGradient,
        borderRadius: BorderRadius.circular(24),
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
            style: KidsTypography.bodyLarge.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            widget.exercise.targetWord,
            style: KidsTypography.h1.copyWith(
              color: Colors.white,
              fontSize: 48,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          IconButton(
            onPressed: _playTargetWord,
            icon: const Icon(Icons.volume_up, color: Colors.white, size: 32),
            tooltip: 'Nochmal abspielen',
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingSection(TherapySessionState sessionState) {
    return Column(
      children: [
        SpeechRecordingWidget(
          isRecording: sessionState.isRecording,
          volumeLevel: 0.7, // TODO: Echte Volume-Level aus AudioService
          onStartRecording: _startRecording,
          onStopRecording: _stopRecording,
          duration: sessionState.isRecording
              ? AppConstants.maxRecordingDuration
              : null,
        ),
        if (sessionState.isAnalyzing) ...[
          const SizedBox(height: 24),
          Text(
            'Analysiere deine Aussprache...',
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          const CircularProgressIndicator(),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KidsColors.infoLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KidsColors.info),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: KidsColors.info),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.exercise.instructions!,
              style: KidsTypography.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

