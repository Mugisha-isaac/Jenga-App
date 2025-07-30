// lib/controllers/auth_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/routes/routes.dart';
import 'package:jenga_app/services/preference_service.dart';
import 'package:jenga_app/models/user.dart' as user_model;
import 'package:jenga_app/repositories/auth_repository.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';  

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rxn<User> currentUser = Rxn<User>();
  final Rxn<user_model.UserModel> currentUserData = Rxn<user_model.UserModel>();
  final RxBool isInitialized = false.obs;

  
  final FirestoreUserProvider firestoreUserProvider = FirestoreUserProvider();

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  void _initAuth() async {
    final preferenceService = Get.find<PreferenceService>();

    if (preferenceService.hasValidSession) {
      print('📱 Valid session found, attempting to restore user...');
      final savedUserId = preferenceService.savedUserId;
      if (savedUserId != null) {
        try {
          final userData = await firestoreUserProvider.getUser(savedUserId);
          if (userData != null) {
            currentUserData.value = userData;
            print(' User session restored: ${userData.fullName}');
          }
        } catch (e) {
          print(' Error restoring session: $e');
          await preferenceService.clearUserSession();
        }
      }
    }

    currentUser.value = _auth.currentUser;
    currentUser.bindStream(_auth.authStateChanges());

    ever(currentUser, (User? user) {
      print(' Auth state changed: ${user?.uid ?? 'null'}');
      if (user != null) {
        print(' User is logged in: ${user.email}');
        _loadUserData(user.uid);
      } else {
        print(' User is logged out');
        currentUserData.value = null;
      }
    });

    isInitialized.value = true;
    print(' AuthController initialized');
  }

  void _loadUserData(String userId) async {
    try {
      final userData = await firestoreUserProvider.getUser(userId);
      currentUserData.value = userData;
      print(' User data loaded: ${userData?.fullName}');

      if (userData != null && currentUser.value != null) {
        final preferenceService = Get.find<PreferenceService>();
        await preferenceService.saveUserSession(
          userId: userId,
          email: currentUser.value!.email ?? userData.email ?? '',
          fullName: userData.fullName,
        );
      }
    } catch (e) {
      print(' Error loading user data: $e');
    }
  }

  
  void setCurrentUser(user_model.UserModel user) async {
    currentUserData.value = user;
    print(' Current user data set: ${user.fullName}');

    final preferenceService = Get.find<PreferenceService>();
    await preferenceService.saveUserSession(
      userId: user.id ?? '',
      email: user.email ?? '',
      fullName: user.fullName,
    );
  }

  String get userId => currentUser.value?.uid ?? 'user123';

  bool get isLoggedIn {
    final firebaseLoggedIn = currentUser.value != null;

    if (!firebaseLoggedIn) {
      final preferenceService = Get.find<PreferenceService>();
      final sessionValid = preferenceService.hasValidSession;
      print(' Checking isLoggedIn:');
      print('   - Firebase: $firebaseLoggedIn');
      print('   - Session: $sessionValid');
      return sessionValid;
    }

    print(' Checking isLoggedIn: $firebaseLoggedIn (Firebase)');
    return firebaseLoggedIn;
  }

  Future<void> signOut() async {
    try {
      final authRepository = Get.find<AuthRepository>();
      await authRepository.signOut();

      currentUserData.value = null;

      final preferenceService = Get.find<PreferenceService>();
      await preferenceService.clearUserSession();

      print(' User signed out successfully');

      if (!preferenceService.hasCompletedOnboarding) {
        await preferenceService.setOnboardingCompleted();
      }

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      print(' Sign out error: $e');
    }
  }
}