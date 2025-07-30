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

      // Wait for auth controller to be fully initialized
      int maxWaitTime = 10; // seconds
      int waitedTime = 0;
      while (!authController.isInitialized.value && waitedTime < maxWaitTime) {
        await Future.delayed(const Duration(milliseconds: 500));
        waitedTime++;
      }

      // Debug prints to track the flow
      print('🔍 Auth state: ${authController.isLoggedIn}');
      print(
          '🔍 Onboarding completed: ${preferenceService.hasCompletedOnboarding}');
      print('🔍 Current user: ${authController.currentUser.value?.uid}');
      print('🔍 Is first launch: ${preferenceService.isFirstLaunch}');

      // Check authentication state and flow
      if (authController.isLoggedIn &&
          authController.currentUser.value != null) {
        // User is logged in and verified, go directly to home
        print('✅ Navigating to HOME - User is logged in');
        Get.offAllNamed(Routes.HOME);
      } else if (preferenceService.isFirstLaunch) {
        // First time user, show welcome screen
        print('✅ Navigating to WELCOME - First time user');
        await preferenceService.setNotFirstLaunch();
        Get.offAllNamed(Routes.WELCOME);
      } else if (preferenceService.hasCompletedOnboarding) {
        // User has seen onboarding before, go to login
        print(
            '✅ Navigating to LOGIN - Onboarding completed, user not authenticated');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        // User has launched before but hasn't completed onboarding
        print('✅ Navigating to WELCOME - User needs to complete onboarding');
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
      // Fallback to welcome screen if there are any issues
      print('❌ Error in splash navigation: $e');
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}
