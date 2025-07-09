import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jenga_app/models/user.dart' as UserModel;

class FirestoreUserProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get users => _firestore.collection('users');

  Future<void> createUser(UserModel.User user) async {
    await users.doc(user.id).set(user.toJson());
  }

  Future<UserModel.User?> getUser(String userId) async {
    final doc = await users.doc(userId).get();
    if (doc.exists) {
      return UserModel.User.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<void> updateUser(UserModel.User user) async {
    await users.doc(user.id).update(user.toJson());
  }

  Future<void> deleteUser(String userId) async {
    await users.doc(userId).delete();
  }

  Stream<UserModel.User?> getUserStream(String userId) {
    return users.doc(userId).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.User.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
