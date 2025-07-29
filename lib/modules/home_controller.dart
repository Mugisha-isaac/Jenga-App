import 'package:get/get.dart';
import 'package:jenga_app/routes/pages.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void navigateToProfile() {
    Get.toNamed(Routes.PROFILE);
  }

  void navigateToSettings() {
    Get.toNamed(Routes.SETTINGS);
  }

  void logout() {
    Get.offAllNamed(Routes.LOGIN);
  }
}
