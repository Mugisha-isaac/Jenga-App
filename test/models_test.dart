// Unit tests for model classes
import 'package:flutter_test/flutter_test.dart';
import 'package:jenga_app/models/user.dart';
import 'package:jenga_app/models/solution.dart';

void main() {
  group('User Model Tests', () {
    test('User model should be created with default values', () {
      final user = User();

      expect(user.id, isNull);
      expect(user.fullName, isNull);
      expect(user.email, isNull);
      expect(user.phoneNumber, isNull);
      expect(user.profilePictureUrl, isNull);
      expect(user.createdAt, isNull);
      expect(user.updatedAt, isNull);
      expect(user.isActive, isTrue); // Default should be true
    });

    test('User model should be created with provided values', () {
      final now = DateTime.now();
      final user = User(
        id: 'user123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://example.com/avatar.jpg',
        createdAt: now,
        updatedAt: now,
        isActive: false,
      );

      expect(user.id, 'user123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phoneNumber, '+1234567890');
      expect(user.profilePictureUrl, 'https://example.com/avatar.jpg');
      expect(user.createdAt, now);
      expect(user.updatedAt, now);
      expect(user.isActive, isFalse);
    });

    test('User model should convert to JSON correctly', () {
      final now = DateTime.now();
      final user = User(
        id: 'user123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '+1234567890',
        profilePictureUrl: 'https://example.com/avatar.jpg',
        createdAt: now,
        updatedAt: now,
        isActive: true,
      );

      final json = user.toJson();

      expect(json['id'], 'user123');
      expect(json['fullName'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phoneNumber'], '+1234567890');
      expect(json['profilePictureUrl'], 'https://example.com/avatar.jpg');
      expect(json['createdAt'], now);
      expect(json['updatedAt'], now);
      expect(json['isActive'], isTrue);
    });

    test('User model should create from JSON correctly', () {
      final json = {
        'id': 'user123',
        'fullName': 'John Doe',
        'email': 'john@example.com',
        'phoneNumber': '+1234567890',
        'profilePictureUrl': 'https://example.com/avatar.jpg',
        'isActive': true,
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.fullName, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.phoneNumber, '+1234567890');
      expect(user.profilePictureUrl, 'https://example.com/avatar.jpg');
      expect(user.isActive, isTrue);
    });

    test('User model should handle null values in JSON', () {
      final json = <String, dynamic>{
        'id': 'user123',
        'fullName': null,
        'email': 'john@example.com',
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.fullName, isNull);
      expect(user.email, 'john@example.com');
      expect(user.phoneNumber, isNull);
      expect(user.isActive, isTrue); // Should default to true
    });

    test('User model should handle missing isActive field in JSON', () {
      final json = {
        'id': 'user123',
        'email': 'john@example.com',
        // isActive is missing
      };

      final user = User.fromJson(json);

      expect(user.id, 'user123');
      expect(user.email, 'john@example.com');
      expect(user.isActive, isTrue); // Should default to true when missing
    });

    test('User model toJson should set updatedAt if not provided', () {
      final user = User(
        id: 'user123',
        fullName: 'John Doe',
        email: 'john@example.com',
        // updatedAt is not set
      );

      final json = user.toJson();

      expect(json['updatedAt'], isA<DateTime>());
      expect(json['updatedAt'], isNotNull);
    });
  });

  group('Solution Model Tests', () {
    test('Solution model should be created with required values', () {
      final now = DateTime.now();
      final solution = Solution(
        solutionId: 'sol123',
        title: 'Test Solution',
        description: 'A test solution',
        category: 'Technology',
        userId: 'user123',
        country: 'Rwanda',
        city: 'Kigali',
        images: [],
        materials: ['Material 1', 'Material 2'],
        steps: [],
        tags: ['tag1', 'tag2'],
        metrics: SolutionMetrics(
          views: 10,
          likes: 5,
          saves: 2,
          shares: 1,
        ),
        createdAt: now,
        updatedAt: now,
      );

      expect(solution.solutionId, 'sol123');
      expect(solution.title, 'Test Solution');
      expect(solution.description, 'A test solution');
      expect(solution.category, 'Technology');
      expect(solution.userId, 'user123');
      expect(solution.country, 'Rwanda');
      expect(solution.city, 'Kigali');
      expect(solution.materials, ['Material 1', 'Material 2']);
      expect(solution.tags, ['tag1', 'tag2']);
      expect(solution.isPremium, isFalse); // Default value
      expect(solution.featured, isFalse); // Default value
      expect(solution.comments, isEmpty); // Default empty list
      expect(solution.premiumPrice, isNull); // Default null
    });

    test('Solution model should handle premium solutions', () {
      final now = DateTime.now();
      final solution = Solution(
        solutionId: 'sol123',
        title: 'Premium Solution',
        description: 'A premium solution',
        category: 'Technology',
        userId: 'user123',
        country: 'Rwanda',
        city: 'Kigali',
        images: [],
        materials: [],
        steps: [],
        tags: [],
        metrics: SolutionMetrics(views: 0, likes: 0, saves: 0, shares: 0),
        premiumPrice: 19.99,
        isPremium: true,
        featured: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(solution.isPremium, isTrue);
      expect(solution.premiumPrice, 19.99);
      expect(solution.featured, isTrue);
    });

    test('Solution model should convert to JSON correctly', () {
      final now = DateTime.now();
      final solution = Solution(
        solutionId: 'sol123',
        title: 'Test Solution',
        description: 'A test solution',
        category: 'Technology',
        userId: 'user123',
        country: 'Rwanda',
        city: 'Kigali',
        images: [],
        materials: ['Material 1'],
        steps: [],
        tags: ['tag1'],
        metrics: SolutionMetrics(views: 10, likes: 5, saves: 2, shares: 1),
        createdAt: now,
        updatedAt: now,
      );

      final json = solution.toJson();

      expect(json['solutionId'], 'sol123');
      expect(json['title'], 'Test Solution');
      expect(json['description'], 'A test solution');
      expect(json['category'], 'Technology');
      expect(json['userId'], 'user123');
      expect(json['country'], 'Rwanda');
      expect(json['city'], 'Kigali');
      expect(json['materials'], ['Material 1']);
      expect(json['tags'], ['tag1']);
      expect(json['isPremium'], isFalse);
      expect(json['featured'], isFalse);
    });
  });

  group('Solution Metrics Tests', () {
    test('SolutionMetrics should be created with provided values', () {
      final metrics = SolutionMetrics(
        views: 100,
        likes: 25,
        saves: 10,
        shares: 5,
        comments: 15,
        implementations: 3,
      );

      expect(metrics.views, 100);
      expect(metrics.likes, 25);
      expect(metrics.saves, 10);
      expect(metrics.shares, 5);
      expect(metrics.comments, 15);
      expect(metrics.implementations, 3);
    });

    test('SolutionMetrics should handle default values', () {
      final metrics = SolutionMetrics();

      expect(metrics.views, 0);
      expect(metrics.likes, 0);
      expect(metrics.saves, 0);
      expect(metrics.shares, 0);
      expect(metrics.comments, 0);
      expect(metrics.implementations, 0);
    });

    test('SolutionMetrics should convert to JSON correctly', () {
      final metrics = SolutionMetrics(
        views: 100,
        likes: 25,
        saves: 10,
        shares: 5,
        comments: 15,
        implementations: 3,
      );

      final json = metrics.toJson();

      expect(json['views'], 100);
      expect(json['likes'], 25);
      expect(json['saves'], 10);
      expect(json['shares'], 5);
      expect(json['comments'], 15);
      expect(json['implementations'], 3);
    });

    test('SolutionMetrics should create from JSON correctly', () {
      final json = {
        'views': 100,
        'likes': 25,
        'saves': 10,
        'shares': 5,
        'comments': 15,
        'implementations': 3,
      };

      final metrics = SolutionMetrics.fromJson(json);

      expect(metrics.views, 100);
      expect(metrics.likes, 25);
      expect(metrics.saves, 10);
      expect(metrics.shares, 5);
      expect(metrics.comments, 15);
      expect(metrics.implementations, 3);
    });
  });

  group('Solution Image Tests', () {
    test('SolutionImage should be created with URL', () {
      final image = SolutionImage(url: 'https://example.com/image.jpg');

      expect(image.url, 'https://example.com/image.jpg');
    });

    test('SolutionImage should convert to JSON correctly', () {
      final image = SolutionImage(url: 'https://example.com/image.jpg');
      final json = image.toJson();

      expect(json['url'], 'https://example.com/image.jpg');
    });

    test('SolutionImage should create from JSON correctly', () {
      final json = {'url': 'https://example.com/image.jpg'};
      final image = SolutionImage.fromJson(json);

      expect(image.url, 'https://example.com/image.jpg');
    });
  });

  group('Solution Step Tests', () {
    test('SolutionStep should be created with step number and description', () {
      final step = SolutionStep(
        stepNumber: 1,
        description: 'First step in the solution',
      );

      expect(step.stepNumber, 1);
      expect(step.description, 'First step in the solution');
    });

    test('SolutionStep should convert to JSON correctly', () {
      final step = SolutionStep(
        stepNumber: 1,
        description: 'First step in the solution',
      );
      final json = step.toJson();

      expect(json['stepNumber'], 1);
      expect(json['description'], 'First step in the solution');
    });

    test('SolutionStep should create from JSON correctly', () {
      final json = {
        'stepNumber': 1,
        'description': 'First step in the solution',
      };
      final step = SolutionStep.fromJson(json);

      expect(step.stepNumber, 1);
      expect(step.description, 'First step in the solution');
    });
  });
}
