import 'package:flutter/material.dart';
import '../../core/api/api_client.dart';
import '../../core/api/endpoints.dart';
import '../../data/models/notification.dart';

/// Provider для управления уведомлениями
class NotificationProvider extends ChangeNotifier {
  final ApiClient api;
  final List<NotificationModel> _notifications = [];
  int _unreadCount = 0;
  bool _isLoading = false;

  NotificationProvider(this.api);

  List<NotificationModel> get notifications => _notifications;
  int get unreadCount => _unreadCount;
  bool get isLoading => _isLoading;

  /// Загрузить уведомления
  Future<void> loadNotifications({int limit = 20, int offset = 0}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await api.get(
        Endpoints.notifications,
        queryParameters: {'limit': limit, 'offset': offset},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final notificationsJson = data['notifications'] as List<dynamic>;
        
        _notifications.clear();
        _notifications.addAll(
          notificationsJson
              .whereType<Map<String, dynamic>>()
              .map(NotificationModel.fromJson)
              .toList(),
        );
        
        _unreadCount = data['unreadCount'] as int? ?? 0;
      }
    } catch (e) {
      debugPrint('Error loading notifications: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Загрузить непрочитанные уведомления
  Future<void> loadUnreadNotifications() async {
    try {
      final response = await api.get('${Endpoints.notifications}/unread');
      
      if (response.statusCode == 200) {
        final notificationsJson = response.data as List<dynamic>;
        final unread = notificationsJson
            .whereType<Map<String, dynamic>>()
            .map(NotificationModel.fromJson)
            .toList();
        
        // Обновляем только непрочитанные
        for (var notification in unread) {
          final index = _notifications.indexWhere((n) => n.id == notification.id);
          if (index != -1) {
            _notifications[index] = notification;
          } else {
            _notifications.insert(0, notification);
          }
        }
        
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading unread notifications: $e');
    }
  }

  /// Отметить уведомление как прочитанное
  Future<void> markAsRead(String notificationId) async {
    try {
      final response = await api.post(
        '${Endpoints.notifications}/$notificationId/read',
        {},
      );

      if (response.statusCode == 200) {
        final index = _notifications.indexWhere((n) => n.id == notificationId);
        if (index != -1) {
          final notification = _notifications[index];
          _notifications[index] = NotificationModel(
            id: notification.id,
            userId: notification.userId,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            isRead: true,
            createdAt: notification.createdAt,
            readAt: DateTime.now(),
          );
          _unreadCount = (_unreadCount - 1).clamp(0, _unreadCount);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  /// Отметить все уведомления как прочитанные
  Future<void> markAllAsRead() async {
    try {
      final response = await api.post(
        '${Endpoints.notifications}/read-all',
        {},
      );

      if (response.statusCode == 200) {
        for (var i = 0; i < _notifications.length; i++) {
          final notification = _notifications[i];
          _notifications[i] = NotificationModel(
            id: notification.id,
            userId: notification.userId,
            title: notification.title,
            message: notification.message,
            type: notification.type,
            isRead: true,
            createdAt: notification.createdAt,
            readAt: DateTime.now(),
          );
        }
        _unreadCount = 0;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  /// Удалить уведомление
  Future<void> deleteNotification(String notificationId) async {
    try {
      final response = await api.delete(
        '${Endpoints.notifications}/$notificationId',
      );

      if (response.statusCode == 204) {
        _notifications.removeWhere((n) => n.id == notificationId);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  /// Очистить все уведомления
  void clear() {
    _notifications.clear();
    _unreadCount = 0;
    notifyListeners();
  }
}
