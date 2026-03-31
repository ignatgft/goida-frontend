import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';

/// Модель сообщения для AI чата
class AiChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;

  AiChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
  });

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      text: json['content'] as String? ?? '',
      role: MessageRole.values.firstWhere(
        (r) => r.name == json['role'],
        orElse: () => MessageRole.assistant,
      ),
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

enum MessageRole { user, assistant }

class ChatProvider extends ChangeNotifier {
  final ApiClient api;
  final List<AiChatMessage> _messages = [];
  bool _isLoading = false;
  Locale? _currentLocale;

  ChatProvider(this.api);

  List<AiChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  Locale? get currentLocale => _currentLocale;

  void setLocale(Locale? locale) {
    _currentLocale = locale;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = AiChatMessage(
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      // Send locale with message
      final localeCode = _currentLocale?.languageCode ?? 'ru';
      final response = await api.post(Endpoints.chat, {
        'message': text,
        'locale': localeCode,
      });

      if (response.statusCode == 200) {
        final botMessage = AiChatMessage.fromJson(response.data);
        _messages.add(botMessage);
      }
    } catch (e) {
      _messages.add(
        AiChatMessage(
          text: "Error: Could not connect to AI server.",
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        ),
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
