import 'package:flutter/material.dart';

/// Модель напоминания
class ReminderModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final ReminderType type;
  final DateTime remindAt;
  final bool isCompleted;
  final bool isRecurring;
  final String? recurrencePattern;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ReminderModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.type,
    required this.remindAt,
    required this.isCompleted,
    required this.isRecurring,
    this.recurrencePattern,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      type: ReminderType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ReminderType.custom,
      ),
      remindAt: json['remindAt'] != null
          ? DateTime.parse(json['remindAt'] as String)
          : DateTime.now(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrencePattern: json['recurrencePattern'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'description': description,
        'type': type.name,
        'remindAt': remindAt.toIso8601String(),
        'isCompleted': isCompleted,
        'isRecurring': isRecurring,
        'recurrencePattern': recurrencePattern,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}

enum ReminderType {
  transaction,
  bill,
  custom,
  system,
}

extension ReminderTypeX on ReminderType {
  String get displayName => switch (this) {
        ReminderType.transaction => 'Транзакция',
        ReminderType.bill => 'Счет',
        ReminderType.custom => 'Пользовательское',
        ReminderType.system => 'Системное',
      };

  IconData get icon => switch (this) {
        ReminderType.transaction => Icons.swap_horiz_rounded,
        ReminderType.bill => Icons.receipt_rounded,
        ReminderType.custom => Icons.edit_note_rounded,
        ReminderType.system => Icons.settings_rounded,
      };
}
