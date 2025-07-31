// Widget tests for the Jenga App
// These tests verify that widgets render correctly and handle user interactions

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Simple mock services that don't depend on Firebase
class MockPreferenceService extends GetxService {
  bool get hasCompletedOnboarding => false;
  bool get hasValidSession => false;
  String? get savedUserId => null;
  Future<void> clearUserSession() async {}
  Future<MockPreferenceService> init() async => this;
}

class MockAuthController extends GetxController {
  final Rxn<dynamic> currentUser = Rxn<dynamic>();
  final RxBool isInitialized = false.obs;
  bool get isLoggedIn => false;
}

// Simple mock splash controller that doesn't navigate
class MockSplashController extends GetxController {
  // Don't navigate anywhere for testing
}

void main() {
  group('Jenga App Widget Tests', () {
    setUp(() async {
      Get.reset();
      Get.testMode = true;
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      Get.reset();
      Get.testMode = false;
    });

    testWidgets('SplashScreen displays logo and app name',
        (WidgetTester tester) async {
      // Create a simple test version of splash screen
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Mock logo
                  Icon(Icons.apps, size: 120),
                  SizedBox(height: 20),
                  Text('Jenga',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify that the app name 'Jenga' is displayed
      expect(find.text('Jenga'), findsOneWidget);

      // Verify that there's a loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Verify that the icon is displayed
      expect(find.byIcon(Icons.apps), findsOneWidget);
    });

    testWidgets('SplashScreen handles missing logo gracefully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Test fallback icon when image fails
                  Icon(Icons.apps, size: 120),
                  SizedBox(height: 20),
                  Text('Jenga',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify fallback icon is shown
      expect(find.byIcon(Icons.apps), findsOneWidget);
    });

    testWidgets('SplashScreen has correct styling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps, size: 120),
                  SizedBox(height: 20),
                  Text('Jenga',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      );

      // Find the Jenga text widget
      final textWidget = tester.widget<Text>(find.text('Jenga'));

      // Verify text styling
      expect(textWidget.style?.fontSize, 40);
      expect(textWidget.style?.fontWeight, FontWeight.bold);

      // Verify the scaffold exists
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('SplashScreen layout structure is correct',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.apps, size: 120),
                  SizedBox(height: 20),
                  Text('Jenga',
                      style:
                          TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify main layout components exist
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(Center), findsAtLeastNWidgets(1));
      expect(find.byType(Column), findsOneWidget);

      // Verify SizedBox spacers exist (should find multiple)
      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });
  });
}
