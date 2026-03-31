import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/reminder.dart';

/// Provider для управления напоминаниями
class ReminderProvider extends ChangeNotifier {
  final ApiClient api;
  final List<ReminderModel> _reminders = [];
  bool _isLoading = false;

  ReminderProvider(this.api);

  List<ReminderModel> get reminders => _reminders;
  bool get isLoading => _isLoading;

  /// Загрузить напоминания
  Future<void> loadReminders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.get(Endpoints.reminders);

      if (response.statusCode == 200) {
        final remindersJson = response.data as List<dynamic>;
        _reminders.clear();
        _reminders.addAll(
          remindersJson
              .whereType<Map<String, dynamic>>()
              .map(ReminderModel.fromJson)
              .toList(),
        );
      }
    } catch (e) {
      debugPrint('Error loading reminders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загрузить предстоящие напоминания
  Future<void> loadUpcomingReminders() async {
    try {
      final response = await api.get('${Endpoints.reminders}/upcoming');

      if (response.statusCode == 200) {
        final remindersJson = response.data as List<dynamic>;
        final upcoming = remindersJson
            .whereType<Map<String, dynamic>>()
            .map(ReminderModel.fromJson)
            .toList();
        
        debugPrint('Upcoming reminders: ${upcoming.length}');
      }
    } catch (e) {
      debugPrint('Error loading upcoming reminders: $e');
    }
  }

  /// Создать напоминание
  Future<bool> createReminder({
    required String title,
    String? description,
    required ReminderType type,
    required DateTime remindAt,
    bool isRecurring = false,
    String? recurrencePattern,
  }) async {
    try {
      final response = await api.post(
        Endpoints.reminders,
        {
          'title': title,
          'description': description,
          'type': type.name,
          'remindAt': remindAt.toIso8601String(),
          'isRecurring': isRecurring,
          'recurrencePattern': recurrencePattern,
        },
      );

      if (response.statusCode == 201) {
        await loadReminders();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error creating reminder: $e');
      return false;
    }
  }

  /// Завершить напоминание
  Future<bool> completeReminder(String reminderId) async {
    try {
      final response = await api.post(
        '${Endpoints.reminders}/$reminderId/complete',
        {},
      );

      if (response.statusCode == 200) {
        final index = _reminders.indexWhere((r) => r.id == reminderId);
        if (index != -1) {
          final reminder = _reminders[index];
          _reminders[index] = ReminderModel(
            id: reminder.id,
            userId: reminder.userId,
            title: reminder.title,
            description: reminder.description,
            type: reminder.type,
            remindAt: reminder.remindAt,
            isCompleted: true,
            isRecurring: reminder.isRecurring,
            recurrencePattern: reminder.recurrencePattern,
            createdAt: reminder.createdAt,
            updatedAt: DateTime.now(),
          );
          notifyListeners();
        }
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error completing reminder: $e');
      return false;
    }
  }

  /// Удалить напоминание
  Future<bool> deleteReminder(String reminderId) async {
    try {
      final response = await api.delete(
        '${Endpoints.reminders}/$reminderId',
      );

      if (response.statusCode == 204) {
        _reminders.removeWhere((r) => r.id == reminderId);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting reminder: $e');
      return false;
    }
  }

  /// Очистить напоминания
  void clear() {
    _reminders.clear();
    notifyListeners();
  }
}
