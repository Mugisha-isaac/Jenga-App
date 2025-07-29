// lib/models/paid_solution.dart
class PaidSolution {
  final String id;
  final String solutionId;
  final String userId;
  final DateTime purchaseDate;
  final double amountPaid;
  final String paymentMethod;
  final String transactionId;

  PaidSolution({
    required this.id,
    required this.solutionId,
    required this.userId,
    required this.purchaseDate,
    required this.amountPaid,
    required this.paymentMethod,
    required this.transactionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'solutionId': solutionId,
      'userId': userId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'amountPaid': amountPaid,
      'paymentMethod': paymentMethod,
      'transactionId': transactionId,
    };
  }

  factory PaidSolution.fromJson(Map<String, dynamic> json) {
    return PaidSolution(
      id: json['id'],
      solutionId: json['solutionId'],
      userId: json['userId'],
      purchaseDate: DateTime.parse(json['purchaseDate']),
      amountPaid: json['amountPaid']?.toDouble() ?? 0.0,
      paymentMethod: json['paymentMethod'],
      transactionId: json['transactionId'],
    );
  }

  PaidSolution copyWith({
    String? id,
    String? solutionId,
    String? userId,
    DateTime? purchaseDate,
    double? amountPaid,
    String? paymentMethod,
    String? transactionId,
  }) {
    return PaidSolution(
      id: id ?? this.id,
      solutionId: solutionId ?? this.solutionId,
      userId: userId ?? this.userId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      amountPaid: amountPaid ?? this.amountPaid,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      transactionId: transactionId ?? this.transactionId,
    );
  }
}
