import 'package:flutter_test/flutter_test.dart';
import 'package:demo2/data/models/user.dart';

void main() {
  group('AppUser', () {
    test('создается из JSON с обязательными полями', () {
      final json = {
        'id': 'user_123',
        'displayName': 'John Doe',
        'email': 'john@example.com',
      };

      final user = AppUser.fromJson(json);

      expect(user.id, 'user_123');
      expect(user.displayName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.avatarUrl, isNull);
    });

    test('создается из JSON с avatarUrl', () {
      final json = {
        'id': 'user_456',
        'displayName': 'Jane Smith',
        'email': 'jane@example.com',
        'avatarUrl': 'https://example.com/avatar.jpg',
      };

      final user = AppUser.fromJson(json);

      expect(user.avatarUrl, 'https://example.com/avatar.jpg');
    });

    test('использует photoUrl как fallback для avatarUrl', () {
      final json = {
        'id': 'user_789',
        'displayName': 'Bob',
        'email': 'bob@example.com',
        'photoUrl': 'https://example.com/photo.jpg',
      };

      final user = AppUser.fromJson(json);

      expect(user.avatarUrl, 'https://example.com/photo.jpg');
    });

    test('использует значения по умолчанию для отсутствующих полей', () {
      final json = <String, dynamic>{};

      final user = AppUser.fromJson(json);

      expect(user.id, '');
      expect(user.displayName, 'User');
      expect(user.email, '');
    });

    test('обрабатывает name как fallback для displayName', () {
      final json = {
        'id': 'user_111',
        'name': 'Alice',
        'email': 'alice@example.com',
      };

      final user = AppUser.fromJson(json);

      expect(user.displayName, 'Alice');
    });

    test('обрабатывает fullName как fallback для displayName', () {
      final json = {
        'id': 'user_222',
        'fullName': 'Full Name',
        'email': 'full@example.com',
      };

      final user = AppUser.fromJson(json);

      expect(user.displayName, 'Full Name');
    });

    test('copyWith создает новую копию с измененными полями', () {
      final user = const AppUser(
        id: 'user_123',
        displayName: 'John',
        email: 'john@example.com',
        avatarUrl: null,
      );

      final updated = user.copyWith(
        displayName: 'John Updated',
        avatarUrl: 'https://example.com/new.jpg',
      );

      expect(updated.id, 'user_123'); // unchanged
      expect(updated.displayName, 'John Updated');
      expect(updated.avatarUrl, 'https://example.com/new.jpg');
    });

    test('toJson возвращает корректный JSON', () {
      final user = const AppUser(
        id: 'user_123',
        displayName: 'John Doe',
        email: 'john@example.com',
        avatarUrl: 'https://example.com/avatar.jpg',
      );

      final json = user.toJson();

      expect(json['id'], 'user_123');
      expect(json['displayName'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['avatarUrl'], 'https://example.com/avatar.jpg');
    });

    test('toJson не включает avatarUrl если он null', () {
      final user = const AppUser(
        id: 'user_123',
        displayName: 'John Doe',
        email: 'john@example.com',
      );

      final json = user.toJson();

      expect(json.containsKey('avatarUrl'), isFalse);
    });
  });
}
