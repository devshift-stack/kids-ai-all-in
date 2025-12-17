import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../../services/elevenlabs_voice_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class VoiceCloningScreen extends ConsumerStatefulWidget {
  const VoiceCloningScreen({super.key});

  @override
  ConsumerState<VoiceCloningScreen> createState() => _VoiceCloningScreenState();
}

class _VoiceCloningScreenState extends ConsumerState<VoiceCloningScreen> {
  final ElevenLabsVoiceService _voiceService = ElevenLabsVoiceService();
  File? _selectedAudioFile;
  String? _voiceName;
  bool _isProcessing = false;
  String? _errorMessage;
  String? _clonedVoiceId;
  Map<String, dynamic>? _validationResult;

  @override
  void initState() {
    super.initState();
    _checkServiceConfiguration();
  }

  void _checkServiceConfiguration() {
    if (!_voiceService.isConfigured) {
      setState(() {
        _errorMessage = 'ElevenLabs API Key nicht konfiguriert';
      });
    }
  }

  Future<void> _pickAudioFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowedExtensions: ['mp3', 'wav', 'm4a', 'ogg'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        setState(() {
          _selectedAudioFile = file;
          _errorMessage = null;
        });

        // Validiere Audio-Datei
        await _validateAudioFile(file);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Auswählen der Datei: $e';
      });
    }
  }

  Future<void> _validateAudioFile(File file) async {
    setState(() => _isProcessing = true);
    try {
      final result = await _voiceService.validateAudioSample(file.path);
      setState(() {
        _validationResult = result;
        _isProcessing = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Validierungsfehler: $e';
        _isProcessing = false;
      });
    }
  }

  Future<void> _cloneVoice() async {
    if (_selectedAudioFile == null || _voiceName == null || _voiceName!.isEmpty) {
      setState(() {
        _errorMessage = 'Bitte wähle eine Audio-Datei und gib einen Namen ein';
      });
      return;
    }

    if (_validationResult?['valid'] != true) {
      setState(() {
        _errorMessage = 'Audio-Datei ist nicht gültig';
      });
      return;
    }

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final voiceId = await _voiceService.cloneVoice(
        audioPath: _selectedAudioFile!.path,
        voiceName: _voiceName!,
        description: 'Therapist voice for therapy app',
      );

      setState(() {
        _clonedVoiceId = voiceId;
        _isProcessing = false;
      });

      // Speichere voiceId im ChildProfile
      await ref.read(childProfileProvider.notifier).updateVoiceId(voiceId);

      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Klonen der Stimme: $e';
        _isProcessing = false;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Erfolg! 🎉'),
        content: const Text(
          'Die Stimme wurde erfolgreich geklont. Du kannst jetzt mit der Therapie beginnen!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
            },
            child: const Text('Weiter'),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Stimme klonen'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Therapeuten-Stimme',
                style: KidsTypography.h1.copyWith(
                  color: KidsColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Lade eine Audio-Aufnahme hoch, um die Stimme des Therapeuten zu klonen',
                style: KidsTypography.bodyLarge.copyWith(
                  color: KidsColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              // Requirements
              _buildRequirementsCard(),
              const SizedBox(height: 24),

              // Voice Name Input
              Text(
                'Name der Stimme',
                style: KidsTypography.h3,
              ),
              const SizedBox(height: 16),
              TextField(
                onChanged: (value) => setState(() => _voiceName = value),
                decoration: InputDecoration(
                  hintText: 'z.B. "Therapeutin Maria"',
                  prefixIcon: const Icon(Icons.record_voice_over),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                style: KidsTypography.bodyLarge,
              ),
              const SizedBox(height: 24),

              // Audio File Picker
              _buildAudioFilePicker(),
              const SizedBox(height: 24),

              // Validation Result
              if (_validationResult != null) _buildValidationResult(),
              const SizedBox(height: 24),

              // Error Message
              if (_errorMessage != null) _buildErrorMessage(),
              const SizedBox(height: 24),

              // Clone Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (_isProcessing || _clonedVoiceId != null)
                      ? null
                      : _cloneVoice,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: KidsColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    disabledBackgroundColor: KidsColors.gray300,
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          _clonedVoiceId != null ? 'Stimme geklont ✓' : 'Stimme klonen',
                          style: KidsTypography.button.copyWith(
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              // Skip Button
              if (_clonedVoiceId == null)
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
                    },
                    child: Text(
                      'Überspringen',
                      style: KidsTypography.bodyLarge.copyWith(
                        color: KidsColors.textSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: KidsColors.infoLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: KidsColors.info),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, color: KidsColors.info),
              const SizedBox(width: 8),
              Text(
                'Anforderungen',
                style: KidsTypography.h3.copyWith(
                  color: KidsColors.info,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildRequirementItem(
            'Dauer: ${AppConstants.elevenLabsMinVoiceCloneDuration}-${AppConstants.elevenLabsMaxVoiceCloneDuration} Sekunden',
          ),
          _buildRequirementItem('Format: MP3, WAV, M4A, OGG'),
          _buildRequirementItem('Max. Größe: 25 MB'),
          _buildRequirementItem('Klare, deutliche Sprache'),
        ],
      ),
    );
  }

  Widget _buildRequirementItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, size: 16, color: KidsColors.info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: KidsTypography.bodyMedium.copyWith(
                color: KidsColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAudioFilePicker() {
    return GestureDetector(
      onTap: _pickAudioFile,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _selectedAudioFile != null
                ? KidsColors.primary
                : KidsColors.gray300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              _selectedAudioFile != null
                  ? Icons.audio_file
                  : Icons.cloud_upload_outlined,
              size: 48,
              color: _selectedAudioFile != null
                  ? KidsColors.primary
                  : KidsColors.gray400,
            ),
            const SizedBox(height: 16),
            Text(
              _selectedAudioFile != null
                  ? _selectedAudioFile!.path.split('/').last
                  : 'Audio-Datei auswählen',
              style: KidsTypography.bodyLarge.copyWith(
                color: _selectedAudioFile != null
                    ? KidsColors.primary
                    : KidsColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            if (_selectedAudioFile != null) ...[
              const SizedBox(height: 8),
              FutureBuilder<int>(
                future: _selectedAudioFile!.length(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      _formatFileSize(snapshot.data!),
                      style: KidsTypography.caption.copyWith(
                        color: KidsColors.textSecondary,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationResult() {
    final isValid = _validationResult?['valid'] == true;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isValid ? KidsColors.successLight : KidsColors.errorLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isValid ? KidsColors.success : KidsColors.error,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isValid ? Icons.check_circle : Icons.error,
                color: isValid ? KidsColors.success : KidsColors.error,
              ),
              const SizedBox(width: 8),
              Text(
                isValid ? 'Datei gültig' : 'Datei ungültig',
                style: KidsTypography.h3.copyWith(
                  color: isValid ? KidsColors.success : KidsColors.error,
                ),
              ),
            ],
          ),
          if (_validationResult?['sizeMB'] != null) ...[
            const SizedBox(height: 8),
            Text(
              'Größe: ${(_validationResult!['sizeMB'] as double).toStringAsFixed(2)} MB',
              style: KidsTypography.bodyMedium,
            ),
          ],
          if (_validationResult?['error'] != null) ...[
            const SizedBox(height: 8),
            Text(
              _validationResult!['error'] as String,
              style: KidsTypography.bodyMedium.copyWith(
                color: KidsColors.error,
              ),
            ),
          ],
        ],
      ),
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
}

