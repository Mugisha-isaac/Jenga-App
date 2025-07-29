import 'package:get/get.dart';
import 'package:jenga_app/routes/pages.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3));
    Get.offAllNamed(Routes.WELCOME); 
  }
}