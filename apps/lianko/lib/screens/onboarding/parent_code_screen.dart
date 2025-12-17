import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../services/parent_link_service.dart';

/// Screen zur Eingabe des Parent-Codes
/// Wird beim ersten Start angezeigt oder wenn nicht verknüpft
class ParentCodeScreen extends ConsumerStatefulWidget {
  final VoidCallback? onLinked;
  final VoidCallback? onSkipped;

  const ParentCodeScreen({
    super.key,
    this.onLinked,
    this.onSkipped,
  });

  @override
  ConsumerState<ParentCodeScreen> createState() => _ParentCodeScreenState();
}

class _ParentCodeScreenState extends ConsumerState<ParentCodeScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  String? _errorMessage;
  bool _showSuccess = false;
  String? _linkedChildName;

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _fullCode => _controllers.map((c) => c.text).join();

  Future<void> _submitCode() async {
    final code = _fullCode;
    if (code.length != 6) {
      setState(() => _errorMessage = 'Bitte gib alle 6 Zeichen ein');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final service = ref.read(parentLinkServiceProvider);
    final result = await service.linkWithParentCode(code);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (result.isSuccess) {
      setState(() {
        _showSuccess = true;
        _linkedChildName = result.childName;
      });

      // Kurz warten, dann weiter
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        widget.onLinked?.call();
      }
    } else {
      setState(() {
        _errorMessage = result.errorMessage;
      });
      // Felder leeren bei Fehler
      for (var c in _controllers) {
        c.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  void _onCodeChanged(int index, String value) {
    if (value.isNotEmpty) {
      // Zum nächsten Feld springen
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        // Letztes Feld - automatisch absenden
        _focusNodes[index].unfocus();
        _submitCode();
      }
    }
  }

  void _onKeyPressed(int index, RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.backspace) {
        if (_controllers[index].text.isEmpty && index > 0) {
          _focusNodes[index - 1].requestFocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showSuccess) {
      return _buildSuccessScreen();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const Spacer(),

              // Lianko Maskottchen
              _buildMascot()
                  .animate()
                  .fadeIn(duration: 600.ms)
                  .slideY(begin: -0.2, end: 0),

              const SizedBox(height: 32),

              // Titel
              Text(
                'Hallo! 👋',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B4EE6),
                    ),
              )
                  .animate()
                  .fadeIn(delay: 200.ms, duration: 600.ms),

              const SizedBox(height: 12),

              // Beschreibung
              Text(
                'Frag Mama oder Papa nach dem Code',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fadeIn(delay: 400.ms, duration: 600.ms),

              const SizedBox(height: 40),

              // Code-Eingabe
              _buildCodeInput()
                  .animate()
                  .fadeIn(delay: 600.ms, duration: 600.ms)
                  .slideY(begin: 0.2, end: 0),

              // Fehlermeldung
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                )
                    .animate()
                    .fadeIn(duration: 300.ms)
                    .shake(hz: 4, curve: Curves.easeInOut),
              ],

              const SizedBox(height: 32),

              // Verbinden Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6B4EE6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                          ),
                        )
                      : const Text(
                          'Verbinden',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              )
                  .animate()
                  .fadeIn(delay: 800.ms, duration: 600.ms),

              const Spacer(),

              // Überspringen Option
              if (widget.onSkipped != null)
                TextButton(
                  onPressed: widget.onSkipped,
                  child: Text(
                    'Später verbinden',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 1000.ms, duration: 600.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMascot() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xFF6B4EE6).withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text(
          '🦁',
          style: TextStyle(fontSize: 64),
        ),
      ),
    );
  }

  Widget _buildCodeInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(6, (index) {
        return Container(
          width: 48,
          height: 64,
          margin: EdgeInsets.only(
            left: index == 0 ? 0 : 8,
            right: index == 2 ? 16 : 0, // Lücke nach 3. Zeichen
          ),
          child: RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (event) => _onKeyPressed(index, event),
            child: TextField(
              controller: _controllers[index],
              focusNode: _focusNodes[index],
              textAlign: TextAlign.center,
              maxLength: 1,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B4EE6),
              ),
              decoration: InputDecoration(
                counterText: '',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color(0xFF6B4EE6),
                    width: 2,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              textCapitalization: TextCapitalization.characters,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9]')),
                UpperCaseTextFormatter(),
              ],
              onChanged: (value) => _onCodeChanged(index, value),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSuccessScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Color(0xFF4CAF50),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 64,
              ),
            )
                .animate()
                .scale(begin: const Offset(0.5, 0.5), end: const Offset(1, 1))
                .fadeIn(),

            const SizedBox(height: 32),

            Text(
              'Verbunden! 🎉',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2E7D32),
                  ),
            )
                .animate()
                .fadeIn(delay: 300.ms),

            if (_linkedChildName != null) ...[
              const SizedBox(height: 8),
              Text(
                'Hallo $_linkedChildName!',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[700],
                    ),
              )
                  .animate()
                  .fadeIn(delay: 500.ms),
            ],
          ],
        ),
      ),
    );
  }
}

/// Formatter für Großbuchstaben
class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
