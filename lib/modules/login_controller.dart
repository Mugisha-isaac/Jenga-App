import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/user_service.dart';
import 'package:jenga_app/modules/login_controller.dart';
import 'package:jenga_app/themes/app_theme.dart';

class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

Future<void> forgotPassword(String email) async {
  if (email.isEmpty) {
    Get.snackbar('Error', 'Please enter your email address',
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  if (!GetUtils.isEmail(email)) {
    Get.snackbar('Error', 'Please enter a valid email address',
        backgroundColor: Colors.red, colorText: Colors.white);
    return;
  }

  try {
    isLoading.value = true;
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    
    Get.back(); 
    Get.snackbar(
      'Success',
      'Password reset link sent successfully! Please check your email.',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
    );
  } on FirebaseAuthException catch (e) {
    String message = 'Failed to send password reset email';
    if (e.code == 'user-not-found') {
      message = 'No account found with this email';
    }
    Get.snackbar('Error', message,
        backgroundColor: Colors.red, colorText: Colors.white);
  } catch (e) {
    Get.snackbar('Error', 'An error occurred. Please try again.',
        backgroundColor: Colors.red, colorText: Colors.white);
  } finally {
    isLoading.value = false;
  }
}
  
  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      try {
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        
        if (credential.user != null) {
          Get.offAllNamed(Routes.HOME);
        }
      } on FirebaseAuthException catch (e) {
        String message = 'Login failed';
        if (e.code == 'user-not-found' || e.code == 'wrong-password') {
          message = 'Invalid email or password';
        } else if (e.code == 'user-disabled') {
          message = 'This account has been disabled';
        }
        Get.snackbar('Error', message,
            backgroundColor: Colors.red, colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', 'An error occurred. Please try again.',
            backgroundColor: Colors.red, colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        isLoading.value = false;
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        final isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;

        if (isNewUser) {
          await UserService().createUserProfile(
            user: userCredential.user!,
            fullName: userCredential.user?.displayName ?? 'New User',
            email: userCredential.user?.email ?? '',
            profilePictureUrl: userCredential.user?.photoURL,
          );
        }

        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to sign in with Google: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToRegister() {
    try {
      Get.toNamed(Routes.REGISTER);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to navigate to register: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}