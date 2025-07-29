import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jenga_app/models/user.dart';

class FirestoreUserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(UserModel user) async {
    await _firestore.collection('users').doc(user.id).set({
      'fullName': user.fullName,
      'email': user.email,
      'phoneNumber': user.phoneNumber,
      'profilePictureUrl': user.profilePictureUrl,
      'createdAt': user.createdAt,
      'updatedAt': user.updatedAt,
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