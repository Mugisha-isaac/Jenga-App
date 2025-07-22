import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jenga_app/models/user.dart' as user_model;

class FirestoreUserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get users => _firestore.collection('users');

  Future<void> createUser(user_model.User user) async {
    try {
      print('🔥 Creating user document: ${user.toJson()}');
      await users.doc(user.id).set(user.toJson());
      print('✅ User document created successfully in Firestore');
    } catch (e) {
      print('❌ Error creating user document: $e');
      rethrow;
    }
  }

  Future<user_model.User?> getUser(String userId) async {
    try {
      print('🔥 Retrieving user document for ID: $userId');
      final doc = await users.doc(userId).get();
      if (doc.exists) {
        print('✅ User document found: ${doc.data()}');
        return user_model.User.fromJson(doc.data() as Map<String, dynamic>);
      }
      print('❌ User document not found for ID: $userId');
      return null;
    } catch (e) {
      print('❌ Error retrieving user document: $e');
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
}
