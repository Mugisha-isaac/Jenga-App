import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSolutionsProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get solutions => _firestore.collection('solutions');

  // solution operations
}
