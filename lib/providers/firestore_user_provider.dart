import 'package:cloud_firestore/cloud_firestore.dart';
<<<<<<< HEAD
import 'package:jenga_app/models/user.dart';
=======
import 'package:jenga_app/models/user.dart' as user_model;
>>>>>>> 01d847bf189b79fcfd8e4aede7fc2153a05de102

class FirestoreUserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

<<<<<<< HEAD
  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set({
      'fullName': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'profilePictureUrl': user.profilePictureUrl,
      'createdAt': user.createdAt,
      'updatedAt': user.updatedAt,
=======
  Future<void> createUser(user_model.User user) async {
    await users.doc(user.id).set(user.toJson());
  }

  Future<user_model.User?> getUser(String userId) async {
    final doc = await users.doc(userId).get();
    if (doc.exists) {
      return user_model.User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(user_model.User user) async {
    await users.doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await users.doc(userId).delete();
  }

  Stream<user_model.User?> getUserStream(String userId) {
    return users.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return user_model.User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
>>>>>>> 01d847bf189b79fcfd8e4aede7fc2153a05de102
    });
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return null;
    return UserModel.fromFirestore(doc);
  }

  Future<void> updateUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).update({
      'fullName': user.fullName,
      'phoneNumber': user.phoneNumber,
      'profilePictureUrl': user.profilePictureUrl,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<UserModel?> getUserStream(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((doc) => doc.exists ? UserModel.fromFirestore(doc) : null);
  }
}