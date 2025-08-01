import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jenga_app/models/user.dart' as user_model;

class ProfileRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<user_model.User?> loadUser(String userId) async {
    try {
      final doc = await _firestore.collection('users').doc(userId).get();
      if (!doc.exists || doc.data() == null) return null;
      final user = user_model.User.fromJson(doc.data()!);
      user.id = doc.id;
      return user;
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
  }

  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _firestore.collection('users').doc(userId).update(data);
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
  }

  Future<String?> updateProfilePicture(String userId, File imageFile) async {
    try {
      final ref = _storage.ref().child('profile_pictures/$userId.jpg');
      await ref.putFile(imageFile);
      final downloadUrl = await ref.getDownloadURL();
      await _firestore.collection('users').doc(userId).update({
        'profilePictureUrl': downloadUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return downloadUrl;
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
  }

  Future<void> changePassword(
      String email, String currentPassword, String newPassword) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('No user logged in');
      final cred =
          EmailAuthProvider.credential(email: email, password: currentPassword);
      await user.reauthenticateWithCredential(cred);
      await user.updatePassword(newPassword);
    } on FirebaseAuthException {
      rethrow;
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
  }
}
