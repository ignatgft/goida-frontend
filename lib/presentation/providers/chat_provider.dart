import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';

/// Модель сообщения для AI чата
class AiChatMessage {
  final String text;
  final MessageRole role;
  final DateTime timestamp;
  final String? imageUrl;
  final Map<String, dynamic>? analysisResult;

  AiChatMessage({
    required this.text,
    required this.role,
    required this.timestamp,
    this.imageUrl,
    this.analysisResult,
  });

  factory AiChatMessage.fromJson(Map<String, dynamic> json) {
    return AiChatMessage(
      text: json['response'] as String? ?? json['content'] as String? ?? '',
      role: MessageRole.assistant,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'] as int)
          : DateTime.now(),
      imageUrl: json['imageUrl'] as String?,
      analysisResult: json['analysis'] as Map<String, dynamic>?,
    );
  }
}

/// Модель сессии чата
class ChatSession {
  final String id;
  final String title;
  final String? previewMessage;
  final String? sessionType;
  final DateTime createdAt;
  final DateTime updatedAt;

  ChatSession({
    required this.id,
    required this.title,
    this.previewMessage,
    this.sessionType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String? ?? 'New Chat',
      previewMessage: json['previewMessage'] as String?,
      sessionType: json['sessionType'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }
}

/// Результат анализа документа
class AiAnalysisResult {
  final String documentType;
  final double? amount;
  final String? date;
  final String? category;
  final String description;
  final bool shouldAddToSystem;

  AiAnalysisResult({
    required this.documentType,
    this.amount,
    this.date,
    this.category,
    required this.description,
    required this.shouldAddToSystem,
  });

  factory AiAnalysisResult.fromJson(Map<String, dynamic> json) {
    return AiAnalysisResult(
      documentType: json['documentType'] as String? ?? 'Unknown',
      amount: json['amount'] as double?,
      date: json['date'] as String?,
      category: json['category'] as String?,
      description: json['description'] as String? ?? '',
      shouldAddToSystem: json['shouldAddToSystem'] as bool? ?? false,
    );
  }
}

enum MessageRole { user, assistant }

class ChatProvider extends ChangeNotifier {
  final ApiClient api;
  final List<AiChatMessage> _messages = [];
  bool _isLoading = false;
  Locale? _currentLocale;
  String? _chatId;
  List<ChatSession> _sessions = [];
  ChatSession? _currentSession;

  ChatProvider(this.api);

  List<AiChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  Locale? get currentLocale => _currentLocale;
  String? get chatId => _chatId;
  List<ChatSession> get sessions => _sessions;
  ChatSession? get currentSession => _currentSession;

  void setLocale(Locale? locale) {
    _currentLocale = locale;
  }

  /// Загрузить список сессий AI чатов
  Future<void> loadSessions() async {
    try {
      final response = await api.get(Endpoints.chatSessionsAi);
      if (response.statusCode == 200) {
        _sessions = (response.data as List)
            .map((json) => ChatSession.fromJson(json as Map<String, dynamic>))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading chat sessions: $e');
    }
  }

  /// Создать новую AI сессию
  Future<ChatSession?> createSession(String? title) async {
    try {
      final response = await api.post(
        Endpoints.chatSessionsAi,
        title != null && title.isNotEmpty ? {'title': title} : {},
      );
      if (response.statusCode == 200) {
        final session = ChatSession.fromJson(response.data as Map<String, dynamic>);
        _sessions.insert(0, session);
        notifyListeners();
        return session;
      }
    } catch (e) {
      debugPrint('Error creating session: $e');
    }
    return null;
  }

  /// Выбрать текущую сессию
  void selectSession(ChatSession session) {
    _currentSession = session;
    _chatId = session.id;
    notifyListeners();
  }

  /// Удалить сессию
  Future<void> deleteSession(String sessionId) async {
    try {
      final response = await api.delete('${Endpoints.chatSessions}/$sessionId');
      if (response.statusCode == 200) {
        _sessions.removeWhere((s) => s.id == sessionId);
        if (_currentSession?.id == sessionId) {
          _currentSession = null;
          _chatId = null;
        }
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting session: $e');
    }
  }

  Future<void> sendMessage(
    String text, {
    String? context,
    List<File>? images,
  }) async {
    if (text.trim().isEmpty && (images == null || images.isEmpty)) return;

    // Add user message
    final userMessage = AiChatMessage(
      text: text,
      role: MessageRole.user,
      timestamp: DateTime.now(),
      imageUrl: images?.isNotEmpty == true ? images!.first.path : null,
    );
    _messages.add(userMessage);
    _isLoading = true;
    notifyListeners();

    try {
      final localeCode = _currentLocale?.languageCode ?? 'ru';
      
      if (images != null && images.isNotEmpty) {
        // Отправка с изображениями
        final files = <String, MultipartFile>{};
        
        for (int i = 0; i < images.length; i++) {
          final file = images[i];
          files['images'] = await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          );
        }
        
        final response = await api.postMultipart(
          Endpoints.chat,
          files: files,
          data: {
            'message': text,
            'locale': localeCode,
            if (context != null) 'contextWindow': context,
            if (_chatId != null) 'chatId': _chatId!,
          },
        );

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final botMessage = AiChatMessage.fromJson(data);
          _messages.add(botMessage);
          
          if (!_chatId!.contains(data['chatId'])) {
            _chatId = data['chatId'] as String;
          }
          
          // Если есть результат анализа, уведомляем слушателей
          if (data.containsKey('analysis')) {
            notifyListeners();
          }
        }
      } else {
        // Обычная отправка текста
        final response = await api.post(Endpoints.chat, {
          'message': text,
          'locale': localeCode,
          if (context != null) 'contextWindow': context,
          if (_chatId != null) 'chatId': _chatId!,
        });

        if (response.statusCode == 200) {
          final data = response.data as Map<String, dynamic>;
          final botMessage = AiChatMessage(
            text: data['response'] as String,
            role: MessageRole.assistant,
            timestamp: DateTime.fromMillisecondsSinceEpoch(
              data['timestamp'] as int,
            ),
          );
          _messages.add(botMessage);
          
          if (_chatId == null || !_chatId!.contains(data['chatId'])) {
            _chatId = data['chatId'] as String;
          }
        }
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
    _chatId = null;
    notifyListeners();
  }

  /// Получить последний результат анализа
  AiAnalysisResult? getLastAnalysisResult() {
    for (var i = _messages.length - 1; i >= 0; i--) {
      if (_messages[i].analysisResult != null) {
        return AiAnalysisResult.fromJson(_messages[i].analysisResult!);
      }
    }
    return null;
  }
}
