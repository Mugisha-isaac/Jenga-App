import 'package:get/get.dart';
import 'package:jenga_app/modules/solution_controller.dart';
import 'package:jenga_app/services/signed_cloudinary_service.dart';

class SolutionBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.put<SignedCloudinaryService>(SignedCloudinaryService());

    // Register controllers
    Get.put<SolutionController>(SolutionController());
  }
}
