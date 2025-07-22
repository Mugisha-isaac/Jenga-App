import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/mixins/safe_controller_mixin.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class LoginController extends GetxController with SafeControllerMixin {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController emailController;
  late final TextEditingController passwordController;

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  
  // Get the AuthController and AuthRepository instances
  final AuthController authController = Get.find<AuthController>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    safeUpdate(isPasswordVisible, !isPasswordVisible.value);
  }

  void login() async {
    if (isControllerDisposed) return;
    
    if (formKey.currentState!.validate()) {
      safeUpdate(isLoading, true);

      try {
        // Implement actual Firebase login logic
        print('🔐 Attempting login with email: ${emailController.text}');
        
        final user = await authRepository.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        
        print('✅ Login successful for user: ${user.fullName} (${user.email})');

        // Mark onboarding as completed if not already done
        final preferenceService = Get.find<PreferenceService>();
        if (!preferenceService.hasCompletedOnboarding) {
          await preferenceService.setOnboardingCompleted();
        }

        // Update the auth controller's current user
        authController.setCurrentUser(user);

        // Navigate to home and clear the navigation stack
        Get.offAllNamed(Routes.HOME);
        
        print('✅ Login successful, navigated to home');
        
        Get.snackbar(
          'Success',
          'Welcome back, ${user.fullName}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        print('❌ Login error: $e');
        
        String errorMessage = 'Login failed. Please try again.';
        
        // Handle specific Firebase auth errors
        if (e.toString().contains('user-not-found')) {
          errorMessage = 'No account found with this email address.';
        } else if (e.toString().contains('wrong-password')) {
          errorMessage = 'Incorrect password. Please try again.';
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = 'Please enter a valid email address.';
        } else if (e.toString().contains('too-many-requests')) {
          errorMessage = 'Too many failed attempts. Please try again later.';
        } else if (e.toString().contains('network-request-failed')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        
        Get.snackbar(
          'Login Failed',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
        );
      } finally {
        safeUpdate(isLoading, false);
      }
    }
  }

  void navigateToRegister() {
    safeCall(() => Get.toNamed(Routes.REGISTER));
  }

  @override
  void onClose() {
    // Delay disposal to avoid issues with ongoing UI interactions
    Future.delayed(const Duration(milliseconds: 100), () {
      emailController.dispose();
      passwordController.dispose();
    });
    super.onClose();
  }
}
