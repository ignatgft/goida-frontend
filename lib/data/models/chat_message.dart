import 'package:flutter/material.dart';

/// Модель сообщения мессенджера
class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String recipientId;
  final String content;
  final MessageType type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.recipientId,
    required this.content,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String? ?? '',
      conversationId: json['conversationId'] as String? ?? '',
      senderId: json['senderId'] as String? ?? '',
      recipientId: json['recipientId'] as String? ?? '',
      content: json['content'] as String? ?? '',
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.text,
      ),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      readAt: json['readAt'] != null ? DateTime.parse(json['readAt'] as String) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'conversationId': conversationId,
    'senderId': senderId,
    'recipientId': recipientId,
    'content': content,
    'type': type.name,
    'isRead': isRead,
    'createdAt': createdAt.toIso8601String(),
    'readAt': readAt?.toIso8601String(),
  };
}

/// Модель конверсации (чат)
class Conversation {
  final String id;
  final String user1Id;
  final String user2Id;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final int unreadCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Conversation({
    required this.id,
    required this.user1Id,
    required this.user2Id,
    required this.lastMessage,
    this.lastMessageAt,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String? ?? '',
      user1Id: json['user1Id'] as String? ?? '',
      user2Id: json['user2Id'] as String? ?? '',
      lastMessage: json['lastMessage'] as String? ?? '',
      lastMessageAt: json['lastMessageAt'] != null
          ? DateTime.parse(json['lastMessageAt'] as String)
          : null,
      unreadCount: json['unreadCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user1Id': user1Id,
    'user2Id': user2Id,
    'lastMessage': lastMessage,
    'lastMessageAt': lastMessageAt?.toIso8601String(),
    'unreadCount': unreadCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };
}

enum MessageType {
  text,
  image,
  file,
  system,
  transactionNotification,
  assetNotification,
}

extension MessageTypeX on MessageType {
  String get displayName => switch (this) {
    MessageType.text => 'Текст',
    MessageType.image => 'Изображение',
    MessageType.file => 'Файл',
    MessageType.system => 'Системное',
    MessageType.transactionNotification => 'Уведомление о транзакции',
    MessageType.assetNotification => 'Уведомление об активе',
  };

  IconData get icon => switch (this) {
    MessageType.text => Icons.chat_bubble_outline_rounded,
    MessageType.image => Icons.image_outlined,
    MessageType.file => Icons.insert_drive_file_outlined,
    MessageType.system => Icons.info_outline_rounded,
    MessageType.transactionNotification => Icons.receipt_long_rounded,
    MessageType.assetNotification => Icons.account_balance_wallet_outlined,
  };
}
