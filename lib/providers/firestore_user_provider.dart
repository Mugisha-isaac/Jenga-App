import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jenga_app/models/user.dart' as user_model;

class FirestoreUserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get users => _firestore.collection('users');

  Future<void> createUser(user_model.User user) async {
    try {
      await users.doc(user.id).set(user.toJson());
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
  }

  Future<user_model.User?> getUser(String userId) async {
    try {
      final doc = await users.doc(userId).get();
      if (doc.exists) {
        return user_model.User.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    } catch (e) {
      // Ignore errors silently
      rethrow;
    }
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
    });
  }

  // Debug method to list all users (for debugging purposes)
  Future<void> debugListAllUsers() async {
    try {
      final snapshot = await users.limit(10).get();
      for (final doc in snapshot.docs) {
        // Process user data for debugging
        doc.data();
      }
    } catch (e) {
      // Ignore errors silently
    }
  }
}
