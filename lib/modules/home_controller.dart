import 'package:get/get.dart';
import 'package:jenga_app/routes/routes.dart';

class HomeController extends GetxController {
  final currentIndex = 0.obs;

  void changeTab(int index) {
    currentIndex.value = index;
  }

  void navigateToProfile() {
    Get.toNamed(Routes.profile);
  }

  void navigateToSettings() {
    Get.toNamed(Routes.settings);
  }

  void logout() {
    Get.offAllNamed(Routes.login);
  }
}
