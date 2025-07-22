import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferenceService extends GetxService {
  static PreferenceService get instance => Get.find<PreferenceService>();
  
  late SharedPreferences _prefs;

  Future<PreferenceService> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('🔧 PreferenceService initialized');
    return this;
  }

  // Keys
  static const String _onboardingKey = 'onboarding_completed';
  static const String _firstLaunchKey = 'first_launch';

  // Onboarding completion status
  bool get hasCompletedOnboarding {
    final completed = _prefs.getBool(_onboardingKey) ?? false;
    print('📱 Onboarding completed: $completed');
    return completed;
  }
  
  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
    print('✅ Onboarding marked as completed');
  }

  // First launch detection
  bool get isFirstLaunch {
    final firstLaunch = _prefs.getBool(_firstLaunchKey) ?? true;
    print('📱 Is first launch: $firstLaunch');
    return firstLaunch;
  }
  
  Future<void> setNotFirstLaunch() async {
    await _prefs.setBool(_firstLaunchKey, false);
    print('✅ First launch flag set to false');
  }

  // Clear all preferences (for logout)
  Future<void> clearAll() async {
    await _prefs.clear();
    print('🗑️ All preferences cleared');
  }

  // Debug method to check all stored values
  void debugPrintAll() {
    print('🔍 All preferences:');
    print('  - Onboarding completed: ${hasCompletedOnboarding}');
    print('  - Is first launch: ${isFirstLaunch}');
  }
}
