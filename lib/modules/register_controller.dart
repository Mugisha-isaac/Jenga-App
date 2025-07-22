import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/mixins/safe_controller_mixin.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';

class RegisterController extends GetxController with SafeControllerMixin {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController fullNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController passwordController;
  late final TextEditingController confirmPasswordController;

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  // Get the AuthController and AuthRepository instances
  final AuthController authController = Get.find<AuthController>();
  final AuthRepository authRepository = Get.find<AuthRepository>();

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  void togglePasswordVisibility() {
    safeUpdate(isPasswordVisible, !isPasswordVisible.value);
  }

  void toggleConfirmPasswordVisibility() {
    safeUpdate(isConfirmPasswordVisible, !isConfirmPasswordVisible.value);
  }

  void register() async {
    if (isControllerDisposed) return;
    
    if (formKey.currentState!.validate()) {
      safeUpdate(isLoading, true);

      try {
        // Validate password confirmation
        if (passwordController.text != confirmPasswordController.text) {
          throw Exception('Passwords do not match');
        }

        print('📝 Attempting registration for: ${emailController.text}');
        
        // Implement actual Firebase registration logic
        final user = await authRepository.createUserWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
          fullNameController.text.trim(),
          phoneController.text.trim(),
        );
        
        print('✅ Registration successful for user: ${user.fullName} (${user.email})');

        // Mark onboarding as completed if not already done
        final preferenceService = Get.find<PreferenceService>();
        if (!preferenceService.hasCompletedOnboarding) {
          await preferenceService.setOnboardingCompleted();
        }

        // Update the auth controller's current user
        authController.setCurrentUser(user);

        // Navigate to home and clear the navigation stack
        Get.offAllNamed(Routes.HOME);
        
        print('✅ Registration successful, navigated to home');
        
        Get.snackbar(
          'Success',
          'Welcome to Jenga, ${user.fullName}! Your account has been created successfully.',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        print('❌ Registration error: $e');
        
        String errorMessage = 'Registration failed. Please try again.';
        
        // Handle specific Firebase auth errors
        if (e.toString().contains('email-already-in-use')) {
          errorMessage = 'An account with this email already exists.';
        } else if (e.toString().contains('weak-password')) {
          errorMessage = 'Password is too weak. Please choose a stronger password.';
        } else if (e.toString().contains('invalid-email')) {
          errorMessage = 'Please enter a valid email address.';
        } else if (e.toString().contains('network-request-failed')) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (e.toString().contains('Passwords do not match')) {
          errorMessage = 'Passwords do not match. Please check and try again.';
        }
        
        Get.snackbar(
          'Registration Failed',
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

  void navigateToLogin() {
    safeCall(() => Get.back());
  }

  @override
  void onClose() {
    // Delay disposal to avoid issues with ongoing UI interactions
    Future.delayed(const Duration(milliseconds: 100), () {
      fullNameController.dispose();
      emailController.dispose();
      phoneController.dispose();
      passwordController.dispose();
      confirmPasswordController.dispose();
    });
    super.onClose();
  }
}
