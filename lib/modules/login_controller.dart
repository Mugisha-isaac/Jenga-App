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
  final isGoogleLoading = false.obs;
  final isForgotPasswordLoading = false.obs;

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

        final user = await authRepository.signInWithEmailAndPassword(
          emailController.text.trim(),
          passwordController.text.trim(),
        );


        // Mark onboarding as completed if not already done
        final preferenceService = Get.find<PreferenceService>();
        if (!preferenceService.hasCompletedOnboarding) {
          await preferenceService.setOnboardingCompleted();
        }

        // Update the auth controller's current user
        authController.setCurrentUser(user);

        // Navigate to home and clear the navigation stack
        Get.offAllNamed(Routes.home);


        Get.snackbar(
          'Success',
          'Welcome back, ${user.fullName}!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } catch (e) {
        // Ignore errors silently

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
    safeCall(() => Get.toNamed(Routes.register));
  }

  void signInWithGoogle() async {
    if (isControllerDisposed) return;

    safeUpdate(isGoogleLoading, true);

    try {

      final user = await authRepository.signInWithGoogle();


      // Mark onboarding as completed if not already done
      final preferenceService = Get.find<PreferenceService>();
      if (!preferenceService.hasCompletedOnboarding) {
        await preferenceService.setOnboardingCompleted();
      }

      // Update the auth controller's current user
      authController.setCurrentUser(user);

      // Navigate to home and clear the navigation stack
      Get.offAllNamed(Routes.home);


      Get.snackbar(
        'Success',
        'Welcome, ${user.fullName}!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
        // Ignore errors silently

      String errorMessage = 'Google Sign-In failed. Please try again.';

      // Handle specific Google Sign-In errors
      if (e.toString().contains('sign_in_canceled')) {
        errorMessage = 'Google Sign-In was canceled.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Network error. Please check your connection.';
      } else if (e
          .toString()
          .contains('account-exists-with-different-credential')) {
        errorMessage = 'An account already exists with this email address.';
      }

      Get.snackbar(
        'Google Sign-In Failed',
        errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
    } finally {
      safeUpdate(isGoogleLoading, false);
    }
  }

  void forgotPassword() async {
    if (isControllerDisposed) return;

    // Show dialog to get email
    final emailController = TextEditingController();
    await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                'Enter your email address and we\'ll send you a link to reset your password.'),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          Obx(() => FilledButton(
                onPressed: isForgotPasswordLoading.value
                    ? null
                    : () async {
                        final email = emailController.text.trim();
                        if (email.isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please enter your email address.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        if (!GetUtils.isEmail(email)) {
                          Get.snackbar(
                            'Error',
                            'Please enter a valid email address.',
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                          );
                          return;
                        }

                        safeUpdate(isForgotPasswordLoading, true);

                        try {
                          await authRepository.sendPasswordResetEmail(email);
                          Get.back(result: true);

                          Get.snackbar(
                            'Success',
                            'Password reset email sent to $email',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 5),
                          );
                        } catch (e) {
        // Ignore errors silently

                          String errorMessage =
                              'Failed to send reset email. Please try again.';

                          if (e.toString().contains('user-not-found')) {
                            errorMessage =
                                'No account found with this email address.';
                          } else if (e.toString().contains('invalid-email')) {
                            errorMessage =
                                'Please enter a valid email address.';
                          } else if (e
                              .toString()
                              .contains('too-many-requests')) {
                            errorMessage =
                                'Too many requests. Please try again later.';
                          }

                          Get.snackbar(
                            'Error',
                            errorMessage,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                            duration: const Duration(seconds: 4),
                          );
                        } finally {
                          safeUpdate(isForgotPasswordLoading, false);
                        }
                      },
                child: isForgotPasswordLoading.value
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Send Reset Link'),
              )),
        ],
      ),
    );

    emailController.dispose();
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
