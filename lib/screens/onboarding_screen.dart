import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:jenga_app/modules/auth_controller.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Column(
            children: [
              Image.asset('assets/images/onboarding.png', height: 300),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Text(
                'Welcome to Jenga',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              const Text(
                'Jenga is a community-driven platform where you can share your local solutions and learn from others to address everyday challenges in Rwanda.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _CustomButton(
                text: 'Next',
                onPressed: () async {
                  try {
                    // Mark onboarding as completed
                    final preferenceService = Get.find<PreferenceService>();
                    await preferenceService.setOnboardingCompleted();

                    print('✅ Onboarding completed and saved');

                    // Check if user is already authenticated
                    final authController = Get.find<AuthController>();
                    if (authController.isLoggedIn &&
                        authController.currentUser.value != null) {
                      // User is authenticated, go to home
                      print('✅ User is authenticated, navigating to HOME');
                      Get.offAllNamed(Routes.HOME);
                    } else {
                      // User is not authenticated, go to login screen
                      print('✅ User not authenticated, navigating to LOGIN');
                      Get.offAllNamed(Routes.LOGIN);
                    }
                  } catch (e) {
                    print('❌ Error completing onboarding: $e');
                    // Still navigate to login even if saving fails
                    Get.offAllNamed(Routes.LOGIN);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Private custom button widget with unused `key` removed
class _CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
