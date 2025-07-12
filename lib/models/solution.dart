// lib/models/solution.dart
class Solution {
  final String solutionId;
  final String title;
  final String description;
  final String category;
  final String userId;
  final String country;
  final String city;
  final List<SolutionImage> images;
  final List<String> materials;
  final List<SolutionStep> steps;
  final List<String> tags;
  final SolutionMetrics metrics;
  final double? premiumPrice;
  final bool isPremium;
  final bool featured;
  final DateTime createdAt;
  final DateTime updatedAt;

  Solution({
    required this.solutionId,
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
    required this.country,
    required this.city,
    required this.images,
    required this.materials,
    required this.steps,
    required this.tags,
    required this.metrics,
    this.premiumPrice,
    this.isPremium = false,
    this.featured = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'solutionId': solutionId,
      'title': title,
      'description': description,
      'category': category,
      'userId': userId,
      'country': country,
      'city': city,
      'images': images.map((img) => img.toJson()).toList(),
      'materials': materials,
      'steps': steps.map((step) => step.toJson()).toList(),
      'tags': tags,
      'metrics': metrics.toJson(),
      'premiumPrice': premiumPrice,
      'isPremium': isPremium,
      'featured': featured,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      solutionId: json['solutionId'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      userId: json['userId'],
      country: json['country'],
      city: json['city'],
      images: (json['images'] as List)
          .map((img) => SolutionImage.fromJson(img))
          .toList(),
      materials: List<String>.from(json['materials']),
      steps: (json['steps'] as List)
          .map((step) => SolutionStep.fromJson(step))
          .toList(),
      tags: List<String>.from(json['tags']),
      metrics: SolutionMetrics.fromJson(json['metrics']),
      premiumPrice: json['premiumPrice']?.toDouble(),
      isPremium: json['isPremium'] ?? false,
      featured: json['featured'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}

class SolutionImage {
  final String url;

  SolutionImage({required this.url});

  Map<String, dynamic> toJson() => {'url': url};

  factory SolutionImage.fromJson(Map<String, dynamic> json) {
    return SolutionImage(url: json['url']);
  }
}

class SolutionStep {
  final int stepNumber;
  final String description;

  SolutionStep({required this.stepNumber, required this.description});

  Map<String, dynamic> toJson() => {
    'stepNumber': stepNumber,
    'description': description,
  };

  factory SolutionStep.fromJson(Map<String, dynamic> json) {
    return SolutionStep(
      stepNumber: json['stepNumber'],
      description: json['description'],
    );
  }
}

class SolutionMetrics {
  final int views;
  final int likes;
  final int saves;
  final int comments;
  final int implementations;
  final int shares;

  SolutionMetrics({
    this.views = 0,
    this.likes = 0,
    this.saves = 0,
    this.comments = 0,
    this.implementations = 0,
    this.shares = 0,
  });

  Map<String, dynamic> toJson() => {
    'views': views,
    'likes': likes,
    'saves': saves,
    'comments': comments,
    'implementations': implementations,
    'shares': shares,
  };

  factory SolutionMetrics.fromJson(Map<String, dynamic> json) {
    return SolutionMetrics(
      views: json['views'] ?? 0,
      likes: json['likes'] ?? 0,
      saves: json['saves'] ?? 0,
      comments: json['comments'] ?? 0,
      implementations: json['implementations'] ?? 0,
      shares: json['shares'] ?? 0,
    );
  }
}