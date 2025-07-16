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
    final userCredential = await firebaseAuthProvider
        .signInWithEmailAndPassword(email, password);

    final user = await firestoreUserProvider.getUser(userCredential.user!.uid);
    if (user == null) {
      throw Exception('User data not found');
    }
    return user;
  }

  Future<user_model.User> createUserWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String phoneNumber,
  ) async {
    final userCredential = await firebaseAuthProvider
        .createUserWithEmailAndPassword(email, password);

    final user = user_model.User(
      id: userCredential.user!.uid,
      email: email,
      fullName: fullName,
      phoneNumber: phoneNumber,
    );

    await firestoreUserProvider.createUser(user);
    return user;
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
