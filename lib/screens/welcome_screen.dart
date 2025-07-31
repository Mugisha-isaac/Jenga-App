import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:jenga_app/modules/auth_controller.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  void _handleContinue() async {
    try {
      final preferenceService = Get.find<PreferenceService>();
      final authController = Get.find<AuthController>();

      // Check if user is authenticated
      if (authController.isLoggedIn &&
          authController.currentUser.value != null) {
        // User is authenticated, go directly to home
        print('✅ User is authenticated, navigating to HOME');
        Get.offAllNamed(Routes.HOME);
        return;
      }

      // Check if user has completed onboarding before
      if (preferenceService.hasCompletedOnboarding) {
        // User has completed onboarding before, go to login
        print('✅ User has completed onboarding, navigating to LOGIN');
        Get.offAllNamed(Routes.LOGIN);
      } else {
        // First time user, show onboarding
        print('✅ First time user, navigating to ONBOARDING');
        Get.offAllNamed(Routes.ONBOARDING);
      }
    } catch (e) {
      print('❌ Error in welcome navigation: $e');
      // Fallback to onboarding
      Get.offAllNamed(Routes.ONBOARDING);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Image.asset(
              'assets/images/welcome.png',
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.5,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                height: MediaQuery.of(context).size.height * 0.5,
                color: colorScheme.surface,
                child: Icon(
                  Icons.image,
                  size: 100,
                  color: colorScheme.secondary,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome to Jenga',
                      textAlign: TextAlign.center,
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Share your local solutions and learn from others to address everyday challenges in Rwanda.',
                      textAlign: TextAlign.center,
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onBackground.withOpacity(0.7),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: _CustomButton(
                        text: 'Continue',
                        onPressed: _handleContinue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _CustomButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          text,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
