import 'package:flutter_test/flutter_test.dart';
import 'package:jenga_app/models/user.dart';

void main() {
  group('Authentication Tests', () {
    test('User model should be created correctly', () {
      final user = User(
        id: '1',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+1234567890',
        isActive: true,
      );

      expect(user.id, '1');
      expect(user.fullName, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.phoneNumber, '+1234567890');
      expect(user.isActive, true);
    });

    test('User model should convert to JSON correctly', () {
      final user = User(
        id: '1',
        fullName: 'Test User',
        email: 'test@example.com',
        phoneNumber: '+1234567890',
        isActive: true,
      );

      final json = user.toJson();
      expect(json['id'], '1');
      expect(json['fullName'], 'Test User');
      expect(json['email'], 'test@example.com');
      expect(json['phoneNumber'], '+1234567890');
      expect(json['isActive'], true);
    });

    test('User model should create from JSON correctly', () {
      final json = {
        'id': '1',
        'fullName': 'Test User',
        'email': 'test@example.com',
        'phoneNumber': '+1234567890',
        'isActive': true,
      };

      final user = User.fromJson(json);
      expect(user.id, '1');
      expect(user.fullName, 'Test User');
      expect(user.email, 'test@example.com');
      expect(user.phoneNumber, '+1234567890');
      expect(user.isActive, true);
    });
  });
}
