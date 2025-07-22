import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends GetxService {
  static PreferenceService get instance => Get.find<PreferenceService>();
  
  late SharedPreferences _prefs;

  Future<PreferenceService> init() async {
    _prefs = await SharedPreferences.getInstance();
    return this;
  }

  // Keys
  static const String _onboardingKey = 'onboarding_completed';
  static const String _firstLaunchKey = 'first_launch';

  // Onboarding completion status
  bool get hasCompletedOnboarding => _prefs.getBool(_onboardingKey) ?? false;
  
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // First launch detection
  bool get isFirstLaunch => _prefs.getBool(_firstLaunchKey) ?? true;
  
  Future<void> setNotFirstLaunch() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  // Clear all preferences (for logout)
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
