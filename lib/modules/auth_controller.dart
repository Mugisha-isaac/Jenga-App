// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> currentUser = Rxn<User>();
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  void _initAuth() async {
    // Set initial user if already logged in
    currentUser.value = _auth.currentUser;
    
    // Listen to auth state changes
    currentUser.bindStream(_auth.authStateChanges());
    
    // Listen to user changes and debug
    ever(currentUser, (User? user) {
      print('🔐 Auth state changed: ${user?.uid ?? 'null'}');
      if (user != null) {
        print('✅ User is logged in: ${user.email}');
      } else {
        print('❌ User is logged out');
      }
    });
    
    isInitialized.value = true;
    print('🔧 AuthController initialized');
  }

  // Get current user ID
  String get userId => currentUser.value?.uid ?? 'user123';

  // Check if user is logged in
  bool get isLoggedIn {
    final loggedIn = currentUser.value != null;
    print('🔍 Checking isLoggedIn: $loggedIn');
    return loggedIn;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print('✅ User signed out successfully');
      
      // Don't clear onboarding preference on logout
      // Users shouldn't see onboarding again
      final preferenceService = Get.find<PreferenceService>();
      if (!preferenceService.hasCompletedOnboarding) {
        await preferenceService.setOnboardingCompleted();
      }
      
      // Navigate to login screen after logout
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }
}