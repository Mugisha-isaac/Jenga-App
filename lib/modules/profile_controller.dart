import 'package:get/get.dart';
import 'package:jenga_app/models/user.dart' as user_model;
import 'dart:io';
import 'package:jenga_app/repositories/profile_repository.dart';
import 'package:jenga_app/modules/auth_controller.dart';

class ProfileController extends GetxController {
  final ProfileRepository _profileRepository = ProfileRepository();
  final Rx<user_model.User?> user = Rx<user_model.User?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      isLoading.value = true;
      // You should get userId from AuthController or similar
      final userId = Get.find<AuthController>().userId;
      if (userId.isEmpty) return;
      user.value = await _profileRepository.loadUser(userId);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;
      final userId = Get.find<AuthController>().userId;
      if (userId.isEmpty) return;
      await _profileRepository.updateProfile(userId, data);
      await loadUser();
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfilePicture(File imageFile) async {
    try {
      final userId = Get.find<AuthController>().userId;
      if (userId.isEmpty) return;
      final downloadUrl = await _profileRepository.updateProfilePicture(userId, imageFile);
      if (downloadUrl != null && user.value != null) {
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
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      isLoading.value = true;
      await _profileRepository.changePassword(email, currentPassword, newPassword);
      Get.back();
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> get loadUserProfile => loadUser();

  @override
  void onClose() {
    user.close();
    super.onClose();
  }
}