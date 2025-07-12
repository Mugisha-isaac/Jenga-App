import 'package:get/get.dart';
import 'package:jenga_app/modules/solution_controller.dart';

class SolutionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SolutionController>(() => SolutionController());
  }
}