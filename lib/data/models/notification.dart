import 'package:flutter/material.dart';

/// Модель уведомления
class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String message;
  final NotificationType type;
  final bool isRead;
  final DateTime createdAt;
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.message,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.system,
      ),
      isRead: json['isRead'] as bool? ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      readAt: json['readAt'] != null
          ? DateTime.parse(json['readAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'message': message,
        'type': type.name,
        'isRead': isRead,
        'createdAt': createdAt.toIso8601String(),
        'readAt': readAt?.toIso8601String(),
      };
}

enum NotificationType {
  transaction,
  asset,
  reminder,
  system,
  message,
}

extension NotificationTypeX on NotificationType {
  String get displayName => switch (this) {
        NotificationType.transaction => 'Транзакция',
        NotificationType.asset => 'Актив',
        NotificationType.reminder => 'Напоминание',
        NotificationType.system => 'Системное',
        NotificationType.message => 'Сообщение',
      };

  IconData get icon => switch (this) {
        NotificationType.transaction => Icons.receipt_long_rounded,
        NotificationType.asset => Icons.account_balance_wallet_rounded,
        NotificationType.reminder => Icons.notifications_active_rounded,
        NotificationType.system => Icons.info_outline_rounded,
        NotificationType.message => Icons.chat_bubble_outline_rounded,
      };

  Color get color => switch (this) {
        NotificationType.transaction => Colors.blue,
        NotificationType.asset => Colors.green,
        NotificationType.reminder => Colors.orange,
        NotificationType.system => Colors.grey,
        NotificationType.message => Colors.purple,
      };
}
