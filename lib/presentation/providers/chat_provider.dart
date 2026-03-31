import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/chat_message.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient api;
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;
  Locale? _currentLocale;

  ChatProvider(this.api);

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  Locale? get currentLocale => _currentLocale;

  void setLocale(Locale? locale) {
    _currentLocale = locale;
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
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
        final botMessage = ChatMessage.fromJson(response.data);
        _messages.add(botMessage);
      }
    } catch (e) {
      _messages.add(
        ChatMessage(
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
