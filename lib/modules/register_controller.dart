import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jenga_app/models/user.dart';
import 'package:jenga_app/routes/pages.dart';
import 'package:jenga_app/services/user_service.dart';

class RegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final RxBool isLoading = false.obs;
  final formKey = GlobalKey<FormState>();
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;

  void togglePasswordVisibility() => isPasswordVisible.toggle();
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.toggle();

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    try {
      isLoading.value = true;
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (userCredential.user != null) {
        await UserService().createUserProfile(
          user: userCredential.user!,
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          // phoneNumber: phoneController.text.trim(),
        );
        Get.offAllNamed(Routes.HOME);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to register';
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists for that email.';
      }
      Get.snackbar('Error', message);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await UserService().createUserProfile(
          user: userCredential.user!,
          fullName: userCredential.user?.displayName ?? 'New User',
          email: userCredential.user?.email ?? '',
          profilePictureUrl: userCredential.user?.photoURL,
        );
        Get.offAllNamed(Routes.HOME);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign in with Google');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToLogin() => Get.offAllNamed(Routes.LOGIN);

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    _googleSignIn.signOut();
    super.onClose();
  }
}