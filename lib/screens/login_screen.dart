import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jenga_app/modules/login_controller.dart';
import 'package:jenga_app/routes/pages.dart';
import 'package:jenga_app/themes/app_theme.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the LoginController
    Get.put(LoginController());

    return Scaffold(
      backgroundColor: Colors.white,
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
              key: Get.find<LoginController>().formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),
                  // Logo and Title
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                        errorBuilder: (context, error, stackTrace) => 
                            Icon(Icons.account_circle, size: 100, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Welcome Back',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                
                  // Email Field
                  TextFormField(
                    controller: Get.find<LoginController>().emailController,
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
                
                  // Password Field
                  Obx(
                    () => TextFormField(
                      controller: Get.find<LoginController>().passwordController,
                      obscureText: !Get.find<LoginController>().isPasswordVisible.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline, color: Colors.black87),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Get.find<LoginController>().isPasswordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.black87,
                          ),
                          onPressed: Get.find<LoginController>().togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  ),
                
                  const SizedBox(height: 8),
                
                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        
                      },
                      child: const Text('Forgot Password?', style: TextStyle(color: Colors.black87)),
                    ),
                  ),
                
                  const SizedBox(height: 24),
                
                  // Login Button
                  Obx(
                    () => FilledButton(
                      onPressed: Get.find<LoginController>().isLoading.value
                          ? null
                          : () {
                              if (Get.find<LoginController>().formKey.currentState!.validate()) {
                                Get.find<LoginController>().login();
                              }
                            },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Get.find<LoginController>().isLoading.value
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Login', style: TextStyle(color: Colors.white)),
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
                          'or continue with',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                
                  const SizedBox(height: 24),
                
                  
                  Center(
                    child: OutlinedButton.icon(
                      onPressed: Get.find<LoginController>().isLoading.value ? null : Get.find<LoginController>().signInWithGoogle,
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
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                
                  const SizedBox(height: 32),
                
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      TextButton(
                        onPressed: Get.find<LoginController>().isLoading.value ? null : () {
                          Get.toNamed(Routes.REGISTER);
                        },
                        child: const Text('Sign Up', style: TextStyle(color: Colors.black87)),
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