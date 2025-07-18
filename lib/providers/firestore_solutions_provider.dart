import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jenga_app/models/solution.dart';

class FirestoreSolutionsProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  CollectionReference get solutions => _firestore.collection('solutions');

  /// Create a new solution
  Future<void> createSolution(Solution solution) async {
    await solutions.doc(solution.solutionId).set(solution.toJson());
  }

  /// Get all solutions with pagination
  Future<List<Solution>> getAllSolutions({
    int? limit,
    String? lastSolutionId,
    bool descending = true,
  }) async {
    Query query = solutions.orderBy('createdAt', descending: descending);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get solution by ID
  Future<Solution?> getSolutionById(String solutionId) async {
    final doc = await solutions.doc(solutionId).get();
    if (doc.exists) {
      return Solution.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null;
  }

  /// Get solutions by category
  Future<List<Solution>> getSolutionsByCategory(
    String category, {
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get solutions by user ID
  Future<List<Solution>> getSolutionsByUserId(
    String userId, {
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Update an existing solution
  Future<void> updateSolution(Solution solution) async {
    await solutions.doc(solution.solutionId).update(solution.toJson());
  }

  /// Delete a solution
  Future<void> deleteSolution(String solutionId) async {
    await solutions.doc(solutionId).delete();
  }

  /// Update solution metrics
  Future<void> updateSolutionMetrics(
    String solutionId,
    SolutionMetrics metrics,
  ) async {
    await solutions.doc(solutionId).update({'metrics': metrics.toJson()});
  }

  /// Increment specific metric
  Future<void> incrementMetric(String solutionId, String metricType) async {
    await _firestore.runTransaction((transaction) async {
      final docRef = solutions.doc(solutionId);
      final doc = await transaction.get(docRef);

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        final metrics = data['metrics'] as Map<String, dynamic>? ?? {};
        final currentValue = metrics[metricType] as int? ?? 0;

        metrics[metricType] = currentValue + 1;

        transaction.update(docRef, {'metrics': metrics});
      }
    });
  }

  /// Get featured solutions
  Future<List<Solution>> getFeaturedSolutions({
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions
        .where('featured', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Search solutions by query (searches in tags)
  Future<List<Solution>> searchSolutions(
    String query, {
    int? limit,
    String? lastSolutionId,
  }) async {
    Query firestoreQuery = solutions
        .where('tags', arrayContains: query.toLowerCase())
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      firestoreQuery = firestoreQuery.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        firestoreQuery = firestoreQuery.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await firestoreQuery.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get solutions by tags
  Future<List<Solution>> getSolutionsByTags(
    List<String> tags, {
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions
        .where(
          'tags',
          arrayContainsAny: tags.map((tag) => tag.toLowerCase()).toList(),
        )
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get solutions by location
  Future<List<Solution>> getSolutionsByLocation({
    String? country,
    String? city,
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions.orderBy('createdAt', descending: true);

    if (country != null) {
      query = query.where('country', isEqualTo: country);
    }

    if (city != null) {
      query = query.where('city', isEqualTo: city);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get premium solutions
  Future<List<Solution>> getPremiumSolutions({
    int? limit,
    String? lastSolutionId,
  }) async {
    Query query = solutions
        .where('isPremium', isEqualTo: true)
        .orderBy('createdAt', descending: true);

    if (limit != null) {
      query = query.limit(limit);
    }

    if (lastSolutionId != null) {
      final lastDoc = await solutions.doc(lastSolutionId).get();
      if (lastDoc.exists) {
        query = query.startAfterDocument(lastDoc);
      }
    }

    final querySnapshot = await query.get();
    return querySnapshot.docs
        .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// Get solutions stream for real-time updates
  Stream<List<Solution>> getSolutionsStream({
    int? limit,
    String? category,
    String? userId,
    bool? featured,
    bool? isPremium,
  }) {
    Query query = solutions.orderBy('createdAt', descending: true);

    if (category != null) {
      query = query.where('category', isEqualTo: category);
    }

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    if (featured != null) {
      query = query.where('featured', isEqualTo: featured);
    }

    if (isPremium != null) {
      query = query.where('isPremium', isEqualTo: isPremium);
    }

    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs
          .map((doc) => Solution.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  /// Get solution stream for real-time updates
  Stream<Solution?> getSolutionStream(String solutionId) {
    return solutions.doc(solutionId).snapshots().map((doc) {
      if (doc.exists) {
        return Solution.fromJson(doc.data() as Map<String, dynamic>);
      }
      return null;
    });
  }
}
