import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kids_ai_shared/kids_ai_shared.dart';
import '../../../models/child_profile.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../providers/child_profile_provider.dart';

class ChildProfileScreen extends ConsumerStatefulWidget {
  const ChildProfileScreen({super.key});

  @override
  ConsumerState<ChildProfileScreen> createState() => _ChildProfileScreenState();
}

class _ChildProfileScreenState extends ConsumerState<ChildProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  int _age = 5;
  String _selectedLanguage = AppConstants.defaultLanguage;
  double _leftEarLoss = 0.0;
  double _rightEarLoss = 0.0;
  int _currentStep = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _nameController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    } else {
      _saveProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      final profile = ChildProfile(
        id: const Uuid().v4(),
        name: _nameController.text.trim(),
        age: _age,
        language: _selectedLanguage,
        leftEarLossPercent: _leftEarLoss,
        rightEarLossPercent: _rightEarLoss,
        createdAt: DateTime.now(),
      );

      // Speichere Profil
      await ref.read(childProfileProvider.notifier).saveProfile(profile);

      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.voiceCloning);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Fehler beim Speichern: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KidsColors.backgroundLight,
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Progress Indicator
              _buildProgressIndicator(),
              
              // Content
              Expanded(
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildStep1(),
                    _buildStep2(),
                    _buildStep3(),
                  ],
                ),
              ),

              // Navigation Buttons
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(3, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive
                    ? KidsColors.primary
                    : KidsColors.gray300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStep1() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hallo! 👋',
            style: KidsTypography.h1.copyWith(
              color: KidsColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lass uns gemeinsam dein Profil erstellen',
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          
          // Name Input
          Text(
            'Wie heißt du?',
            style: KidsTypography.h3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              hintText: 'Dein Name',
              prefixIcon: const Icon(Icons.person_outline),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            style: KidsTypography.bodyLarge,
            textCapitalization: TextCapitalization.words,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Bitte gib deinen Namen ein';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Age Selector
          Text(
            'Wie alt bist du?',
            style: KidsTypography.h3,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildAgeButton(_age - 1, _age > 3),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: KidsColors.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '$_age',
                      style: KidsTypography.h1.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildAgeButton(_age + 1, _age < 12),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Language Selector
          Text(
            'Welche Sprache sprichst du?',
            style: KidsTypography.h3,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: AppConstants.supportedLanguages.map((lang) {
              final isSelected = _selectedLanguage == lang;
              return ChoiceChip(
                label: Text(_getLanguageName(lang)),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() => _selectedLanguage = lang);
                },
                selectedColor: KidsColors.primary,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : KidsColors.textPrimary,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeButton(int age, bool enabled) {
    return GestureDetector(
      onTap: enabled
          ? () {
              setState(() => _age = age);
            }
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: enabled ? KidsColors.gray100 : KidsColors.gray200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          age < _age ? Icons.remove : Icons.add,
          color: enabled ? KidsColors.primary : KidsColors.gray400,
        ),
      ),
    );
  }

  String _getLanguageName(String code) {
    const names = {
      'bs': 'Bosanski',
      'en': 'English',
      'hr': 'Hrvatski',
      'sr': 'Srpski',
      'de': 'Deutsch',
      'tr': 'Türkçe',
    };
    return names[code] ?? code;
  }

  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hörverlust',
            style: KidsTypography.h1.copyWith(
              color: KidsColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte gib an, wie viel Prozent Hörverlust du in jedem Ohr hast',
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          // Left Ear
          _buildEarSelector(
            'Linkes Ohr 👂',
            _leftEarLoss,
            (value) => setState(() => _leftEarLoss = value),
          ),
          const SizedBox(height: 32),

          // Right Ear
          _buildEarSelector(
            'Rechtes Ohr 👂',
            _rightEarLoss,
            (value) => setState(() => _rightEarLoss = value),
          ),
        ],
      ),
    );
  }

  Widget _buildEarSelector(String label, double value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: KidsTypography.h3,
        ),
        const SizedBox(height: 16),
        Container(
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
          child: Column(
            children: [
              Text(
                '${value.toInt()}%',
                style: KidsTypography.h1.copyWith(
                  color: KidsColors.primary,
                ),
              ),
              const SizedBox(height: 16),
              Slider(
                value: value,
                min: 0,
                max: 100,
                divisions: 20,
                label: '${value.toInt()}%',
                onChanged: onChanged,
                activeColor: KidsColors.primary,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0%', style: KidsTypography.caption),
                  Text('100%', style: KidsTypography.caption),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    final profile = ChildProfile(
      id: const Uuid().v4(),
      name: _nameController.text.trim(),
      age: _age,
      language: _selectedLanguage,
      leftEarLossPercent: _leftEarLoss,
      rightEarLossPercent: _rightEarLoss,
      createdAt: DateTime.now(),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Zusammenfassung',
            style: KidsTypography.h1.copyWith(
              color: KidsColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Bitte überprüfe deine Angaben',
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),

          _buildSummaryCard('Name', profile.name),
          const SizedBox(height: 16),
          _buildSummaryCard('Alter', '${profile.age} Jahre'),
          const SizedBox(height: 16),
          _buildSummaryCard('Sprache', _getLanguageName(profile.language)),
          const SizedBox(height: 16),
          _buildSummaryCard('Linkes Ohr', '${profile.leftEarLossPercent.toInt()}%'),
          const SizedBox(height: 16),
          _buildSummaryCard('Rechtes Ohr', '${profile.rightEarLossPercent.toInt()}%'),
          const SizedBox(height: 16),
          _buildSummaryCard(
            'Hörverlust',
            _getSeverityText(profile.hearingLossSeverity),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String label, String value) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: KidsTypography.bodyLarge.copyWith(
              color: KidsColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getSeverityText(HearingLossSeverity severity) {
    const texts = {
      HearingLossSeverity.normal: 'Normal',
      HearingLossSeverity.mild: 'Leicht',
      HearingLossSeverity.moderate: 'Mittel',
      HearingLossSeverity.severe: 'Schwer',
      HearingLossSeverity.profound: 'Sehr schwer',
    };
    return texts[severity] ?? 'Unbekannt';
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  'Zurück',
                  style: KidsTypography.labelLarge,
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 16),
          Expanded(
            flex: _currentStep == 0 ? 1 : 1,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: KidsColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                _currentStep == 2 ? 'Speichern' : 'Weiter',
                style: KidsTypography.labelLarge.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

