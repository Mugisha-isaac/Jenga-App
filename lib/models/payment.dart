// lib/models/payment.dart
class PaymentTransaction {
  final String transactionId;
  final String paymentId;
  final String payerId;
  final double amount;
  final String currency;
  final String status;
  final DateTime createdAt;
  final Map<String, dynamic>? additionalData;

  PaymentTransaction({
    required this.transactionId,
    required this.paymentId,
    required this.payerId,
    required this.amount,
    this.currency = 'USD',
    this.status = 'completed',
    required this.createdAt,
    this.additionalData,
  });

  Map<String, dynamic> toJson() {
    return {
      'transactionId': transactionId,
      'paymentId': paymentId,
      'payerId': payerId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  factory PaymentTransaction.fromJson(Map<String, dynamic> json) {
    return PaymentTransaction(
      transactionId: json['transactionId'],
      paymentId: json['paymentId'],
      payerId: json['payerId'],
      amount: json['amount']?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      status: json['status'] ?? 'completed',
      createdAt: DateTime.parse(json['createdAt']),
      additionalData: json['additionalData'],
    );
  }
}

class PaymentItem {
  final String name;
  final int quantity;
  final double price;
  final String currency;

  PaymentItem({
    required this.name,
    this.quantity = 1,
    required this.price,
    this.currency = 'USD',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price.toStringAsFixed(2),
      'currency': currency,
    };
  }
}