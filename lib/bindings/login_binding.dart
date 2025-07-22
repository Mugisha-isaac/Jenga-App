import 'package:get/get.dart';
import 'package:jenga_app/modules/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<LoginController>(LoginController(), permanent: false);
  }
}
