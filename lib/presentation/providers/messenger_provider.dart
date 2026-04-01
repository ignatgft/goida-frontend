import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/chat_message.dart' as messenger;

/// Provider для мессенджера
class MessengerProvider extends ChangeNotifier {
  final ApiClient api;
  
  List<messenger.Conversation> _conversations = [];
  Map<String, List<messenger.ChatMessage>> _messages = {};
  bool _isLoading = false;
  WebSocketChannel? _channel;
  bool _isConnected = false;

  MessengerProvider(this.api);

  List<messenger.Conversation> get conversations => _conversations;
  Map<String, List<messenger.ChatMessage>> get messages => _messages;
  bool get isLoading => _isLoading;
  bool get isConnected => _isConnected;

  /// Загрузить список диалогов
  Future<void> loadConversations() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.get(Endpoints.conversations);
      if (response.statusCode == 200) {
        final data = response.data as List;
        _conversations = data
            .map((json) => messenger.Conversation.fromJson(json as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading conversations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загрузить сообщения диалога
  Future<void> loadMessages(String userId, {int page = 0, int size = 20}) async {
    try {
      final response = await api.get(
        '${Endpoints.messages}/conversation/$userId',
        queryParameters: {'page': page, 'size': size},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final content = data['content'] as List;
        final messagesList = content
            .map((json) => messenger.ChatMessage.fromJson(json as Map<String, dynamic>))
            .toList();
        _messages[userId] = messagesList;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  /// Отправить сообщение
  Future<bool> sendMessage(String receiverId, String content, {File? file, String type = 'TEXT'}) async {
    try {
      late final Response response;
      
      if (file != null) {
        response = await api.postMultipart(
          Endpoints.messages,
          data: {
            'receiverId': receiverId,
            'type': type,
          },
          files: {
            'file': await MultipartFile.fromFile(file.path),
          },
        );
      } else {
        response = await api.post(
          Endpoints.messages,
          {
            'receiverId': receiverId,
            'content': content,
            'type': type,
          },
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Обновить список сообщений
        await loadMessages(receiverId);
        await loadConversations();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  /// Отметить сообщения как прочитанные
  Future<void> markAsRead(String userId) async {
    try {
      await api.post('${Endpoints.messages}/read/$userId', {});
      // Обновить локальный статус
      if (_messages.containsKey(userId)) {
        _messages[userId] = _messages[userId]!
            .map((m) => messenger.ChatMessage(
                  id: m.id,
                  senderId: m.senderId,
                  senderName: m.senderName,
                  receiverId: m.receiverId,
                  receiverName: m.receiverName,
                  content: m.content,
                  type: m.type,
                  fileUrl: m.fileUrl,
                  fileName: m.fileName,
                  fileContentType: m.fileContentType,
                  isRead: true,
                  sentAt: m.sentAt,
                ))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking messages as read: $e');
    }
  }

  /// Подключиться к WebSocket
  Future<void> connectWebSocket(String token) async {
    try {
      final wsUrl = Endpoints.baseUrl.replaceFirst('http', 'ws') + '/ws';
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      _isConnected = true;
      notifyListeners();

      // Слушать входящие сообщения
      _channel!.stream.listen((message) {
        // Обработка WebSocket сообщений
        debugPrint('WebSocket message: $message');
      }, onError: (error) {
        debugPrint('WebSocket error: $error');
        _isConnected = false;
        notifyListeners();
      });
    } catch (e) {
      debugPrint('Error connecting to WebSocket: $e');
      _isConnected = false;
      notifyListeners();
    }
  }

  /// Отключиться от WebSocket
  void disconnectWebSocket() {
    _channel?.sink.close();
    _channel = null;
    _isConnected = false;
    notifyListeners();
  }

  /// Очистить данные
  void clear() {
    _conversations = [];
    _messages = {};
    disconnectWebSocket();
    notifyListeners();
  }
}
