class SolutionImage {
  final String url;
  final String id;

  SolutionImage({required this.url, required this.id});

  factory SolutionImage.fromJson(Map<String, dynamic> json) {
    return SolutionImage(
      url: json['url'] ?? '',
      id: json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'id': id,
      };
}

class Solution {
  final String id;
  final String title;
  final String description;
  final String category;
  final String userId;
  final bool featured;
  final DateTime createdAt;
  final List<SolutionImage> images;

  Solution({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.userId,
    this.featured = false,
    required this.createdAt,
    List<SolutionImage>? images,
  }) : images = images ?? [];

  factory Solution.fromJson(Map<String, dynamic> json) {
    return Solution(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'General',
      userId: json['userId'] ?? '',
      featured: json['featured'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      images: json['images'] != null
          ? (json['images'] as List)
              .map((image) => SolutionImage.fromJson(image))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category,
        'userId': userId,
        'featured': featured,
        'createdAt': createdAt.toIso8601String(),
        'images': images.map((image) => image.toJson()).toList(),
      };
}