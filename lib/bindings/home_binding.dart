import 'package:get/get.dart';
import 'package:jenga_app/modules/home_controller.dart';
import 'package:jenga_app/modules/solution_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SolutionController>(() => SolutionController());
  }
}
