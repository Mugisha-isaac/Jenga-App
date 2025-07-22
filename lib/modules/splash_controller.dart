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
    await Future.delayed(const Duration(seconds: 3));
    
    try {
      // Get services
      final preferenceService = PreferenceService.instance;
      final authController = Get.find<AuthController>();
      
      // Check authentication state and onboarding completion
      if (authController.isLoggedIn) {
        // User is logged in, go directly to home
        Get.offAllNamed(Routes.HOME);
      } else if (preferenceService.hasCompletedOnboarding) {
        // User has seen onboarding before, go to login
        Get.offAllNamed(Routes.LOGIN);
      } else {
        // First time user, show welcome screen
        Get.offAllNamed(Routes.WELCOME);
      }
    } catch (e) {
      // Fallback to welcome screen if there are any issues
      Get.offAllNamed(Routes.WELCOME);
    }
  }
}