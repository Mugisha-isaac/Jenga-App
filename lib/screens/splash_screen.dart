import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/modules/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    super.initState();
    // Let the SplashController handle navigation logic
    // Remove the conflicting navigation logic from here
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.apps,
                size: 100,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Jenga',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.displayLarge?.color ?? Colors.black,
              ),
            ),
            const SizedBox(height: 32),
            CircularProgressIndicator(
              color: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
