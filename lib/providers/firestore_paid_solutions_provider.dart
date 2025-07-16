// lib/providers/firestore_paid_solutions_provider.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/paid_solution.dart';

class FirestorePaidSolutionsProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get paidSolutions =>
      _firestore.collection('paid_solutions');

  Future<void> createPaidSolution(PaidSolution paidSolution) async {
    await paidSolutions.doc(paidSolution.id).set(paidSolution.toJson());
  }

  Future<PaidSolution?> getPaidSolution(String id) async {
    final doc = await paidSolutions.doc(id).get();
    if (doc.exists) {
      return PaidSolution.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  Future<List<PaidSolution>> getPaidSolutionsByUser(String userId) async {
    final querySnapshot = await paidSolutions
        .where('userId', isEqualTo: userId)
        .get();

    return querySnapshot.docs
        .map((doc) => PaidSolution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> hasUserPaidForSolution(String userId, String solutionId) async {
    final querySnapshot = await paidSolutions
        .where('userId', isEqualTo: userId)
        .where('solutionId', isEqualTo: solutionId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<void> deletePaidSolution(String id) async {
    await paidSolutions.doc(id).delete();
  }

  Stream<List<PaidSolution>> getPaidSolutionsByUserStream(String userId) {
    return paidSolutions
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) =>
                    PaidSolution.fromJson(doc.data() as Map<String, dynamic>),
              )
              .toList(),
        );
  }
}
