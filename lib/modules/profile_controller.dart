import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:jenga_app/models/user.dart';

class ProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;
      
      final doc = await _firestore.collection('users').doc(userId).get();
      if (doc.exists) {
        user.value = UserModel.fromFirestore(doc);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId == null) return;

      await _firestore.collection('users').doc(userId).update(data);
      await loadUser(); // Refresh user data
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return null;

      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();

      await _firestore.collection('users').doc(userId).update({
        'profilePictureUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (user.value != null) {
        user.update((val) {
          val?.profilePictureUrl = downloadUrl;
        });
      }

      Get.snackbar('Success', 'Profile picture updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload profile picture');
    }
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );

      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
      
      Get.back();
      Get.snackbar('Success', 'Password updated successfully');
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Failed to update password');
    } finally {
      isLoading.value = false;
    }
  }

  // Alias for loadUser to maintain compatibility
  Future<void> get loadUserProfile => loadUser();

  @override
  void onClose() {
    user.close();
    super.onClose();
  }
}