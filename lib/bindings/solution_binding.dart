import 'package:get/get.dart';
import 'package:jenga_app/modules/solution_controller.dart';
import 'package:jenga_app/modules/payment_controller.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/services/signed_cloudinary_service.dart';

class SolutionBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.put<SignedCloudinaryService>(SignedCloudinaryService());

    // Register controllers
    Get.lazyPut<AuthController>(() => AuthController());
    Get.put<SolutionController>(SolutionController());
    Get.put<PaymentController>(PaymentController());
  }
}
