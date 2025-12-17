/// Chat Message Model
/// Repräsentiert eine einzelne Nachricht im Chat
class ChatMessage {
  final String text;
  final bool isUser; // true = Kunde, false = Lisa
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  /// Erstellt eine User-Nachricht
  factory ChatMessage.user(String text) {
    return ChatMessage(
      text: text,
      isUser: true,
    );
  }

  /// Erstellt eine Lisa-Nachricht
  factory ChatMessage.lisa(String text) {
    return ChatMessage(
      text: text,
      isUser: false,
    );
  }

  @override
  String toString() => 'ChatMessage(isUser: $isUser, text: ${text.substring(0, text.length > 50 ? 50 : text.length)}...)';
}

