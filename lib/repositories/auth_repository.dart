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

      print('🔥 Retrieving user document from Firestore for ${userCredential.user!.uid}');
      final user = await firestoreUserProvider.getUser(userCredential.user!.uid);
      if (user == null) {
        throw Exception('User data not found');
      }
      print('✅ User document retrieved successfully');
      return user;
    } catch (e) {
      print('❌ Error in signInWithEmailAndPassword: $e');
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

      print('🔥 Creating user document in Firestore for ${user.id}');
      await firestoreUserProvider.createUser(user);
      print('✅ User document created successfully');
      return user;
    } catch (e) {
      print('❌ Error in createUserWithEmailAndPassword: $e');
      rethrow;
    }
  }

  Future<void> signOut() async {
    await firebaseAuthProvider.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuthProvider.sendPasswordResetEmail(email);
  }

  User? get currentUser => firebaseAuthProvider.currentUser;

  Stream<User?> get authStateChanges => firebaseAuthProvider.authStateChanges;
}
