import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void register() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // TODO: Implement actual Firebase registration logic
        // For now, simulate successful registration
        await Future.delayed(const Duration(seconds: 2));

        // Mark onboarding as completed if not already done
        final preferenceService = Get.find<PreferenceService>();
        if (!preferenceService.hasCompletedOnboarding) {
          await preferenceService.setOnboardingCompleted();
        }

        // Navigate to home and clear the navigation stack
        // This ensures users can't go back to registration after successful signup
        Get.offAllNamed(Routes.HOME);
        
        print('✅ Registration successful, navigated to home');
        
        Get.snackbar(
          'Success',
          'Welcome to Jenga! Your account has been created successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        print('❌ Registration error: $e');
        Get.snackbar(
          'Error',
          'Registration failed: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void navigateToLogin() {
    Get.back();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
