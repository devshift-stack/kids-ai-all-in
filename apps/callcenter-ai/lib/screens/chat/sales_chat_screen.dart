import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../core/theme/app_theme.dart';
import '../../models/chat_message.dart';
import '../../providers/backend_api_provider.dart';
import '../../providers/sales_agent_provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/premium_tts_provider.dart';
import '../../services/premium_tts_service.dart';
import '../dashboard/settings_screen.dart';

class SalesChatScreen extends ConsumerStatefulWidget {
  const SalesChatScreen({super.key});

  @override
  ConsumerState<SalesChatScreen> createState() => _SalesChatScreenState();
}

class _SalesChatScreenState extends ConsumerState<SalesChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  // Speech to Text
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechAvailable = false;
  String _currentWords = '';

  // Text to Speech (Premium)
  bool _isSpeaking = false;

  // Loading state
  bool _isLoading = false;
  
  // Backend-Modus oder direkter Service
  bool _useBackend = true;

  @override
  void initState() {
    super.initState();
    _initSpeech();
    _initPremiumTts();
    _greetCustomer();
  }

  Future<void> _initSpeech() async {
    _speechAvailable = await _speech.initialize(
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          setState(() => _isListening = false);
        }
      },
      onError: (error) {
        setState(() => _isListening = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Spracherkennung Fehler: ${error.errorMsg}')),
          );
        }
      },
    );
    setState(() {});
  }

  Future<void> _initPremiumTts() async {
    final ttsService = ref.read(premiumTtsServiceProvider);
    final currentLanguage = ref.read(languageProvider);
    
    await ttsService.setLanguage(currentLanguage);
    
    ttsService.setCompletionHandler(() {
      setState(() => _isSpeaking = false);
    });

    ttsService.setErrorHandler((msg) {
      setState(() => _isSpeaking = false);
      if (kDebugMode) {
        debugPrint('TTS Error: $msg');
      }
    });
  }

  void _greetCustomer() async {
    final currentLanguage = ref.read(languageProvider);
    final languageSettings = ref.read(languageProvider.notifier).settings;
    
    // Versuche Backend zu verwenden
    final backendApi = ref.read(backendApiServiceProvider);
    final isHealthy = await backendApi.checkHealth();
    
    if (isHealthy) {
      // Backend-Modus: Session erstellen mit aktueller Sprache
      setState(() {
        _useBackend = true;
        _isLoading = true;
      });
      
      final languageCode = currentLanguage.name; // 'german', 'bosnian', 'serbian'
      final session = await backendApi.createSession(language: languageCode);
      setState(() => _isLoading = false);
      
      if (session.success) {
        setState(() {
          _messages.add(ChatMessage.lisa(session.greeting));
        });
        _scrollToBottom();
        _speak(session.greeting);
        return;
      }
    }
    
    // Fallback: Direkter Service (wie im Plan vorgesehen)
    setState(() {
      _useBackend = false;
    });
    
    if (mounted && !isHealthy) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backend nicht verfügbar. Verwende direkten Service.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    
    // Lokale Begrüßung mit direktem Service (sprachabhängig)
    final greeting = languageSettings.greeting;
    setState(() {
      _messages.add(ChatMessage.lisa(greeting));
    });
    _scrollToBottom();
    _speak(greeting);
  }

  void _startListening() async {
    if (!_speechAvailable) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Spracherkennung nicht verfügbar')),
        );
      }
      return;
    }

    final ttsService = ref.read(premiumTtsServiceProvider);
    await ttsService.stop();
    setState(() => _isSpeaking = false);

    final currentLanguage = ref.read(languageProvider);

    setState(() {
      _isListening = true;
      _currentWords = '';
    });

    await _speech.listen(
      onResult: (result) {
        setState(() {
          _currentWords = result.recognizedWords;
          _textController.text = _currentWords;
        });

        if (result.finalResult && _currentWords.isNotEmpty) {
          _stopListening();
          _sendMessage(_currentWords);
        }
      },
      listenFor: const Duration(seconds: 10),
      pauseFor: const Duration(seconds: 3),
      localeId: currentLanguage.sttCode, // Sprachabhängige STT
      listenOptions: stt.SpeechListenOptions(
        partialResults: true,
      ),
    );
  }

  void _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _speak(String text) async {
    if (text.isEmpty) return;

    final ttsService = ref.read(premiumTtsServiceProvider);
    setState(() => _isSpeaking = true);
    await ttsService.speak(text);
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = text.trim();
    _textController.clear();

    setState(() {
      _messages.add(ChatMessage.user(userMessage));
      _isLoading = true;
    });

    _scrollToBottom();

    try {
      String response;
      
      if (_useBackend) {
        // Backend-Modus: Verwende Backend API
        final backendApi = ref.read(backendApiServiceProvider);
        final chatResponse = await backendApi.sendMessage(userMessage);
        
        if (!chatResponse.success) {
          // Fallback zu direktem Service bei Fehler
          setState(() => _useBackend = false);
          final salesAgent = ref.read(salesAgentServiceProvider);
          if (salesAgent.isConfigured) {
            response = await salesAgent.chat(userMessage);
          } else {
            response = 'Entschuldigung, der Service ist nicht konfiguriert. Bitte setzen Sie den GEMINI_API_KEY.';
          }
        } else {
          response = chatResponse.response;
        }
      } else {
        // Direkter Service-Modus (wie im Plan vorgesehen)
        final salesAgent = ref.read(salesAgentServiceProvider);
        if (!salesAgent.isConfigured) {
          response = 'Entschuldigung, der Service ist nicht konfiguriert. Bitte setzen Sie den GEMINI_API_KEY.';
        } else {
          response = await salesAgent.chat(userMessage);
        }
      }

      setState(() {
        _messages.add(ChatMessage.lisa(response));
        _isLoading = false;
      });

      _scrollToBottom();
      _speak(response);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error sending message: $e');
      }
      setState(() {
        _messages.add(ChatMessage.lisa(
          'Entschuldigung, es ist ein Fehler aufgetreten. Können Sie Ihre Frage bitte wiederholen?',
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    // Session beenden (nur wenn Backend verwendet wurde)
    if (_useBackend) {
      final backendApi = ref.read(backendApiServiceProvider);
      backendApi.endSession();
    }
    
    final ttsService = ref.read(premiumTtsServiceProvider);
    
    _textController.dispose();
    _scrollController.dispose();
    _speech.stop();
    ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: const Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.solar_power, color: Colors.white, size: 18),
            ),
            SizedBox(width: 12),
            Text('Lisa - Verkaufsberaterin'),
          ],
        ),
        actions: [
          // Einstellungen Button
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _isLoading
                  ? AppTheme.warningColor
                  : (_isListening
                      ? Colors.red
                      : AppTheme.successColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              _isLoading
                  ? 'Verarbeite...'
                  : (_isListening
                      ? 'Höre zu...'
                      : (_isSpeaking
                          ? 'Spricht...'
                          : 'Online')),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: _buildMessageList(),
          ),

          // Input area
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    if (_messages.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      itemCount: _messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isLoading) {
          return _buildTypingIndicator();
        }
        return _buildMessageBubble(_messages[index]);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) ...[
            // Lisa avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.solar_power,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSm),
          ],

          // Message bubble
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingMd,
                vertical: AppTheme.spacingSm + 4,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppTheme.primaryColor : AppTheme.surfaceColor,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(AppTheme.radiusLarge),
                  topRight: const Radius.circular(AppTheme.radiusLarge),
                  bottomLeft: Radius.circular(isUser ? AppTheme.radiusLarge : AppTheme.radiusSmall),
                  bottomRight: Radius.circular(isUser ? AppTheme.radiusSmall : AppTheme.radiusLarge),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  fontSize: 16,
                  color: isUser ? Colors.white : AppTheme.textPrimary,
                  height: 1.4,
                ),
              ),
            ),
          ),

          if (isUser) ...[
            const SizedBox(width: AppTheme.spacingSm),
            // User avatar
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.textSecondary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMd),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.solar_power,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: AppTheme.spacingSm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacingMd,
              vertical: AppTheme.spacingSm + 4,
            ),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDot(0),
                const SizedBox(width: 4),
                _buildDot(1),
                const SizedBox(width: 4),
                _buildDot(2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        final delay = index * 0.2;
        final animatedValue = ((value + delay) % 1.0) * 2 - 1;
        final scale = 1.0 + (animatedValue.abs() * 0.3);
        final opacity = 0.5 + (animatedValue.abs() * 0.5);

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Text input
            Expanded(
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(
                  hintText: _isListening
                      ? 'Ich höre zu...'
                      : 'Ihre Nachricht...',
                  hintStyle: TextStyle(color: AppTheme.textLight),
                  filled: true,
                  fillColor: AppTheme.backgroundColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                    vertical: AppTheme.spacingSm + 4,
                  ),
                ),
                onSubmitted: _sendMessage,
                enabled: !_isListening && !_isLoading,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),

            const SizedBox(width: AppTheme.spacingSm),

            // Microphone button
            GestureDetector(
              onTap: _isLoading
                  ? null
                  : (_isListening ? _stopListening : _startListening),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _isListening ? Colors.red : AppTheme.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isListening ? Colors.red : AppTheme.primaryColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isListening ? Icons.stop : Icons.mic,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),

            const SizedBox(width: AppTheme.spacingSm),

            // Send button
            GestureDetector(
              onTap: _isLoading || _textController.text.trim().isEmpty
                  ? null
                  : () => _sendMessage(_textController.text),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _textController.text.trim().isEmpty || _isLoading
                      ? AppTheme.textLight
                      : AppTheme.secondaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_textController.text.trim().isEmpty || _isLoading
                              ? AppTheme.textLight
                              : AppTheme.secondaryColor)
                          .withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.send,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

