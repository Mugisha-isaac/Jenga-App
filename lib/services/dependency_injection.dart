import 'package:get/get.dart';
import 'package:jenga_app/providers/firebase_auth_provider.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';
import 'package:jenga_app/providers/firestore_solutions_provider.dart';
import 'package:jenga_app/providers/firestore_paid_solutions_provider.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/repositories/solution_repository.dart';
import 'package:jenga_app/repositories/paid_solution_repository.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static Future<void> init() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Register SharedPreferences
    Get.put(sharedPreferences);

    // Register PreferenceService
    await Get.putAsync(() => PreferenceService().init());

    // Register providers
    Get.put(FirebaseAuthProvider());
    Get.put(FirestoreUserProvider());
    Get.put(FirestoreSolutionsProvider());
    Get.put(FirestorePaidSolutionsProvider());

    // Register repositories
    Get.put(
      AuthRepository(
        firebaseAuthProvider: Get.find<FirebaseAuthProvider>(),
        firestoreUserProvider: Get.find<FirestoreUserProvider>(),
      ),
    );

    Get.put(
      SolutionRepository(
        firestoreSolutionsProvider: Get.find<FirestoreSolutionsProvider>(),
      ),
    );

    Get.put(
      PaidSolutionRepository(
        firestorePaidSolutionsProvider:
            Get.find<FirestorePaidSolutionsProvider>(),
      ),
    );

    // Register controllers
    Get.put(AuthController());
  }
}
