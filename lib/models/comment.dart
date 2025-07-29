// lib/models/comment.dart
class SolutionComment {
  final String commentId;
  final String solutionId;
  final String userId;
  final String userName;
  final String userEmail;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  SolutionComment({
    required this.commentId,
    required this.solutionId,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'commentId': commentId,
      'solutionId': solutionId,
      'userId': userId,
      'userName': userName,
      'userEmail': userEmail,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SolutionComment.fromJson(Map<String, dynamic> json) {
    return SolutionComment(
      commentId: json['commentId'] ?? '',
      solutionId: json['solutionId'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      userEmail: json['userEmail'] ?? '',
      content: json['content'] ?? '',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt:
          DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  SolutionComment copyWith({
    String? commentId,
    String? solutionId,
    String? userId,
    String? userName,
    String? userEmail,
    String? content,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SolutionComment(
      commentId: commentId ?? this.commentId,
      solutionId: solutionId ?? this.solutionId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
