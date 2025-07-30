import 'package:get/get.dart';
import 'package:jenga_app/modules/profile_controller.dart';
import 'package:jenga_app/modules/register_controller.dart';
import 'package:jenga_app/modules/login_controller.dart';
import 'package:jenga_app/modules/payment_controller.dart';
import 'package:jenga_app/providers/firebase_auth_provider.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';
import 'package:jenga_app/providers/firestore_solutions_provider.dart';
import 'package:jenga_app/providers/firestore_paid_solutions_provider.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/repositories/solution_repository.dart';
import 'package:jenga_app/repositories/paid_solution_repository.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:jenga_app/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static Future<void> init() async {
    // Initialize SharedPreferences
    final sharedPreferences = await SharedPreferences.getInstance();
    Get.put(sharedPreferences);

    // Initialize PreferenceService
    await Get.putAsync(() => PreferenceService().init());

    // Register providers
    Get.lazyPut(() => FirebaseAuthProvider(), fenix: true);
    Get.lazyPut(() => FirestoreUserProvider(), fenix: true);
    Get.lazyPut(() => FirestoreSolutionsProvider(), fenix: true);
    Get.lazyPut(() => FirestorePaidSolutionsProvider(), fenix: true);

    // Register repositories
    Get.lazyPut(() => AuthRepository(), fenix: true);

    Get.lazyPut(
      () => SolutionRepository(
        firestoreSolutionsProvider: Get.find<FirestoreSolutionsProvider>(),
      ),
      fenix: true,
    );

    Get.lazyPut(
      () => PaidSolutionRepository(
        firestorePaidSolutionsProvider: Get.find<FirestorePaidSolutionsProvider>(),
      ),
      fenix: true,
    );

    // Register services
    Get.lazyPut(() => UserService(), fenix: true);

    // Register controllers
    Get.lazyPut(() => AuthController(), fenix: true);
    Get.lazyPut(() => LoginController(), fenix: true);
    Get.lazyPut(() => RegisterController(), fenix: true);
    Get.lazyPut(() => ProfileController(), fenix: true);
    Get.lazyPut(() => PaymentController(), fenix: true);
  }
}