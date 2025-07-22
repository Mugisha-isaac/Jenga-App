import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/modules/auth_controller.dart';
import 'package:jenga_app/routes/routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  
  // Get the AuthController instance
  final AuthController authController = Get.find<AuthController>();

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        // TODO: Implement actual Firebase login logic
        // For now, simulate successful login
        await Future.delayed(const Duration(seconds: 2));

        // Navigate to home and clear the navigation stack
        // This ensures users can't go back to login after successful login
        Get.offAllNamed(Routes.HOME);
        
        Get.snackbar(
          'Success',
          'Welcome back!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  void navigateToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
