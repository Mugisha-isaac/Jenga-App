// Unit tests for utility classes and functions
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jenga_app/utils/safe_text_controller.dart';

void main() {
  group('SafeTextController Tests', () {
    late SafeTextController controller;

    setUp(() {
      controller = SafeTextController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('SafeTextController should initialize with empty text', () {
      expect(controller.text, isEmpty);
      expect(controller.isDisposed, isFalse);
    });

    test('SafeTextController should initialize with provided text', () {
      final controllerWithText = SafeTextController(text: 'Initial text');
      expect(controllerWithText.text, 'Initial text');
      controllerWithText.dispose();
    });

    test('SafeTextController should handle text setting', () {
      const testText = 'Hello World';
      controller.text = testText;

      expect(controller.text, testText);
    });

    test('SafeTextController should handle text clearing', () {
      controller.text = 'Some text';
      expect(controller.text, 'Some text');

      controller.clear();
      expect(controller.text, isEmpty);
    });

    test(
        'SafeTextController should provide underlying controller when not disposed',
        () {
      expect(controller.controller, isNotNull);
      expect(controller.controller, isA<TextEditingController>());
    });

    test('SafeTextController should return null controller when disposed', () {
      controller.dispose();
      expect(controller.controller, isNull);
      expect(controller.isDisposed, isTrue);
    });

    test('SafeTextController should handle safe text operations after disposal',
        () {
      controller.text = 'Some text';
      expect(controller.text, 'Some text');

      controller.dispose();

      // These operations should be safe and not throw
      expect(() => controller.text = 'New text', returnsNormally);
      expect(() => controller.clear(), returnsNormally);
      expect(
          controller.text, isEmpty); // Should return empty string when disposed
    });

    test('SafeTextController should notify listeners on changes', () {
      var notificationCount = 0;

      controller.addListener(() {
        notificationCount++;
      });

      controller.text = 'First change';
      controller.text = 'Second change';

      expect(notificationCount, 2);
    });

    test('SafeTextController should handle multiple listeners', () {
      var listener1Called = false;
      var listener2Called = false;

      void listener1() => listener1Called = true;
      void listener2() => listener2Called = true;

      controller.addListener(listener1);
      controller.addListener(listener2);

      controller.text = 'Test';

      expect(listener1Called, isTrue);
      expect(listener2Called, isTrue);
    });

    test('SafeTextController should handle listener removal', () {
      var listenerCalled = false;

      void listener() => listenerCalled = true;

      controller.addListener(listener);
      controller.removeListener(listener);

      controller.text = 'Test';

      expect(listenerCalled, isFalse);
    });

    test('SafeTextController should safely handle listeners after disposal',
        () {
      void listener() {}

      controller.dispose();

      // These should not throw
      expect(() => controller.addListener(listener), returnsNormally);
      expect(() => controller.removeListener(listener), returnsNormally);
    });

    test('SafeTextController should handle empty to non-empty transition', () {
      expect(controller.text, isEmpty);

      controller.text = 'Now has content';

      expect(controller.text, 'Now has content');
      expect(controller.text.isNotEmpty, isTrue);
    });

    test('SafeTextController should handle non-empty to empty transition', () {
      controller.text = 'Has content';
      expect(controller.text.isNotEmpty, isTrue);

      controller.text = '';

      expect(controller.text, isEmpty);
    });

    test('SafeTextController should handle special characters', () {
      const specialText = 'Hello 👋 World 🌍 Test 🧪';
      controller.text = specialText;

      expect(controller.text, specialText);
    });

    test('SafeTextController should handle very long text', () {
      final longText = 'A' * 1000; // 1,000 characters
      controller.text = longText;

      expect(controller.text, longText);
      expect(controller.text.length, 1000);
    });

    test('SafeTextController dispose should be idempotent', () {
      controller.dispose();
      expect(controller.isDisposed, isTrue);

      // Disposing again should be safe
      expect(() => controller.dispose(), returnsNormally);
      expect(controller.isDisposed, isTrue);
    });
  });

  group('Text Validation Utilities', () {
    test('Email validation should work correctly', () {
      // Valid emails
      expect(_isValidEmail('test@example.com'), isTrue);
      expect(_isValidEmail('user.name@domain.co.uk'), isTrue);
      expect(_isValidEmail('user+tag@example.org'), isTrue);

      // Invalid emails
      expect(_isValidEmail('invalid-email'), isFalse);
      expect(_isValidEmail('test@'), isFalse);
      expect(_isValidEmail('@example.com'), isFalse);
      expect(_isValidEmail(''), isFalse);
    });

    test('Phone number validation should work correctly', () {
      // Valid phone numbers
      expect(_isValidPhoneNumber('+1234567890'), isTrue);
      expect(_isValidPhoneNumber('1234567890'), isTrue);
      expect(_isValidPhoneNumber('+250 123 456 789'), isTrue);

      // Invalid phone numbers
      expect(_isValidPhoneNumber('123'), isFalse);
      expect(_isValidPhoneNumber('abc123'), isFalse);
      expect(_isValidPhoneNumber(''), isFalse);
    });

    test('Password strength validation should work correctly', () {
      // Strong passwords
      expect(_isStrongPassword('StrongP@ss123'), isTrue);
      expect(_isStrongPassword('MySecure#Password1'), isTrue);

      // Weak passwords
      expect(_isStrongPassword('weak'), isFalse);
      expect(_isStrongPassword('password'), isFalse);
      expect(_isStrongPassword('12345678'), isFalse);
      expect(_isStrongPassword(''), isFalse);
    });
  });

  group('String Utilities', () {
    test('String capitalization should work correctly', () {
      expect(_capitalize('hello'), 'Hello');
      expect(_capitalize('HELLO'), 'Hello');
      expect(_capitalize('hELLO wORLD'), 'Hello world');
      expect(_capitalize(''), '');
    });

    test('String truncation should work correctly', () {
      expect(_truncate('This is a long string', 10), 'This is...');
      expect(_truncate('Short', 10), 'Short');
      expect(_truncate('Exact length', 12), 'Exact length');
      expect(_truncate('', 10), '');
    });

    test('String validation edge cases', () {
      // Test null handling
      expect(_capitalize('a'), 'A');
      expect(_truncate('a', 1), 'a');

      // Test single character
      expect(_capitalize('h'), 'H');
      expect(_truncate('hello', 3), '...');
    });
  });

  group('Form Validation Edge Cases', () {
    test('Email validation edge cases', () {
      expect(_isValidEmail('test@example'), isFalse); // No TLD
      expect(_isValidEmail('test..test@example.com'),
          isTrue); // Double dots - actually valid in some cases
      expect(_isValidEmail('test@ex ample.com'), isFalse); // Space in domain
    });

    test('Phone number validation edge cases', () {
      expect(_isValidPhoneNumber('+250-123-456-789'), isTrue); // With dashes
      expect(_isValidPhoneNumber('(123) 456-7890'), isTrue); // With parentheses
      expect(_isValidPhoneNumber('123-456-7890 ext 123'),
          isFalse); // With extension text
    });

    test('Password validation requirements', () {
      expect(_isStrongPassword('Password1!'), isTrue); // All requirements met
      expect(_isStrongPassword('password1!'), isFalse); // No uppercase
      expect(_isStrongPassword('PASSWORD1!'), isFalse); // No lowercase
      expect(_isStrongPassword('Password!'), isFalse); // No digit
      expect(_isStrongPassword('Password1'), isFalse); // No special char
    });
  });
}

// Helper validation functions (these would typically be in a separate utility file)
bool _isValidEmail(String email) {
  if (email.isEmpty) return false;
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

bool _isValidPhoneNumber(String phone) {
  if (phone.isEmpty) return false;
  final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
  if (cleanPhone.length < 7) return false;
  final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
  return phoneRegex.hasMatch(cleanPhone);
}

bool _isStrongPassword(String password) {
  if (password.length < 8) return false;

  final hasLower = password.contains(RegExp(r'[a-z]'));
  final hasUpper = password.contains(RegExp(r'[A-Z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasLower && hasUpper && hasDigit && hasSpecial;
}

String _capitalize(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

String _truncate(String text, int maxLength) {
  if (text.length <= maxLength) return text;
  return '${text.substring(0, maxLength - 3)}...';
}
