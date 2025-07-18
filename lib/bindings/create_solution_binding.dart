// lib/bindings/create_solution_binding.dart
import 'package:get/get.dart';
import '../modules/solution_controller.dart';
import '../modules/auth_controller.dart';

class CreateSolutionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SolutionController>(() => SolutionController());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
