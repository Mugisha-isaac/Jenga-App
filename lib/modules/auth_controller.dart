// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:jenga_app/models/user.dart' as user_model;
import 'package:jenga_app/repositories/auth_repository.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> currentUser = Rxn<User>();
  final Rxn<user_model.User> currentUserData = Rxn<user_model.User>();
  final RxBool isInitialized = false.obs;
  
  // Cache for user data to avoid repeated API calls
  final Map<String, user_model.User> _userCache = {};

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  void _initAuth() async {
    // Check for saved session first
    final preferenceService = Get.find<PreferenceService>();

    if (preferenceService.hasValidSession) {
      print('📱 Valid session found, attempting to restore user...');
      final savedUserId = preferenceService.savedUserId;
      if (savedUserId != null) {
        try {
          // Load user data from saved session
          final authRepository = Get.find<AuthRepository>();
          final userData =
              await authRepository.firestoreUserProvider.getUser(savedUserId);
          if (userData != null) {
            currentUserData.value = userData;
            print('✅ User session restored: ${userData.fullName}');
          }
        } catch (e) {
          print('❌ Error restoring session: $e');
          // Clear invalid session
          await preferenceService.clearUserSession();
        }
      }
    }

    // Set initial user if already logged in
    currentUser.value = _auth.currentUser;

    // Listen to auth state changes
    currentUser.bindStream(_auth.authStateChanges());

    // Listen to user changes and debug
    ever(currentUser, (User? user) {
      print('🔐 Auth state changed: ${user?.uid ?? 'null'}');
      if (user != null) {
        print('✅ User is logged in: ${user.email}');
        _loadUserData(user.uid);
      } else {
        print('❌ User is logged out');
        currentUserData.value = null;
      }
    });

    isInitialized.value = true;
    print('🔧 AuthController initialized');
  }

  // Load user data from Firestore
  void _loadUserData(String userId) async {
    try {
      final authRepository = Get.find<AuthRepository>();
      final userData =
          await authRepository.firestoreUserProvider.getUser(userId);
      currentUserData.value = userData;
      print('📋 User data loaded: ${userData?.fullName}');

      // Save session when user data is loaded
      if (userData != null && currentUser.value != null) {
        final preferenceService = Get.find<PreferenceService>();
        await preferenceService.saveUserSession(
          userId: userId,
          email: currentUser.value!.email ?? userData.email ?? '',
          fullName: userData.fullName,
        );
      }
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  // Set current user data (called after login/register)
  void setCurrentUser(user_model.User user) async {
    currentUserData.value = user;
    print('👤 Current user data set: ${user.fullName}');

    // Save session when user is set
    final preferenceService = Get.find<PreferenceService>();
    await preferenceService.saveUserSession(
      userId: user.id ?? '',
      email: user.email ?? '',
      fullName: user.fullName,
    );
  }

  // Get current user ID
  String get userId => currentUser.value?.uid ?? 'user123';

  // Get user data by ID
  Future<user_model.User?> getUserById(String userId) async {
    // Check cache first
    if (_userCache.containsKey(userId)) {
      print('📋 User data loaded from cache for ID $userId: ${_userCache[userId]?.fullName}');
      return _userCache[userId];
    }
    
    try {
      final authRepository = Get.find<AuthRepository>();
      final userData = await authRepository.firestoreUserProvider.getUser(userId);
      
      // Cache the result
      if (userData != null) {
        _userCache[userId] = userData;
        print('📋 User data fetched and cached for ID $userId: ${userData.fullName}');
      }
      
      return userData;
    } catch (e) {
      print('❌ Error fetching user data for ID $userId: $e');
      return null;
    }
  }

  // Clear user cache (useful when user data is updated)
  void clearUserCache() {
    _userCache.clear();
    print('🗑️ User cache cleared');
  }

  // Check if user is logged in
  bool get isLoggedIn {
    // Check Firebase auth first
    final firebaseLoggedIn = currentUser.value != null;

    // If not logged in via Firebase, check saved session
    if (!firebaseLoggedIn) {
      final preferenceService = Get.find<PreferenceService>();
      final sessionValid = preferenceService.hasValidSession;
      print('🔍 Checking isLoggedIn:');
      print('   - Firebase: $firebaseLoggedIn');
      print('   - Session: $sessionValid');
      return sessionValid;
    }

    print('🔍 Checking isLoggedIn: $firebaseLoggedIn (Firebase)');
    return firebaseLoggedIn;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final authRepository = Get.find<AuthRepository>();
      await authRepository.signOut();

      // Clear user data
      currentUserData.value = null;

      // Clear user session
      final preferenceService = Get.find<PreferenceService>();
      await preferenceService.clearUserSession();

      print('✅ User signed out successfully');

      // Don't clear onboarding preference on logout
      // Users shouldn't see onboarding again
      if (!preferenceService.hasCompletedOnboarding) {
        await preferenceService.setOnboardingCompleted();
      }

      // Navigate to login screen after logout
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('❌ Sign out error: $e');
      // Even if sign out fails, navigate to login screen
      Get.offAllNamed(Routes.LOGIN);
    }
  }
}
