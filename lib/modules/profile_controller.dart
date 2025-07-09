import 'package:get/get.dart';
import 'package:jenga_app/models/user.dart';

class ProfileController extends GetxController {
  final user = Rxn<User>();
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  void loadUserProfile() async {
    isLoading.value = true;

    try {
      // TODO: Implement profile loading logic
      await Future.delayed(const Duration(seconds: 1));

      // Mock user data
      user.value = User(
        id: '1',
        fullName: 'John Doe',
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
        profilePictureUrl: null,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void updateProfile(User updatedUser) async {
    isLoading.value = true;

    try {
      // TODO: Implement profile update logic
      await Future.delayed(const Duration(seconds: 1));

      user.value = updatedUser;
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }
}
