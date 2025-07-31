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
  static const String _userSessionKey = 'user_session';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _sessionExpiryKey = 'session_expiry';

  // Onboarding completion status
  bool get hasCompletedOnboarding {
    final completed = _prefs.getBool(_onboardingKey) ?? false;
    return completed;
  }

  Future<void> setOnboardingCompleted() async {
    await _prefs.setBool(_onboardingKey, true);
  }

  // First launch detection
  bool get isFirstLaunch {
    final firstLaunch = _prefs.getBool(_firstLaunchKey) ?? true;
    return firstLaunch;
  }

  Future<void> setNotFirstLaunch() async {
    await _prefs.setBool(_firstLaunchKey, false);
  }

  // Session Management
  Future<void> saveUserSession({
    required String userId,
    required String email,
    String? fullName,
    int sessionDurationDays = 30,
  }) async {
    final expiryDate = DateTime.now().add(Duration(days: sessionDurationDays));

    await _prefs.setBool(_userSessionKey, true);
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userEmailKey, email);
    if (fullName != null) {
      await _prefs.setString(_userNameKey, fullName);
    }
    await _prefs.setString(_sessionExpiryKey, expiryDate.toIso8601String());

  }

  bool get hasValidSession {
    final hasSession = _prefs.getBool(_userSessionKey) ?? false;
    if (!hasSession) {
      return false;
    }

    final expiryString = _prefs.getString(_sessionExpiryKey);
    if (expiryString == null) {
      return false;
    }

    final expiryDate = DateTime.parse(expiryString);
    final isValid = DateTime.now().isBefore(expiryDate);

    return isValid;
  }

  String? get savedUserId => _prefs.getString(_userIdKey);
  String? get savedUserEmail => _prefs.getString(_userEmailKey);
  String? get savedUserName => _prefs.getString(_userNameKey);

  Future<void> clearUserSession() async {
    await _prefs.remove(_userSessionKey);
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_sessionExpiryKey);
  }

  // Clear all preferences (for logout)
  Future<void> clearAll() async {
    await _prefs.clear();
  }

  // Debug method to check all stored values
  void debugPrintAll() {

  }
}
