import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import '../../core/theme/app_theme.dart';
import '../../services/avatar_service.dart';

/// Avatar Upload Screen
class AvatarUploadScreen extends StatefulWidget {
  const AvatarUploadScreen({super.key});

  @override
  State<AvatarUploadScreen> createState() => _AvatarUploadScreenState();
}

class _AvatarUploadScreenState extends State<AvatarUploadScreen> {
  final List<File> _uploadedImages = [];
  bool _isUploading = false;
  bool _isGenerating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Avatar-Konfiguration'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Avatar erstellen',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Lade 6-10 Bilder hoch, um einen personalisierten Avatar zu erstellen.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),

                // Upload-Bereich
                _buildUploadArea(),

                const SizedBox(height: 32),

                // Hochgeladene Bilder
                if (_uploadedImages.isNotEmpty) _buildImageGrid(),

                const SizedBox(height: 32),

                // Generieren-Button
                if (_uploadedImages.length >= 6)
                  _buildGenerateButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadArea() {
    return Card(
      child: InkWell(
        onTap: _pickImages,
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(
              color: AppTheme.primaryColor,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: _isUploading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.cloud_upload,
                      size: 64,
                      color: AppTheme.primaryColor,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bilder hochladen (6-10 Bilder)',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Klicke hier oder ziehe Bilder hierher',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildImageGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hochgeladene Bilder (${_uploadedImages.length}/10)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _uploadedImages.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _uploadedImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      setState(() {
                        _uploadedImages.removeAt(index);
                      });
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildGenerateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isGenerating ? null : _generateAvatar,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primaryColor,
        ),
        child: _isGenerating
            ? const CircularProgressIndicator(color: Colors.white)
            : const Text(
                'Avatar generieren',
                style: TextStyle(fontSize: 18),
              ),
      ),
    );
  }

  Future<void> _pickImages() async {
    try {
      setState(() => _isUploading = true);

      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final files = result.files
            .where((file) => file.path != null)
            .map((file) => File(file.path!))
            .toList();

        setState(() {
          _uploadedImages.addAll(files);
          if (_uploadedImages.length > 10) {
            _uploadedImages.removeRange(10, _uploadedImages.length);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Hochladen: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  Future<void> _generateAvatar() async {
    if (_uploadedImages.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bitte lade mindestens 6 Bilder hoch'),
        ),
      );
      return;
    }

    setState(() => _isGenerating = true);

    try {
      // TODO: Implementiere Avatar-Generierung
      final avatarService = AvatarService();
      await avatarService.generateAvatar(_uploadedImages);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Avatar wurde erfolgreich generiert!'),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler bei Avatar-Generierung: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }
}

