enum MessageRole { user, assistant }

class ChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final rawRole = (json['role'] as String? ?? '').toLowerCase();
    return ChatMessage(
      text: json['text'] ?? json['response'] ?? json['message'] ?? '',
      role: rawRole == 'user' ? MessageRole.user : MessageRole.assistant,
      timestamp: DateTime.parse(
        json['timestamp'] ??
            json['createdAt'] ??
            DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'role': role == MessageRole.user ? 'user' : 'assistant',
    'timestamp': timestamp.toIso8601String(),
  };
}
