// lib/services/solution_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/solution.dart';

class SolutionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'solutions';

  // Create a new solution
  Future<void> createSolution(Solution solution) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(solution.solutionId)
          .set(solution.toJson());
    } catch (e) {
      throw Exception('Failed to create solution: $e');
    }
  }

  // Get all solutions
  Future<List<Solution>> getAllSolutions() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch solutions: $e');
    }
  }

  // Get solution by ID
  Future<Solution?> getSolutionById(String solutionId) async {
    try {
      final doc = await _firestore
          .collection(_collection)
          .doc(solutionId)
          .get();

      if (doc.exists) {
        return Solution.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch solution: $e');
    }
  }

  // Get solutions by category
  Future<List<Solution>> getSolutionsByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('category', isEqualTo: category)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch solutions by category: $e');
    }
  }

  // Get solutions by user ID
  Future<List<Solution>> getSolutionsByUserId(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch user solutions: $e');
    }
  }

  // Update solution
  Future<void> updateSolution(Solution solution) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(solution.solutionId)
          .update(solution.toJson());
    } catch (e) {
      throw Exception('Failed to update solution: $e');
    }
  }

  // Delete solution
  Future<void> deleteSolution(String solutionId) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(solutionId)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete solution: $e');
    }
  }

  // Update solution metrics
  Future<void> updateSolutionMetrics(String solutionId, SolutionMetrics metrics) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(solutionId)
          .update({'metrics': metrics.toJson()});
    } catch (e) {
      throw Exception('Failed to update solution metrics: $e');
    }
  }

  // Get featured solutions
  Future<List<Solution>> getFeaturedSolutions() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('featured', isEqualTo: true)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch featured solutions: $e');
    }
  }

  // Search solutions
  Future<List<Solution>> searchSolutions(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('tags', arrayContains: query.toLowerCase())
          .get();

      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data()))
          .toList();
    } catch (e) {
      throw Exception('Failed to search solutions: $e');
    }
  }
}