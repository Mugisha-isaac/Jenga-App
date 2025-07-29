import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:jenga_app/models/user.dart';
import 'package:jenga_app/providers/firestore_user_provider.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirestoreUserProvider _userProvider = FirestoreUserProvider();

  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) throw Exception('User is null');
      
      final userData = await _userProvider.getUser(user.uid) ??
          await _createUserInFirestore(user);
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> createUserWithEmailAndPassword(
    String email,
    String password,
    String fullName,
    String? phoneNumber,
  ) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');
      
      final userModel = UserModel(
        id: user.uid,
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _userProvider.createUser(userModel);
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) throw Exception('Google sign in was aborted');
      
      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      
      final userCredential = 
          await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) throw Exception('Google sign in failed');
      
      final userData = await _userProvider.getUser(user.uid) ??
          await _createUserInFirestore(user);
      return userData;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> _createUserInFirestore(User user) async {
    final userModel = UserModel(
      id: user.uid,
      fullName: user.displayName ?? 'User',
      email: user.email ?? '',
      phoneNumber: user.phoneNumber,
      profilePictureUrl: user.photoURL,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    
    await _userProvider.createUser(userModel);
    return userModel;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await GoogleSignIn().signOut();
  }
}