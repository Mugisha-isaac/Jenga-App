import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController extends GetxController {
  final isDarkMode = false.obs;
  final isNotificationsEnabled = true.obs;
  final selectedLanguage = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  void loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
    isNotificationsEnabled.value =
        prefs.getBool('isNotificationsEnabled') ?? true;
    selectedLanguage.value = prefs.getString('selectedLanguage') ?? 'en';
  }

  void toggleDarkMode() async {
    isDarkMode.value = !isDarkMode.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleNotifications() async {
    isNotificationsEnabled.value = !isNotificationsEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isNotificationsEnabled', isNotificationsEnabled.value);
  }

  void changeLanguage(String language) async {
    selectedLanguage.value = language;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', language);
    // TODO: Implement language change logic
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}
