// lib/repositories/paid_solution_repository.dart
import '../models/paid_solution.dart';
import '../providers/firestore_paid_solutions_provider.dart';

class PaidSolutionRepository {
  final FirestorePaidSolutionsProvider firestorePaidSolutionsProvider;

  PaidSolutionRepository({required this.firestorePaidSolutionsProvider});

  Future<void> createPaidSolution(PaidSolution paidSolution) async {
    await firestorePaidSolutionsProvider.createPaidSolution(paidSolution);
  }

  Future<PaidSolution?> getPaidSolution(String id) async {
    return await firestorePaidSolutionsProvider.getPaidSolution(id);
  }

  Future<List<PaidSolution>> getPaidSolutionsByUser(String userId) async {
    return await firestorePaidSolutionsProvider.getPaidSolutionsByUser(userId);
  }

  Future<bool> hasUserPaidForSolution(String userId, String solutionId) async {
    return await firestorePaidSolutionsProvider.hasUserPaidForSolution(
      userId,
      solutionId,
    );
  }

  Future<void> deletePaidSolution(String id) async {
    await firestorePaidSolutionsProvider.deletePaidSolution(id);
  }

  Stream<List<PaidSolution>> getPaidSolutionsByUserStream(String userId) {
    return firestorePaidSolutionsProvider.getPaidSolutionsByUserStream(userId);
  }
}
