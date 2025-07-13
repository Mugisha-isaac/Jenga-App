import 'package:jenga_app/models/solution.dart';
import 'package:jenga_app/providers/firestore_solutions_provider.dart';

class SolutionRepository {
  final FirestoreSolutionsProvider firestoreSolutionsProvider;

  SolutionRepository({required this.firestoreSolutionsProvider});

  /// Create a new solution
  Future<void> createSolution(Solution solution) async {
    try {
      await firestoreSolutionsProvider.createSolution(solution);
    } catch (e) {
      throw Exception('Failed to create solution: $e');
    }
  }

  /// Get all solutions with optional filtering
  Future<List<Solution>> getAllSolutions({
    int? limit,
    String? lastSolutionId,
    bool descending = true,
  }) async {
    try {
      return await firestoreSolutionsProvider.getAllSolutions(
        limit: limit,
        lastSolutionId: lastSolutionId,
        descending: descending,
      );
    } catch (e) {
      throw Exception('Failed to fetch solutions: $e');
    }
  }

  /// Get solution by ID
  Future<Solution?> getSolutionById(String solutionId) async {
    try {
      return await firestoreSolutionsProvider.getSolutionById(solutionId);
    } catch (e) {
      throw Exception('Failed to fetch solution: $e');
    }
  }

  /// Get solutions by category
  Future<List<Solution>> getSolutionsByCategory(
    String category, {
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getSolutionsByCategory(
        category,
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch solutions by category: $e');
    }
  }

  /// Get solutions by user ID
  Future<List<Solution>> getSolutionsByUserId(
    String userId, {
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getSolutionsByUserId(
        userId,
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch user solutions: $e');
    }
  }

  /// Update an existing solution
  Future<void> updateSolution(Solution solution) async {
    try {
      await firestoreSolutionsProvider.updateSolution(solution);
    } catch (e) {
      throw Exception('Failed to update solution: $e');
    }
  }

  /// Delete a solution
  Future<void> deleteSolution(String solutionId) async {
    try {
      await firestoreSolutionsProvider.deleteSolution(solutionId);
    } catch (e) {
      throw Exception('Failed to delete solution: $e');
    }
  }

  /// Update solution metrics (views, likes, saves, etc.)
  Future<void> updateSolutionMetrics(
    String solutionId,
    SolutionMetrics metrics,
  ) async {
    try {
      await firestoreSolutionsProvider.updateSolutionMetrics(
        solutionId,
        metrics,
      );
    } catch (e) {
      throw Exception('Failed to update solution metrics: $e');
    }
  }

  /// Increment specific metric
  Future<void> incrementMetric(String solutionId, String metricType) async {
    try {
      await firestoreSolutionsProvider.incrementMetric(solutionId, metricType);
    } catch (e) {
      throw Exception('Failed to increment metric: $e');
    }
  }

  /// Get featured solutions
  Future<List<Solution>> getFeaturedSolutions({
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getFeaturedSolutions(
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch featured solutions: $e');
    }
  }

  /// Search solutions by query
  Future<List<Solution>> searchSolutions(
    String query, {
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.searchSolutions(
        query,
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to search solutions: $e');
    }
  }

  /// Get solutions by multiple tags
  Future<List<Solution>> getSolutionsByTags(
    List<String> tags, {
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getSolutionsByTags(
        tags,
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch solutions by tags: $e');
    }
  }

  /// Get solutions by location (country and/or city)
  Future<List<Solution>> getSolutionsByLocation({
    String? country,
    String? city,
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getSolutionsByLocation(
        country: country,
        city: city,
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch solutions by location: $e');
    }
  }

  /// Get premium solutions
  Future<List<Solution>> getPremiumSolutions({
    int? limit,
    String? lastSolutionId,
  }) async {
    try {
      return await firestoreSolutionsProvider.getPremiumSolutions(
        limit: limit,
        lastSolutionId: lastSolutionId,
      );
    } catch (e) {
      throw Exception('Failed to fetch premium solutions: $e');
    }
  }

  /// Get solutions stream for real-time updates
  Stream<List<Solution>> getSolutionsStream({
    int? limit,
    String? category,
    String? userId,
    bool? featured,
    bool? isPremium,
  }) {
    try {
      return firestoreSolutionsProvider.getSolutionsStream(
        limit: limit,
        category: category,
        userId: userId,
        featured: featured,
        isPremium: isPremium,
      );
    } catch (e) {
      throw Exception('Failed to get solutions stream: $e');
    }
  }

  /// Get solution stream for real-time updates
  Stream<Solution?> getSolutionStream(String solutionId) {
    try {
      return firestoreSolutionsProvider.getSolutionStream(solutionId);
    } catch (e) {
      throw Exception('Failed to get solution stream: $e');
    }
  }
}
