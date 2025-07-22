import 'package:get/get.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/modules/login_controller.dart';
import 'package:jenga_app/modules/register_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put() instead of Get.lazyPut() to ensure immediate availability
    Get.put<AuthController>(AuthController());
    Get.put<LoginController>(LoginController());
    Get.put<RegisterController>(RegisterController());
  }
}
