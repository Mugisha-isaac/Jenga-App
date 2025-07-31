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

      // Check authentication state and flow
      if (authController.isLoggedIn &&
          authController.currentUser.value != null) {
        // User is logged in and verified, go directly to home
        Get.offAllNamed(Routes.home);
      } else if (preferenceService.isFirstLaunch) {
        // First time user, show welcome screen
        await preferenceService.setNotFirstLaunch();
        Get.offAllNamed(Routes.welcome);
      } else if (preferenceService.hasCompletedOnboarding) {
        // User has seen onboarding before, go to login
        Get.offAllNamed(Routes.login);
      } else {
        // User has launched before but hasn't completed onboarding
        Get.offAllNamed(Routes.welcome);
      }
    } catch (e) {
      // Ignore errors silently
      // Fallback to welcome screen if there are any issues
      Get.offAllNamed(Routes.welcome);
    }
  }
}
