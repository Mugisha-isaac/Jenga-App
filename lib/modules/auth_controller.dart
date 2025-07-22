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

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  void _initAuth() async {
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
      final userData = await authRepository.firestoreUserProvider.getUser(userId);
      currentUserData.value = userData;
      print('📋 User data loaded: ${userData?.fullName}');
    } catch (e) {
      print('❌ Error loading user data: $e');
    }
  }

  // Set current user data (called after login/register)
  void setCurrentUser(user_model.User user) {
    currentUserData.value = user;
    print('👤 Current user data set: ${user.fullName}');
  }

  // Get current user ID
  String get userId => currentUser.value?.uid ?? 'user123';

  // Check if user is logged in
  bool get isLoggedIn {
    final loggedIn = currentUser.value != null;
    print('🔍 Checking isLoggedIn: $loggedIn');
    return loggedIn;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      final authRepository = Get.find<AuthRepository>();
      await authRepository.signOut();
      
      // Clear user data
      currentUserData.value = null;
      
      print('✅ User signed out successfully');
      
      // Don't clear onboarding preference on logout
      // Users shouldn't see onboarding again
      final preferenceService = Get.find<PreferenceService>();
      if (!preferenceService.hasCompletedOnboarding) {
        await preferenceService.setOnboardingCompleted();
      }
      
      // Navigate to login screen after logout
      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print('❌ Sign out error: $e');
    }
  }
}