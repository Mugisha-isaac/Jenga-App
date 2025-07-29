import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/modules/register_controller.dart';
import 'package:jenga_app/routes/pages.dart';
import 'package:jenga_app/themes/app_theme.dart';

class RegisterScreen extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.back(),
        ),
        title: const Text('Create An Account', style: TextStyle(color: Colors.black87)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppTheme.primaryColor,
                onSurface: Colors.black87,
              ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Logo and Title
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 100,
                        height: 100,
                        errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.account_circle, size: 80, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Create an account',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Fill in your details to get started',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Full Name Field
                  TextFormField(
                    controller: controller.fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(Icons.person_outline, color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(Icons.email_outlined, color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  TextFormField(
                    controller: controller.phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone (Optional)',
                      prefixIcon: const Icon(Icons.phone_outlined, color: Colors.black87),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[50],
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  Obx(
                    () => TextFormField(
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black87,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  Obx(
                    () => TextFormField(
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isConfirmPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isConfirmPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black87,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != controller.passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Register Button
                  Obx(
                    () => FilledButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () {
                              if (controller.formKey.currentState!.validate()) {
                                controller.register();
                              }
                            },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Create Account', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider with "or" text
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'or sign up with',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Google Sign In Button
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: controller.isLoading.value ? null : controller.signInWithGoogle,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                        side: BorderSide(color: Colors.grey[300]!),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      icon: Image.asset(
                        'assets/images/google.png',
                        width: 24,
                        height: 24,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.g_mobiledata, size: 24, color: Colors.black87),
                      ),
                      label: const Text(
                        'Sign up with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Login Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: controller.isLoading.value ? null : controller.navigateToLogin,
                        child: const Text('Log In', style: TextStyle(color: Colors.black87)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
