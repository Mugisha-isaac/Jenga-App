// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> currentUser = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_auth.authStateChanges());
  }

  // Get current user ID
  String get userId => currentUser.value?.uid ?? 'user123';

  // Check if user is logged in
  bool get isLoggedIn => currentUser.value != null;

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    // Navigate to login screen after logout
    // Users don't need to see onboarding again
    Get.offAllNamed(Routes.LOGIN);
  }
}