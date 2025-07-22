import 'package:get/get.dart';
import 'package:jenga_app/modules/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<RegisterController>(RegisterController(), permanent: false);
  }
}
