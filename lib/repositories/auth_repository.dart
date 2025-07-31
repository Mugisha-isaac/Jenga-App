import 'package:firebase_auth/firebase_auth.dart';
import 'package:jenga_app/models/user.dart' as user_model;
import 'package:jenga_app/providers/firebase_auth_provider.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';

class AuthRepository {
  final FirebaseAuthProvider firebaseAuthProvider;
  final FirestoreUserProvider firestoreUserProvider;

  AuthRepository({
    required this.firebaseAuthProvider,
    required this.firestoreUserProvider,
  });

  Future<user_model.User> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await firebaseAuthProvider
          .signInWithEmailAndPassword(email, password);

      final user =
          await firestoreUserProvider.getUser(userCredential.user!.uid);
      if (user == null) {
        throw Exception('User data not found');
      }
      return user;
    } catch (e) {
        // Ignore errors silently
      rethrow;
    }
  }

  Future<user_model.User> createUserWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    try {
      final userCredential = await firebaseAuthProvider
          .createUserWithEmailAndPassword(email, password);

      final now = DateTime.now();
      final user = user_model.User(
        id: userCredential.user!.uid,
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      await firestoreUserProvider.createUser(user);
      return user;
    } catch (e) {
        // Ignore errors silently
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuthProvider.signOut();
    await firebaseAuthProvider.signOutGoogle();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuthProvider.sendPasswordResetEmail(email);
  }

  Future<user_model.User> signInWithGoogle() async {
    try {
      final userCredential = await firebaseAuthProvider.signInWithGoogle();
      final firebaseUser = userCredential.user!;


      // Check if user already exists in Firestore
      user_model.User? existingUser =
          await firestoreUserProvider.getUser(firebaseUser.uid);

      if (existingUser != null) {
        return existingUser;
      }

      // Create new user document for first-time Google sign-in
      final now = DateTime.now();
      final newUser = user_model.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName ?? 'Google User',
        phoneNumber: firebaseUser.phoneNumber ?? '',
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      await firestoreUserProvider.createUser(newUser);
      return newUser;
    } catch (e) {
        // Ignore errors silently
      rethrow;
    }
  }

  User? get currentUser => firebaseAuthProvider.currentUser;

  Stream<User?> get authStateChanges => firebaseAuthProvider.authStateChanges;
}
