import 'package:get/get.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    // Wait for splash duration
    await Future.delayed(const Duration(seconds: 3));
    
    try {
      // Wait a bit more for Firebase auth to initialize
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Get services - use Get.find with proper error handling
      final preferenceService = Get.find<PreferenceService>();
      final authController = Get.find<AuthController>();
      
      // Debug prints to track the flow
      print('🔍 Auth state: ${authController.isLoggedIn}');
      print('🔍 Onboarding completed: ${preferenceService.hasCompletedOnboarding}');
      print('🔍 Current user: ${authController.currentUser.value?.uid}');
      
      // Check authentication state and onboarding completion
      if (authController.isLoggedIn && authController.currentUser.value != null) {
        // User is logged in and verified, go directly to home
        print('✅ Navigating to HOME - User is logged in');
        Get.offAllNamed(Routes.HOME);
      } else if (preferenceService.hasCompletedOnboarding) {
        // User has seen onboarding before, go to login
        print('✅ Navigating to LOGIN - Onboarding completed');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        // First time user, show welcome screen
        print('✅ Navigating to WELCOME - First time user');
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
      // Fallback to welcome screen if there are any issues
      print('❌ Error in splash navigation: $e');
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}