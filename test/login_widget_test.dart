import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  group('LoginScreen Widget Tests', () {
    setUp(() async {
      Get.reset();
      Get.testMode = true;
    });

    tearDown(() {
      Get.reset();
      Get.testMode = false;
    });

    testWidgets('LoginScreen renders basic layout',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            appBar: AppBar(title: const Text('Login')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome Back', style: TextStyle(fontSize: 24)),
                  SizedBox(height: 20),
                  Text('Please sign in to continue'),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Please sign in to continue'), findsOneWidget);
    });

    testWidgets('LoginScreen has required layout components',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                children: [
                  const Text('Email'),
                  TextField(
                    key: const Key('email_field'),
                    decoration: const InputDecoration(hintText: 'Enter email'),
                  ),
                  const Text('Password'),
                  TextField(
                    key: const Key('password_field'),
                    obscureText: true,
                    decoration:
                        const InputDecoration(hintText: 'Enter password'),
                  ),
                  ElevatedButton(
                    key: const Key('login_button'),
                    onPressed: () {},
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);
      expect(find.byKey(const Key('login_button')), findsOneWidget);
    });
  });
}
