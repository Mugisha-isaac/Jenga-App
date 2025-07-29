import 'package:get/get.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DependencyInjection {
  static Future<void> init() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    // Register SharedPreferences
    Get.put(sharedPreferences);

    // Register providers
    Get.put(FirestoreUserProvider());
    Get.put(AuthRepository());
  }
}