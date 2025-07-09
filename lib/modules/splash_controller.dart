import 'package:get/get.dart';
import 'package:jenga_app/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    // _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));

    // Check if user is logged in
    // For now, navigate to login screen
    Get.offAllNamed(Routes.LOGIN);
  }
}
